//
//  MyPageViewController.swift
//  DayBlock
//
//  Created by 김민준 on 12/12/23.
//

import UIKit

final class MyPageViewController: UIViewController {
    
    let viewManager = MyPageView()
    
    // MARK: - ViewController LifeCycle
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
