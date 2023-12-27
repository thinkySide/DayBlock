//
//  HomeVC+TrackingLifeCycle.swift
//  DayBlock
//
//  Created by 김민준 on 10/2/23.
//

import Foundation

// MARK: - Auto Method
extension HomeViewController {
    
    /// 1초마다 실행되는 트래킹 메서드입니다.
    @objc func trackingEverySecond() {
        timerManager.totalTime += 1
        timerManager.currentTime += 1
        
        // 0.5개가 생산될 때마다 호출
        if timerManager.totalTime % trackingData.targetSecond == 0 {
            // testTracking()
            produceBlock()
        }
        
        // TimeLabel & ProgressView 업데이트
        let time = timerManager.format
        let progress = timerManager.progressPercent()
        viewManager.updateTracking(time: time, progress: progress)
    }
    
    /// 블럭 0.5개 생산 시 실행되는 트래킹 메서드입니다.
    func produceBlock() {
        
        // 1. trackingTime 코어데이터 업데이트
        trackingData.appendDataInProgress()
        
        // 2-1. 현재 트래킹 시간 초기화
        timerManager.currentTime = 0
        
        // 2-2. 일시정지 시간 초기화
        timerManager.pausedTime = 0
        
        // 3. 생산한 전체 블럭
        timerManager.totalBlock += 0.5
        viewManager.updateCurrentProductivityLabel(timerManager.totalBlock)
        
        // 만약 날짜가 넘어갔다면, 새로운 날짜 세션으로 재시작.
        if trackingData.focusDate().day != Date().dayString {
            print("날짜 넘어감.")
            
            // 기존 트래킹 데이터 저장
            trackingData.finishData()
            
            // 새로운 시작 날짜 데이터 생성
            trackingData.createStartData()
            
            // 원래 트래킹 되고 있던 블럭들 초기화
            trackingData.resetTrackingBlocks()
            viewManager.trackingBoard.resetAllBlocks()
        }
        
        // 4. 트래킹 보드를 위한 배열 업데이트
        trackingData.appendCurrentTimeInTrackingBlocks()
        
        // 5. 리프레쉬
        viewManager.trackingBoard.refreshAnimation(trackingData.trackingBlocks(), color: groupData.focusColor())
    }
    
    /// 일시정지 시간을 계산합니다.
    @objc func pausedEverySecond() {
        timerManager.pausedTime += 1
    }
    
    /// 테스트용 트래킹
    func testTracking() {
        
        // 1. trackingTime 코어데이터 업데이트
        trackingData.appendDataInProgress()
        
        // 2-1. 현재 트래킹 시간 초기화
        timerManager.currentTime = 0
        
        // 2-2. 일시정지 시간 초기화
        timerManager.pausedTime = 0
        
        // 3. 생산한 전체 블럭 업데이트
        timerManager.totalBlock += 0.5
        viewManager.updateCurrentProductivityLabel(timerManager.totalBlock)
        
        // 4. 트래킹 보드를 위한 배열 업데이트
        trackingData.testAppendForBackground()
        
        // 5. 리프레쉬
        viewManager.trackingBoard.refreshAnimation(trackingData.trackingBlocks(), color: groupData.focusColor())
    }
}

// MARK: - Tracking Cycle Method
extension HomeViewController {
    
    /// APP이 종료된 후 다시 트래킹 모드를 실행할 때 호출되는 메서드입니다.
    func homeView(_ homeView: HomeView, trackingDidRelaunch mode: HomeView.TrakingMode) {
        
        // 1. 타이머 시작
        timerManager.trackingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(trackingEverySecond), userInfo: nil, repeats: true)
        
        // 2. 기존 트래킹 중이었던 데이터 불러오기
        let groupIndex = UserDefaultsItem.shared.groupIndex
        let blockIndex = UserDefaultsItem.shared.blockIndex
        viewManager.trackingBlock.update(group: groupData.list()[groupIndex], block: blockData.list()[blockIndex])
        
        // 3. 트래킹 보드 애니메이션 시작
        updateTrackingBoard(isPaused: false)
        
        // 4. SFSymbol 애니메이션 시작
        startSFSymbolBounceAnimation(viewManager.trackingBlock.icon)
        
