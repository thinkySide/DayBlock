//
//  HomeVC+TrackingLifeCycle.swift
//  DayBlock
//
//  Created by 김민준 on 10/2/23.
//

import Foundation

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
        
        // 4. 트래킹 보드 애니메이션 시작
        trackingData.appendCurrentTimeInTrackingBlocks()
        updateTrackingBoard(isPaused: true)
        updateTrackingBoard(isPaused: false)
        
        // 5. SFSymbol 애니메이션 시작
        startSFSymbolBounceAnimation(viewManager.trackingBlock.icon)
        
        // 6. 화면 꺼짐 방지
        isScreenCanSleep(false)
    }
    
    /// 트래킹 모드가 일시정지 된 후 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter mode: 현재 트래킹 모드
    func homeView(_ homeView: HomeView, trackingDidPause mode: HomeView.TrakingMode) {
        
        // 1. 타이머 비활성화
        timerManager.trackingTimer.invalidate()
        
        // 2. 트래킹 보드 애니메이션 일시정지
        updateTrackingBoard(isPaused: true)
        
        // 3. SFSymbol 애니메이션 종료
        stopSFSymbolAnimation(viewManager.trackingBlock.icon)
    }
    
    /// 트래킹 모드가 재시작 된 후 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter mode: 현재 트래킹 모드
    func homeView(_ homeView: HomeView, trackingDidRestart mode: HomeView.TrakingMode) {
        
        // 1. 타이머 시작
        timerManager.trackingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(trackingEverySecond), userInfo: nil, repeats: true)
        
        // 2. 트래킹 보드 애니메이션 재시작
        updateTrackingBoard(isPaused: false)
        
        // 3. SFSymbol 애니메이션 재시작
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
        
        // 4. SFSymbol 애니메이션 종료
        stopSFSymbolAnimation(viewManager.trackingBlock.icon)
    }
    
    /// 트래킹 완료 화면에서 확인 버튼 탭 시 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter mode: 현재 트래킹 모드
    func homeView(_ homeView: HomeView, trackingDidFinish mode: HomeView.TrakingMode) {
        resetTracker()
        trackingData.resetTrackingBlocks()
    }
}

// MARK: - Day Block Delegate
extension HomeViewController: DayBlockDelegate {
    
    /// 트래킹 모드 완료 후 (LongPressGesture) 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter taskLabel: 트래킹 완료된 작업 이름
    func dayBlock(_ dayBlock: DayBlock, trackingComplete taskLabel: String?) {
        
        // 0. 아직 블럭이 생성되지 않았다면, 메서드
//        guard timerManager.totalTime > 1800 else {
//            showToast(toast: viewManager.toastView, isActive: true)
//            return
//        }
        
        // 1. 최종 트래킹 데이터 저장
        trackingData.finishData()
        
        // 2. 트래킹 완료 화면 Present
        presentTrackingCompleteVC()
        
        // 3. 원활한 모션을 위한 지연 실행
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.viewManager.blockPreview.stopTrackingAnimation(self.trackingData.trackingBlocks())
            self.stopSFSymbolAnimation(self.viewManager.trackingBlock.icon)
        }
    }
}

// MARK: - Tracking Complete View Controller Delegate
extension HomeViewController: TrackingCompleteViewControllerDelegate {
    
    /// 트래킹 완료 화면에서 확인 버튼 탭 시 호출되는 Delegate 메서드입니다.
    func trackingCompleteVC(backToHomeButtonTapped trackingCompleteVC: TrackingCompleteViewController) {
        viewManager.finishTrackingMode()
    }
}
