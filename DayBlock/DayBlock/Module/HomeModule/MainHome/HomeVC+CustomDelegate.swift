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
    
    /// ProgressView의 컬러를 설정하기 위한 Delegate 메서드입니다.
    ///
    /// - Parameter mode: 현재 트래킹 모드
    func homeView(_ homeView: HomeView, setupProgressViewColor mode: HomeView.TrakingMode) {
        
        // 1. 현재 그룹의 컬러를 기준으로 설정
        viewManager.setupProgressViewColor(color: groupData.focusColor())
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
        blockIndex = blockData.focusIndex()
        
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
        blockIndex = blockData.list().count - 1
        blockData.updateFocusIndex(to: blockIndex)
        
        // 3. BlockCollectionView 스크롤 위치 지정
        viewManager.blockCollectionView.scrollToItem(at: IndexPath(item: blockIndex, section: 0), at: .left, animated: true)
        
        // 4. 생성된 블럭이 포커스 되어있으므로, 트래킹 버튼 활성화
        viewManager.toggleTrackingButton(true)
    }
}

// MARK: - TrackingBoardDelegate
extension HomeViewController: TrackingBoardDelegate {
    func trackingBoard(animationWillRefresh trackingBoard: TrackingBoard) {
        
        print(#function)
        
        // 여기서 모든 애니메이션 스탑
        viewManager.blockPreview.stopTrackingAnimation(trackingData.trackingBlocks())
        
        // 다시 애니메이션 시작
        updateTrackingBoard(isPaused: false)
    }
}
