//
//  HomeVC+HelpTracking.swift
//  DayBlock
//
//  Created by 김민준 on 12/28/23.
//

import UIKit

extension HomeViewController {
    
    /// 뷰가 탭 되었을 때 실행되는 메서드입니다.
    @objc func superViewTapped() {
        viewManager.printHelpToolTip(isActive: false)
    }
    
    /// 트래킹 도움말 BarButtonItem 탭 시 실행되는 메서드입니다.
    @objc func helpBarButtonItemTapped() {
        viewManager.toggleHelpToolTip()
    }
}
