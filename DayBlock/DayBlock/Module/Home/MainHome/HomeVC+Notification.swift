//
//  HomeVC+Notification.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/19.
//

import UIKit

extension HomeViewController {
    
    /// Notification Observer를 추가합니다.
    func setupNotification() {
        
        // 마지막 트래킹 시간 추적 observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterForeground),
            name: .latestAccess,
            object: nil
        )
        
        // 블럭 삭제 observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadForDeleteBlock),
            name: .reloadForDeleteBlock,
            object: nil
        )
        
        // 블럭 편집 observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadForUpdateBlock),
            name: .reloadForUpdateBlock,
            object: nil
        )
        
        // 모든 데이터 초기화 observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(resetAllData),
            name: .resetAllData,
            object: nil
        )
    }
    
    /// 블럭 편집 Noti를 받았을 때 블럭을 편집 후 리로드합니다.
    /// - Post : EditGroupViewController
    ///
    /// - Parameter notification: 블럭 편집 Notification
    @objc private func reloadForUpdateBlock(_ notification: Notification) {
        let currentGroup = groupData.focusEntity()
        viewManager.groupSelectButton.label.text = currentGroup.name
        viewManager.groupSelectButton.color.backgroundColor = UIColor(rgb: currentGroup.color)
        viewManager.blockCollectionView.reloadData()
    }
    
    /// 블럭 삭제 Notification을 받았을 때 그룹 내 블럭 선택값을 초기화합니다.
    /// - Post : EditGroupViewController
    ///
    /// - Parameter notification: 블럭 삭제 Notification
    @objc private func reloadForDeleteBlock(_ notification: Notification) {
        switchHomeGroup(index: 0)
    }
    
    /// 모든 데이터 초기화 Notification을 받았을 때 그룹 내 블럭 선택값을 초기화합니다.
    /// - Post : ResetDataViewController
    ///
    /// - Parameter notification: 블럭 삭제 Notification
    @objc private func resetAllData(_ notification: Notification) {
        switchHomeGroup(index: 0)
    }
}
