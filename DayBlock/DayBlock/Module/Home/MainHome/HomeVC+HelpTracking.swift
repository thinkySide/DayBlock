//
//  HomeVC+HelpTracking.swift
//  DayBlock
//
//  Created by 김민준 on 12/28/23.
//

import UIKit

extension HomeViewController {
    
    /// 트래킹 도움말 BarButtonItem 탭 시 실행되는 메서드입니다.
    @objc func helpBarButtonItemTapped() {
        let toolTipVC = UINavigationController(rootViewController: HomeToolTipViewController())
        toolTipVC.modalPresentationStyle = .overFullScreen
        toolTipVC.modalTransitionStyle = .crossDissolve
        present(toolTipVC, animated: true)
    }
}
