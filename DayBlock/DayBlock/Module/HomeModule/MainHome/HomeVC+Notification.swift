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
            selector: #selector(restartTrackingMode),
            name: NSNotification.Name(Noti.latestAccess),
            object: nil
        )
        
        // 블럭 삭제 observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadForDeleteBlock),
            name: NSNotification.Name(Noti.reloadForDeleteBlock),
            object: nil
        )
        
        // 블럭 편집 observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadForUpdateBlock),
            name: NSNotification.Name(Noti.reloadForUpdateBlock),
            object: nil
        )
    }
    
    /// 백그라운드 모드로 진입 후 트래킹 모드를 재시작 합니다.
    @objc private func restartTrackingMode(_ notification: Notification) {
        let latestTime = notification.userInfo?["time"] as? Int ?? 0
        let currentTime = Int(Date().timeIntervalSince1970)
        print("\(currentTime - latestTime)초 지났음.")
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
}
