//
//  HomeVC+Relaunch.swift
//  DayBlock
//
//  Created by 김민준 on 12/27/23.
//

import UIKit

// MARK: - Exit App
extension HomeViewController {
    
    /// APP 종료 후, 트래킹 모드를 다시 설정하는 메서드입니다.
    func setTrackingModeAfterAppRestart() {
        let lastTrackingTime = UserDefaultsItem.shared.trackingSecondBeforeAppTermination
        
        // 일시정시 시간 업데이트
        timerManager.pausedTime = UserDefaultsItem.shared.pausedSeconds
        
        // MARK: - 일시정지 되었을 경우
        guard !UserDefaultsItem.shared.isPaused else {
            let originalPausedSecond = UserDefaultsItem.shared.pausedSeconds
            let elapsedSeconds = trackingData.calculateElapsedTimeSinceAppExit
            
            // 만약 일시정지 된지 12시간이 지났다면, 트래킹 종료
            if elapsedSeconds >= 43200 {
                stopTracking()
                return
            }
            
            timerManager.pausedTime = originalPausedSecond + elapsedSeconds
            
            // 일시정지되었다면 마지막 트래킹 시간 그대로 업데이트
            updateTrackingTimeResultAfterAppRestart(result: lastTrackingTime)
            
            // 트래킹 보드 저장된 값으로 업데이트
            trackingBoardService.replaceTrackingSeconds(to: UserDefaultsItem.shared.trackingSeconds)
            
            // 트래킹 모드 시작
            viewManager.trackingRestartForDisconnect()
            viewManager.trackingButtonTapped()
            return
        }
        
        
        // MARK: - 트래킹 진행 중인 경우
        
        let dayElapsed = trackingData.calculateElapsedDaySinceAppExit
        let timeElapsed = trackingData.calculateElapsedTimeSinceAppExit
        
        // 마지막 트래킹 시간 + 흐른 시간으로 트래킹 시간 업데이트
        updateTrackingTimeResultAfterAppRestart(result: lastTrackingTime + timeElapsed)
        
        // 트래킹 보드 업데이트
        trackingBoardService.replaceTrackingSeconds(to: UserDefaultsItem.shared.trackingSeconds)
        
        
        // MARK: - 블럭이 생산되지 않은 경우
        
        // APP 종료 전 마지막 시간 계산
        var lastCurrentSecond = lastTrackingTime
        while lastCurrentSecond > trackingData.targetSecond {
            lastCurrentSecond -= trackingData.targetSecond
        }
        
        let countSecond = lastCurrentSecond + timeElapsed
        guard countSecond >= trackingData.targetSecond else {
            viewManager.trackingRestartForDisconnect()
            return
        }
        
        
        // MARK: - 블럭이 생산된 경우
        let blockCount = countSecond / trackingData.targetSecond
        
        // 앱 종료 동안 생성되었던 데이터 생성
        for _ in 1...blockCount {
            
            // 그동안 트래킹 되었던 데이터 추가
            trackingData.appendDataBetweenBackground()
            
            // 트래킹 보드의 trackings에 데이터 추가
            let second = Int(trackingData.focusTime().startTime)!
            trackingBoardService.appendTrackingSecond(to: second)
        }
        
        // MARK: - 트래킹 중 하루 지났을 경우
        if dayElapsed > 0 {
            
            // 트래킹 보드 전부 초기화
            trackingBoardService.resetAllData()
            
            // 현재의 focusDate의 startTime으로 현재 세션 업데이트
            for time in trackingData.focusTimeList {
                trackingBoardService.appendTrackingSecond(to: Int(time.startTime)!)
            }
        }
        
        // 트래킹 모드 최종 시작
        viewManager.trackingRestartForDisconnect()
    }
    
    // MARK: - Helper
    
    /// APP 재시작 후 트래킹 시간을 계산해 TimeManager를 업데이트합니다.
    private func updateTrackingTimeResultAfterAppRestart(result: Int) {
        
        // 총 블럭 개수 및 UI 업데이트
        timerManager.totalBlockCount = Double(result / trackingData.targetSecond) * 0.5
        viewManager.updateCurrentOutputLabel(timerManager.totalBlockCount)
        
        // 총 트래킹 시간 업데이트
        timerManager.totalTrackingSecond = result
        
        // 현재 트래킹 시간 및 프로그레스바 업데이트
        let currentTime = result % trackingData.targetSecond
        timerManager.currentTrackingSecond = Float(currentTime)
        viewManager.updateTracking(time: timerManager.format, progress: timerManager.progressPercent())
    }
    
