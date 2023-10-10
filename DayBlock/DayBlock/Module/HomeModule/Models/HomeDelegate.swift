//
//  HomeDelegate.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/20.
//

import Foundation

protocol HomeViewDelegate: AnyObject {
    func homeView(_ homeView: HomeView, displayTabBarForTrackingMode isDisplay: Bool)
    
    func homeView(_ homeView: HomeView, trackingDidStart mode: HomeView.TrakingMode)
    func homeView(_ homeView: HomeView, trackingDidPause mode: HomeView.TrakingMode)
    func homeView(_ homeView: HomeView, trackingDidRestart mode: HomeView.TrakingMode)
    func homeView(_ homeView: HomeView, trackingDidStop mode: HomeView.TrakingMode)
    func homeView(_ homeView: HomeView, trackingDidFinish mode: HomeView.TrakingMode)
    func homeView(_ homeView: HomeView, trackingDidRelaunch mode: HomeView.TrakingMode)
    
    func homeView(_ homeView: HomeView, setupProgressViewColor mode: HomeView.TrakingMode)
}

protocol DayBlockDelegate: AnyObject {
    func dayBlock(_ dayBlock: DayBlock, trackingComplete taskLabel: String?)
}
