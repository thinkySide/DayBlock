//
//  CustomDelegate.swift
//  DayBlock
//
//  Created by 김민준 on 2023/05/09.
//

import Foundation

// MARK: - UIView

protocol HomeViewDelegate: AnyObject {
    
    /// TabBar
    func hideTabBar()
    func showTabBar()
    
    /// Tracking
    func startTracking()
    func pausedTracking()
    func stopTracking()
    
    /// Custom
    func selectGroupButtonTapped()
    func setupProgressViewColor()
}

protocol CreateGroupViewDelegate: AnyObject {
    func dismissVC()
    func createGroup()
}



// MARK: - UIViewController

protocol CreateGroupViewControllerDelegate: AnyObject {
    func updateGroupList()
}

@objc protocol SelectGroupViewControllerDelegate: AnyObject {
    @objc optional func updateGroup()
    @objc optional func switchHomeGroup(index: Int)
}

protocol SelectColorViewControllerDelegate: AnyObject {
    func updateColor()
}



// MARK: - Component

protocol SelectFormDelegate: AnyObject {
    func groupFormTapped()
    func iconFormTapped()
    func colorFormTapped()
}

