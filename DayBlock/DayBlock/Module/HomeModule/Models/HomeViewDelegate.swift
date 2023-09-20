//
//  HomeViewDelegate.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/14.
//

import Foundation

protocol HomeViewDelegate: AnyObject {
    func homeView(_ homeView: HomeView, displayTabBarForTrackingMode isDisplay: Bool)
    func homeView(_ homeView: HomeView, trackingDidStart mode: HomeView.TrakingMode)
    func homeView(_ homeView: HomeView, trackingDidPause mode: HomeView.TrakingMode)
    func homeView(_ homeView: HomeView, trackingDidStop mode: HomeView.TrakingMode)
    func homeView(_ homeView: HomeView, setupProgressViewColor mode: HomeView.TrakingMode)
}
