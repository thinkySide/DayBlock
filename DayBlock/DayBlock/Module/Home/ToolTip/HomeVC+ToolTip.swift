//
//  HomeVC+HelpTracking.swift
//  DayBlock
//
//  Created by 김민준 on 12/28/23.
//

import UIKit

extension HomeViewController {
    
    /// 첫 실행 툴팁을 설정합니다.
    func setupFirstToolTip() {
        if UserDefaultsItem.shared.isHomeFirst {
            self.helpBarButtonItemTapped()
            // UserDefaultsItem.shared.setIsHomeFirst(to: false)
        }
    }
    
    /// 일반 모드 및 트래킹 모드의 네비게이션 아이템을 토글합니다.
    func toggleToolTipNavigationItem(isTrackingMode: Bool) {
        if isTrackingMode {
            let helpBarButtomItem = viewManager.helpBarButtonItem
            let trackingStopBarButtomItem = viewManager.trackingStopBarButtonItem
            navigationItem.rightBarButtonItems = [trackingStopBarButtomItem, helpBarButtomItem]
        } else {
            let helpBarButtomItem = viewManager.helpBarButtonItem
            navigationItem.rightBarButtonItem = helpBarButtomItem
        }
    }
    
    /// 메인 화면 툴팁을 설정합니다.
    private func configureMainToolTip() {
        let tabBarController = UITabBarController()
        let toolTipVC = UINavigationController(rootViewController: HomeMainToolTipViewController())
        tabBarController.setViewControllers([toolTipVC], animated: false)
        tabBarController.modalPresentationStyle = .overFullScreen
        tabBarController.modalTransitionStyle = .crossDissolve
        present(tabBarController, animated: true)
    }
    
    /// 트래킹 화면 툴팁을 설정합니다.
    private func configureTrackingToolTip() {
        let toolTipVC = UINavigationController(rootViewController: HomeTrackingToolTipViewController())
        toolTipVC.modalPresentationStyle = .overFullScreen
        toolTipVC.modalTransitionStyle = .crossDissolve
        present(toolTipVC, animated: true)
    }
    
    /// 트래킹 도움말 BarButtonItem 탭 시 실행되는 메서드입니다.
    @objc func helpBarButtonItemTapped() {
        switch viewManager.trackingMode {
        case .start: configureTrackingToolTip()
        case .pause: configureTrackingToolTip()
        case .restart: configureTrackingToolTip()
        case .stop: configureMainToolTip()
        case .finish: configureMainToolTip()
        }
    }
}
