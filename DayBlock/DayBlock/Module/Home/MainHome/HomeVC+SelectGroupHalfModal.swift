//
//  HomeViewController+SelectGroupHalfModal.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/19.
//

import UIKit

extension HomeViewController: SelectGroupViewControllerDelegate {
    
    /// 그룹 선택 버튼의 초기값을 설정합니다.
    func initialGroupSelectButton() {
        if groupData.list().count == 0 { return }
        viewManager.groupSelectButton.color.backgroundColor = groupData.focusColor()
    }
    
    /// 그룹 선택 Half-Modal을 Present합니다.
    func presentSelectGroupHalfModal() {
        let selectGroupVC = SelectGroupViewController()
        selectGroupVC.delegate = self
        let navigationController = UINavigationController(rootViewController: selectGroupVC)
        
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.preferredCornerRadius = 30
        }
        
        present(navigationController, animated: true)
    }
    
    /// 포커스된 그룹을 지정한 인덱스로 업데이트합니다.
    ///
    /// - Parameter index: 업데이트 할 그룹 인덱스
    func switchHomeGroup(index: Int) {
        
        // 1. 현재 그룹 정보 및 UI 업데이트
        groupData.updateFocusIndex(to: index)
        updateGroupSelectButton()
        viewManager.blockCollectionView.reloadData()
        
        // 2. 스크롤 위치 0번으로 초기화
        blockIndex = 0
        blockData.updateFocusIndex(to: 0)
        viewManager.blockCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
        
        // 3. UserDefaults에 현재 그룹 인덱스 저장
        UserDefaultsItem.shared.setGroupIndex(to: index)
        
        // 4. 그룹 리스트가 비어있을 시, 트래킹 버튼 비활성화
        let blockList = groupData.focusEntity().blockList?.array as! [Block]
        if blockList.isEmpty { viewManager.toggleTrackingButton(false) }
        else { viewManager.toggleTrackingButton(true) }
    }
    
    /// 관리소 탭으로 이동하는 메서드입니다.
    func switchManageGroupTabBar() {
        guard let tabBarView = tabBarController?.view else { return }
        
        UIView.transition(with: tabBarView, duration: 0.3, options: .transitionCrossDissolve) {
            self.tabBarController?.selectedIndex = 1
        }
    }
}

// MARK: - Select Group Gesture
extension HomeViewController {
    
    /// 그룹 선택 버튼 탭 시 호출 되는 메서드입니다.
    @objc func groupSelectButtonTapped(_ sender: UIGestureRecognizer) {
        presentSelectGroupHalfModal()
    }
}