        // 5. 화면 꺼짐 방지
        isScreenCanSleep(false)
    }
    
    /// 트래킹 모드가 시작 된 후 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter mode: 현재 트래킹 모드
    func homeView(_ homeView: HomeView, trackingDidStart mode: HomeView.TrakingMode) {
        
        // 1. 타이머 시작
        timerManager.trackingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(trackingEverySecond), userInfo: nil, repeats: true)
        
        // 2. 트래킹 시작 날짜 데이터 넣기
        trackingData.createStartData()
        
        // 3. 현재 트래킹 중인 블럭 정보 저장
        viewManager.trackingBlock.update(group: groupData.focusEntity(), block: blockData.focusEntity())
        
        // 4. UserDefaults 트래킹 모드 확인용 변수 업데이트
        UserDefaultsItem.shared.setIsTracking(to: true)
        UserDefaultsItem.shared.setIsPaused(to: false)
        UserDefaultsItem.shared.setBlockIndex(to: blockData.focusIndex())
        
        // 5. 트래킹 보드 애니메이션 시작
        // trackingData.testAppendForDisconnect()
        // trackingData.currentTrackingBlocks.append("00:00")
        trackingData.appendCurrentTimeInTrackingBlocks()
        updateTrackingBoard(isPaused: false)
        
        // 6. SFSymbol 애니메이션 시작
        startSFSymbolBounceAnimation(viewManager.trackingBlock.icon)
        
        // 7. 화면 꺼짐 방지
        isScreenCanSleep(false)
    }
    
    /// 트래킹 모드가 일시정지 된 후 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter mode: 현재 트래킹 모드
    func homeView(_ homeView: HomeView, trackingDidPause mode: HomeView.TrakingMode) {
        
        // 1-1. 트래킹 타이머 비활성화
        timerManager.trackingTimer?.invalidate()
        
        // 1-2. 일시정지 타이머 활성화
        timerManager.pausedTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(pausedEverySecond), userInfo: nil, repeats: true)
        
        // 2. UserDefaults 트래킹 일시정지 확인용 변수 업데이트
        UserDefaultsItem.shared.setIsPaused(to: true)
        
        // 3. 트래킹 보드 애니메이션 일시정지
        updateTrackingBoard(isPaused: true)
        
        // 4. SFSymbol 애니메이션 종료
        stopSFSymbolAnimation(viewManager.trackingBlock.icon)
    }
    
    /// 트래킹 모드가 재시작 된 후 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter mode: 현재 트래킹 모드
    func homeView(_ homeView: HomeView, trackingDidRestart mode: HomeView.TrakingMode) {
        
        // 1-1. 트래킹 타이머 시작
        timerManager.trackingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(trackingEverySecond), userInfo: nil, repeats: true)
        
        // 1-2. 일시정지 타이머 정지
        timerManager.pausedTimer.invalidate()
        
        // 2. UserDefaults 트래킹 일시정지 확인용 변수 업데이트
        UserDefaultsItem.shared.setIsPaused(to: false)
        
        // 3. 트래킹 보드 애니메이션 재시작
        updateTrackingBoard(isPaused: false)
        
        // 4. SFSymbol 애니메이션 재시작
        startSFSymbolBounceAnimation(viewManager.trackingBlock.icon)
    }
    
    /// 트래킹 모드가 중단 된 후 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter mode: 현재 트래킹 모드
    func homeView(_ homeView: HomeView, trackingDidStop mode: HomeView.TrakingMode) {
        
        // 1. 트래킹 보드 애니메이션 종료 및 업데이트
        showToast(toast: viewManager.toastView, isActive: false)
        viewManager.trackingBoard.stopTrackingAnimation(trackingData.trackingBlocks())
        
        let outputInfo = trackingData.todayOutputBoardData()
        viewManager.trackingBoard.paintOutputBoard(outputInfo)
        
        // 2. 이전에 트래킹 되고 있던 데이터 삭제
        trackingData.removeStopData()
        
        // 3. 트래커 초기화
        resetTracker()
        
        // 4. 트래킹 블럭 초기화
        trackingData.resetTrackingBlocks()
        
        // 5. UserDefaults 트래킹 모드 확인용 변수 업데이트
        UserDefaultsItem.shared.setIsTracking(to: false)
        UserDefaultsItem.shared.setIsPaused(to: false)
        
        // 6. SFSymbol 애니메이션 종료
        stopSFSymbolAnimation(viewManager.trackingBlock.icon)
        
        // 7. 컬렉션뷰 초기화
        viewManager.blockCollectionView.reloadData()
        viewManager.blockCollectionView.scrollToItem(at: IndexPath(item: blockIndex, section: 0), at: .left, animated: true)
    }
    
    /// 트래킹 완료 화면에서 확인 버튼 탭 시 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter mode: 현재 트래킹 모드
    ///
    /// 2번 호출
    func homeView(_ homeView: HomeView, trackingDidFinish mode: HomeView.TrakingMode) {
        
        // 1. UI 업데이트
        showToast(toast: viewManager.toastView, isActive: false)
        uptodateTodayLabelUI()
        uptodateTrackingBoardUI()
        
        // 2. 컬렉션뷰 초기화
        viewManager.blockCollectionView.reloadData()
        viewManager.blockCollectionView.scrollToItem(at: IndexPath(item: blockIndex, section: 0), at: .left, animated: true)
    }
}

// MARK: - Day Block Delegate
extension HomeViewController: DayBlockDelegate {
    
    /// 트래킹 모드 완료 후 (LongPressGesture) 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter taskLabel: 트래킹 완료된 작업 이름
    func dayBlock(_ dayBlock: DayBlock, trackingComplete taskLabel: String?) {
        
        // 0. 아직 블럭이 생성되지 않았다면, 메서드
        guard timerManager.totalTime > trackingData.targetSecond else {
            showToast(toast: viewManager.toastView, isActive: true)
            Vibration.error.vibrate()
            return
        }
        
        // 1. 최종 트래킹 데이터 저장
        trackingData.finishData()
        
        // 2. 트래킹 완료 화면 Present
        presentTrackingCompleteVC()
        Vibration.success.vibrate()
        
        // 3. UserDefaults 트래킹 모드 확인용 변수 업데이트
        UserDefaultsItem.shared.setIsTracking(to: false)
        UserDefaultsItem.shared.setIsPaused(to: false)
        
        // 4. 심볼 애니메이션 종료
        stopSFSymbolAnimation(viewManager.trackingBlock.icon)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            // 5. 트래킹 보드 애니메이션 종료
            self.viewManager.trackingBoard.stopTrackingAnimation(self.trackingData.trackingBlocks())
            
            // 6. 트래커 초기화
            self.resetTracker()
            
            // 7. 트래킹 블럭 초기화
            self.trackingData.resetTrackingBlocks()
        }
    }
}

// MARK: - Tracking Complete View Controller Delegate
extension HomeViewController: TrackingCompleteViewControllerDelegate {
    
    /// 트래킹 완료 화면에서 확인 버튼 탭 시 호출되는 Delegate 메서드입니다.
    /// 1번 호출 : trackingDidFinish 메서드 호출
    func trackingCompleteVC(backToHomeButtonTapped trackingCompleteVC: TrackingCompleteViewController) {
        viewManager.finishTrackingMode()
    }
}
