//
//  ManageViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/02.
//

import UIKit

final class ManageViewController: UIViewController {
    
    let viewManager = ManageView()
    let groupData = GroupDataStore.shared
    let blockData = BlockDataStore.shared
    let trackingData = TrackingDataStore.shared
    
    // MARK: - ViewController LifeCycle
    
    override func loadView() {
        view = viewManager
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