    /// 일시정지 시간이 12시간이 지나 트래킹을 종료합니다.
    private func stopTracking() {
        
        // 1. 이전에 트래킹 되고 있던 데이터 삭제
        trackingData.removeStopData()
        
        // 2. 트래커 초기화
        resetTracker()
        
        // 3. UserDefaults 트래킹 모드 확인용 변수 업데이트
        UserDefaultsItem.shared.setIsTracking(to: false)
        UserDefaultsItem.shared.setIsPaused(to: false)
        
        // 4. 토스트 출력
        showToast(toast: viewManager.pausedToastView, isActive: true)
        
        // 5. 컬렉션뷰 초기화
        viewManager.blockCollectionView.reloadData()
        viewManager.blockCollectionView.scrollToItem(at: IndexPath(item: blockIndex, section: 0), at: .left, animated: true)
    }
}

// MARK: - Background
extension HomeViewController {
    
    /// background 에서 foreground로 진입 후 트래킹 모드를 재시작 합니다.
    @objc func didEnterForeground(_ notification: Notification) {
        
        // 0. 날짜 라벨 업데이트
        updateDateLabel()
        
        // 트래킹 모드인지 확인
        guard UserDefaultsItem.shared.isTracking else { return }
        
        // 일시정지 되었었는지 확인
        guard !UserDefaultsItem.shared.isPaused else {
            let elapsedSeconds = trackingData.calculateElapsedTimeSinceAppExit
            timerManager.pausedTime += elapsedSeconds
            
            // 만약 일시정지 된지 12시간이 지났다면, 트래킹 종료
            if elapsedSeconds >= 43200 {
                viewManager.stopTrackingMode()
                showToast(toast: viewManager.pausedToastView, isActive: true)
            }
            
            return
        }
        
        // 1. 타이머 업데이트
        updateTimerSinceBackground(notification)
        
        // MARK: - 백그라운드에 있을 동안 블럭이 생산된 경우
        // 3500 >= 1800
        if timerManager.currentTrackingSecond >= Float(trackingData.targetSecond) {
            
            // 현재 트래킹 세션 초 업데이트
            // 3500 / 1800 = 1
            let count = Int(timerManager.currentTrackingSecond) / trackingData.targetSecond
            
            // 3500 = 3500 - 1800 * 1
            timerManager.currentTrackingSecond -= Float(trackingData.targetSecond) * Float(count)
            
            // 백그라운드 데이터 생성
            for _ in 1...count {
                
                // 지금까지 몇개의 블럭이 생산되었는지 추가
                timerManager.totalBlockCount += 0.5
                
                // 그동안 트래킹 되었던 데이터 추가
                trackingData.appendDataBetweenBackground()
                
                // 트래킹 보드의 trackings에 데이터 추가
                let second = Int(trackingData.focusTime().startTime)!
                trackingBoardService.appendTrackingSecond(to: second)
            }
            
            // MARK: - 백그라운드에 있을 동안 하루가 지난 경우
            let dayElapsed = trackingData.calculateElapsedDaySinceAppExit
            if dayElapsed > 0 {
                
                // 트래킹 보드 전부 초기화
                trackingBoardService.resetAllData()
                
                // 현재의 focusDate의 startTime으로 현재 세션 업데이트
                for time in trackingData.focusTimeList {
                    trackingBoardService.appendTrackingSecond(to: Int(time.startTime)!)
                }
            }
            
            // 생산 블럭량 라벨 업데이트
            viewManager.updateCurrentOutputLabel(timerManager.totalBlockCount)
        }
        
        // 트래킹 보드 업데이트
        trackingBoardService.updateTrackingBoard(to: Date())
        updateTrackingBoardUI()
        
        // 타이머 및 프로그레스 바 UI 업데이트
        viewManager.updateTracking(time: timerManager.format, progress: timerManager.progressPercent())
    }
    
    // MARK: - Helper
    
    /// Background에 나가있었던 시간을 계산 후 타이머를 업데이트합니다.
    private func updateTimerSinceBackground(_ notification: Notification) {
        
        // 타이머 재시작
        timerManager.trackingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(trackingEverySecond), userInfo: nil, repeats: true)
        
        // 시간 확인
        let elapsedSeconds = trackingData.calculateElapsedTimeSinceAppExit
        
        // 시간 업데이트
        timerManager.totalTrackingSecond += elapsedSeconds
        timerManager.currentTrackingSecond += Float(elapsedSeconds)
    }
}
