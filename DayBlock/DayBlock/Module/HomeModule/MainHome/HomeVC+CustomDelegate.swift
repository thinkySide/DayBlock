//
//  HomeVC+CustomDelegate.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/20.
//

import UIKit

// MARK: - Home View Delegate
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
        trackingManager.trackingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(trackingEverySecond), userInfo: nil, repeats: true)
        
        // 2. 트래킹 보드 애니메이션 시작
        activateTrackingBoard()
        
        // 3. 현재 트래킹 중인 블럭 정보 저장
        let blockDataList = blockManager.getCurrentBlockList()
        viewManager.trackingBlock.update(group: groupData.focusEntity(), block: blockDataList[blockIndex])
        
        // 4. 화면 꺼짐 방지
        isScreenCanSleep(false)
    }
    
    /// 트래킹 모드가 일시정지 된 후 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter mode: 현재 트래킹 모드
    func homeView(_ homeView: HomeView, trackingDidPause mode: HomeView.TrakingMode) {
        
        // 1. 타이머 비활성화
        trackingManager.trackingTimer.invalidate()
    }
    
    /// 트래킹 모드가 종료된 후 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter mode: 현재 트래킹 모드
    func homeView(_ homeView: HomeView, trackingDidStop mode: HomeView.TrakingMode) {
        
        // 1. 타이머 비활성화
        trackingManager.trackingTimer.invalidate()
        
        // 2. UI 및 트래커 초기화
        viewManager.updateTracking(time: "00:00:00", progress: 0)
        trackingManager.totalTime = 0
        trackingManager.currentTime = 0
        trackingManager.totalBlock = 0

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
        viewManager.setupProgressViewColor(color: groupData.focusColor())
    }
}

// MARK: - Day Block Delegate
extension HomeViewController: DayBlockDelegate {
    
    /// 트래킹 완료 후 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter taskLabel: 트래킹 완료된 작업 이름
    func dayBlock(_ dayBlock: DayBlock, trackingComplete taskLabel: String?) {
        presentTrackingCompleteVC()
    }
}

// MARK: - Create Block ViewController Delegate
extension HomeViewController: CreateBlockViewControllerDelegate {
    
    /// 블럭 편집 후 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter mode: CreateBlockViewController의 현재 모드
    func createBlockViewController(_ createBlockViewController: CreateBlockViewController, blockDidEdit mode: CreateBlockViewController.Mode) {
        
        // 1. 그룹 선택 버튼 UI 업데이트
        viewManager.groupSelectButton.color.backgroundColor = groupData.focusColor()
        viewManager.groupSelectButton.label.text = groupData.focusEntity().name
        
        // 2. 현재 인덱스 저장
        blockIndex = blockManager.getCurrentBlockIndex()
        
        // 3. BlockCollectionView 리로드(뒤집어져 있기 때문) 및 스크롤 위치 지정
        viewManager.blockCollectionView.reloadData()
        viewManager.blockCollectionView.scrollToItem(at: IndexPath(item: blockIndex, section: 0), at: .left, animated: true)
        
        // 4. 편집된 블럭이 포커스 되어있으므로, 트래킹 버튼 활성화
        viewManager.toggleTrackingButton(true)
    }
    
    /// 블럭 생성 후 호출되는 Delegate 메서드입니다.
    ///
    /// - Parameter mode: CreateBlockViewController의 현재 모드
    func createBlockViewController(_ createBlockViewController: CreateBlockViewController, blockDidCreate mode: CreateBlockViewController.Mode) {
        
        // 1. 그룹 업데이트(그룹이 편집이 되었을 경우를 확인하기 위해)
        switchHomeGroup(index: groupData.focusIndex())
        
        // 2. 현재 블럭 인덱스를 가장 마지막 인덱스로 저장(생성 블럭 이전 인덱스)
        blockIndex = blockManager.getLastBlockIndex()
        blockManager.updateCurrentBlockIndex(blockIndex)
        
        // 3. BlockCollectionView 스크롤 위치 지정
        viewManager.blockCollectionView.scrollToItem(at: IndexPath(item: blockIndex, section: 0), at: .left, animated: true)
        
        // 4. 생성된 블럭이 포커스 되어있으므로, 트래킹 버튼 활성화
        viewManager.toggleTrackingButton(true)
    }
}
