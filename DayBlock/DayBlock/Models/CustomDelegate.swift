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

protocol CreateBlockViewDelegate: AnyObject {
    func createNewBlock()
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

protocol SelectIconViewControllerDelegate: AnyObject {
    func updateIcon()
}


// MARK: - Component

@objc protocol SelectFormDelegate: AnyObject {
    @objc optional func groupFormTapped()
    @objc optional func iconFormTapped()
    @objc optional func colorFormTapped()
}

