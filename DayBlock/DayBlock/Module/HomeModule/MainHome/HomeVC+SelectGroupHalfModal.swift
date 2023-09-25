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
        if blockManager.getGroupList().count == 0 { return }
        viewManager.groupSelectButton.color.backgroundColor = blockManager.getCurrentGroupColor()
    }
    
    /// 그룹 선택 Half-Modal을 Present합니다.
    func presentSelectGroupHalfModal() {
        let selectGroupVC = SelectGroupViewController()
        selectGroupVC.delegate = self

        if #available(iOS 15.0, *) {
            selectGroupVC.modalPresentationStyle = .pageSheet
            if let sheet = selectGroupVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.prefersEdgeAttachedInCompactHeight = true
            }
        }
        
        else {
            let customBottomModalDelegate = BottomModalDelegate()
            selectGroupVC.modalPresentationStyle = .custom
            selectGroupVC.transitioningDelegate = customBottomModalDelegate
        }
        
        present(selectGroupVC, animated: true)
    }
    
    /// 포커스된 그룹을 지정한 인덱스로 업데이트합니다.
    ///
    /// - Parameter index: 업데이트 할 그룹 인덱스
    func switchHomeGroup(index: Int) {
        
        // 1. 현재 그룹 정보 및 UI 업데이트
        blockManager.updateCurrentGroup(index: index)
        viewManager.groupSelectButton.color.backgroundColor = blockManager.getCurrentGroupColor()
        viewManager.groupSelectButton.label.text = groupData.focusEntity().name
        viewManager.blockCollectionView.reloadData()
        
        // 2. 스크롤 위치 0번으로 초기화
        blockIndex = 0
        blockManager.updateCurrentBlockIndex(0)
        viewManager.blockCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
        
        // 3. UserDefaults에 현재 그룹 인덱스 저장
        UserDefaults.standard.set(index, forKey: UserDefaultsKey.groupIndex)
        
        // 4. 그룹 리스트가 비어있을 시, 트래킹 버튼 비활성화
        let blockList = groupData.focusEntity().blockList?.array as! [Block]
        if blockList.isEmpty { viewManager.toggleTrackingButton(false) }
        else { viewManager.toggleTrackingButton(true) }
    }
}

// MARK: - Select Group Gesture
extension HomeViewController {
    
    /// 그룹 선택 버튼 탭 시 호출 되는 메서드입니다.
    @objc func groupSelectButtonTapped(_ sender: UIGestureRecognizer) {
        presentSelectGroupHalfModal()
    }
}
