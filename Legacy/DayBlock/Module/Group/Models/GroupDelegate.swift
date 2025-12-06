//
//  GroupDelegate.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/14.
//

import Foundation

// MARK: - Create Group

protocol CreateGroupViewDelegate: AnyObject {
    func dismissVC()
    func createGroup()
}

protocol CreateGroupViewControllerDelegate: AnyObject {
    func updateGroupList()
}

// MARK: - List Group

protocol ManageGroupViewDelegate: AnyObject {
    func dismissVC()
    func addGroup()
}

protocol ManageGroupViewControllerDelegate: AnyObject {
    func reloadData()
}

// MARK: - Edit Group

protocol EditGroupViewDelegate: AnyObject {
    func editGroup()
}

protocol EditGroupViewControllerDelegate: AnyObject {
    func reloadData()
}

// MARK: - Select Group

@objc protocol SelectGroupViewControllerDelegate: AnyObject {
    @objc optional func updateGroup()
    @objc optional func switchHomeGroup(index: Int)
    @objc optional func switchManageGroupTabBar()
}
