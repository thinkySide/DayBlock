//
//  BlockDelegate.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/14.
//

import Foundation

protocol CreateBlockViewControllerDelegate: AnyObject {
    func createBlockViewController(_ createBlockViewController: CreateBlockViewController, blockDidEdit mode: CreateBlockViewController.Mode)
    
    func createBlockViewController(_ createBlockViewController: CreateBlockViewController, blockDidCreate mode: CreateBlockViewController.Mode)
    
    func createBlockViewController(_ createBlockViewController: CreateBlockViewController, blockDidDelete mode: CreateBlockViewController.Mode)
}
