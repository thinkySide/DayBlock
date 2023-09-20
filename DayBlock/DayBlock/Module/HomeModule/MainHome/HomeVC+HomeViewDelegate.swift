//
//  HomeVC+HomeViewDelegate.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/20.
//

import UIKit

extension HomeViewController: HomeViewDelegate {
    
    /// 트래킹 모드와 홈 모드가 전환 될 때, TabBar 표시 여부를 결정하는 Delegate 메서드입니다.
    ///
    /// - Parameter isDisplay: TabBar 표시 여부
    func homeView(_ homeView: HomeView, displayTabBarForTrackingMode isDisplay: Bool) {
        let value: CGFloat = isDisplay ? 1 : 0
        viewManager.tabBarStackView.alpha = value
        tabBarController?.tabBar.alpha = value
    }
    
    /// 트래킹 모드가 시작 된 후 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter mode: 현재 트래킹 모드
    func homeView(_ homeView: HomeView, trackingDidStart mode: HomeView.TrakingMode) {
        
        // 1. 타이머 시작
        trackingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(trackingEverySecond), userInfo: nil, repeats: true)
        
        // 2. 트래킹 보드 애니메이션 시작
        activateTrackingBoard()
        
        // 3. 현재 트래킹 중인 블럭 정보 저장
        let blockDataList = blockManager.getCurrentBlockList()
        viewManager.trackingBlock.update(group: blockManager.getCurrentGroup(), block: blockDataList[blockIndex])
        
        // 4. 화면 꺼짐 방지
        isScreenCanSleep(false)
    }
    
    /// 트래킹 모드가 일시정지 된 후 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter mode: 현재 트래킹 모드
    func homeView(_ homeView: HomeView, trackingDidPause mode: HomeView.TrakingMode) {
        
        // 1. 타이머 비활성화
        trackingTimer.invalidate()
    }
    
    /// 트래킹 모드가 종료된 후 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter mode: 현재 트래킹 모드
    func homeView(_ homeView: HomeView, trackingDidStop mode: HomeView.TrakingMode) {
        
        // 1. 타이머 비활성화
        trackingTimer.invalidate()
        
        // 2. UI 및 트래커 초기화
        viewManager.updateTracking(time: "00:00:00", progress: 0)
        timeTracker.totalTime = 0
        timeTracker.currentTime = 0
        timeTracker.totalBlock = 0

        // 3. 컬렉션뷰 초기화
        viewManager.blockCollectionView.reloadData()
        viewManager.blockCollectionView.scrollToItem(at: IndexPath(item: blockIndex, section: 0), at: .left, animated: true)
        
        // 4. 화면 꺼짐 해제
        isScreenCanSleep(true)
    }
    
    /// ProgressView의 컬러를 설정하기 위한 Delegate 메서드입니다.
    ///
    /// - Parameter mode: 현재 트래킹 모드
    func homeView(_ homeView: HomeView, setupProgressViewColor mode: HomeView.TrakingMode) {
        
        // 1. 현재 그룹의 컬러를 기준으로 설정
        viewManager.setupProgressViewColor(color: blockManager.getCurrentGroupColor())
    }
}
