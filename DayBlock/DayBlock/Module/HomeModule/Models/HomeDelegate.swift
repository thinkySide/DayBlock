//
//  HomeDelegate.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/14.
//

import Foundation

protocol HomeDelegate: AnyObject {
    
    // TabBar
    func hideTabBar()
    func showTabBar()
    
    // Tracking
    func startTracking()
    func pausedTracking()
    func stopTracking()
    
    // Custom
    func trackingStopBarButtonItemTapped()
    func selectGroupButtonTapped()
    func setupProgressViewColor()
}
