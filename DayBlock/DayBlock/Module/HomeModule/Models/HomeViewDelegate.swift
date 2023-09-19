//
//  HomeViewDelegate.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/14.
//

import Foundation

protocol HomeViewDelegate: AnyObject {
    
    // TabBar
    func homeView(_ homeView: HomeView, displayTabBarForTrackingMode isDisplay: Bool)
    
    // Tracking
    func startTracking()
    func pausedTracking()
    func stopTracking()
    
    // Custom
    // func trackingStopBarButtonItemTapped()
    func setupProgressViewColor()
}
