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
        if timerManager.totalTime % 1800 == 0 {
            produceBlock()
        }
        
        // TimeLabel & ProgressView 업데이트
        viewManager.updateTracking(time: timerManager.format,
                                   progress: timerManager.progressPercent())
    }
    
    /// 블럭 0.5개 생산 시 실행되는 트래킹 메서드입니다.
    func produceBlock() {
        
        // 1. trackingTime 코어데이터 업데이트
        trackingData.appendDataInProgress()
        
        // 2. 현재 시간 초기화
        timerManager.currentTime = 0
        
        // 3. 생산한 전체 블럭
        timerManager.totalBlock += 0.5
        viewManager.updateCurrentProductivityLabel(timerManager.totalBlock)
        
        // 4. 트래킹 보드를 위한 배열 업데이트
        trackingData.appendCurrentTimeInTrackingBlocks()
        
        // 5. 리프레쉬
        viewManager.blockPreview.refreshAnimation(trackingData.trackingBlocks(), color: groupData.focusColor())
    }
}

// MARK: - Tracking Cycle Method
extension HomeViewController {
    
    /// 트래킹 모드가 시작 된 후 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter mode: 현재 트래킹 모드
    func homeView(_ homeView: HomeView, trackingDidStart mode: HomeView.TrakingMode) {
        
        // 1. 타이머 시작
        timerManager.trackingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(trackingEverySecond), userInfo: nil, repeats: true)
        
        // 2. 트래킹 시작 날짜 데이터 넣기
        trackingData.createStartData()
        
        // 3. 현재 트래킹 중인 블럭 정보 저장
        let blockDataList = blockData.list()
        viewManager.trackingBlock.update(group: groupData.focusEntity(), block: blockDataList[blockIndex])
        
        // 4. UserDefaults 트래킹 모드 확인용 변수 업데이트
        UserDefaults.standard.set(true, forKey: UserDefaultsKey.isTracking)
        
        // 5. 트래킹 보드 애니메이션 시작
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
        
        // 1. 타이머 비활성화
        timerManager.trackingTimer.invalidate()
        
        // 2. UserDefaults 트래킹 일시정지 확인용 변수 업데이트
        UserDefaults.standard.set(true, forKey: UserDefaultsKey.isPause)
        
        // 3. 트래킹 보드 애니메이션 일시정지
        updateTrackingBoard(isPaused: true)
        
        // 4. SFSymbol 애니메이션 종료
        stopSFSymbolAnimation(viewManager.trackingBlock.icon)
    }
    
    /// 트래킹 모드가 재시작 된 후 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter mode: 현재 트래킹 모드
    func homeView(_ homeView: HomeView, trackingDidRestart mode: HomeView.TrakingMode) {
        
        // 1. 타이머 시작
        timerManager.trackingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(trackingEverySecond), userInfo: nil, repeats: true)
        
        // 2. UserDefaults 트래킹 일시정지 확인용 변수 업데이트
        UserDefaults.standard.set(false, forKey: UserDefaultsKey.isPause)
        
        // 3. 트래킹 보드 애니메이션 재시작
        updateTrackingBoard(isPaused: false)
        
        // 4. SFSymbol 애니메이션 재시작
        startSFSymbolBounceAnimation(viewManager.trackingBlock.icon)
    }
    
    /// 트래킹 모드가 중단 된 후 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter mode: 현재 트래킹 모드
    func homeView(_ homeView: HomeView, trackingDidStop mode: HomeView.TrakingMode) {
        
        // 1. 트래킹 보드 애니메이션 종료
        viewManager.blockPreview.stopTrackingAnimation(trackingData.trackingBlocks())
        
        // 2. 이전에 트래킹 되고 있던 데이터 삭제
        trackingData.removeStopData()
        
        // 3. 트래커 초기화
        resetTracker()
        
        // 4. 트래킹 블럭 초기화
        trackingData.resetTrackingBlocks()
        
        // 5. UserDefaults 트래킹 모드 확인용 변수 업데이트
        UserDefaults.standard.set(false, forKey: UserDefaultsKey.isTracking)
        UserDefaults.standard.set(false, forKey: UserDefaultsKey.isPause)
        
        // 6. SFSymbol 애니메이션 종료
        stopSFSymbolAnimation(viewManager.trackingBlock.icon)
    }
    
    /// 트래킹 완료 화면에서 확인 버튼 탭 시 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter mode: 현재 트래킹 모드
    ///
    /// 2번 호출
    func homeView(_ homeView: HomeView, trackingDidFinish mode: HomeView.TrakingMode) {
        
        // 1. 트래킹 보드 애니메이션 종료
        viewManager.blockPreview.stopTrackingAnimation(trackingData.trackingBlocks())
        
        // 2. 트래커 초기화
        resetTracker()
        
        // 3. 트래킹 블럭 초기화
        trackingData.resetTrackingBlocks()
        
        // 4. UI 업데이트
        viewManager.productivityLabel.text = "TODAY +\(trackingData.todayAllOutput())"
        
        // 5. 컬렉션뷰 초기화
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
        guard timerManager.totalTime > 1800 else {
            showToast(toast: viewManager.toastView, isActive: true)
            return
        }
        
        // 1. 최종 트래킹 데이터 저장
        trackingData.finishData()
        
        // 2. 트래킹 완료 화면 Present
        presentTrackingCompleteVC()
        
        // 3. UserDefaults 트래킹 모드 확인용 변수 업데이트
        UserDefaults.standard.set(false, forKey: UserDefaultsKey.isTracking)
        UserDefaults.standard.set(false, forKey: UserDefaultsKey.isPause)
        
        // 4. 심볼 애니메이션 종료
        stopSFSymbolAnimation(viewManager.trackingBlock.icon)
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
