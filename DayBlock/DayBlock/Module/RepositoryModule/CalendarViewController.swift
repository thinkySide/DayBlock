//
//  CalendarViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/02.
//

import UIKit

final class CalendarViewController: UIViewController {
    
    private let viewManager = CalendarView()
    
    // MARK: - ViewController LifeCycle
    override func loadView() {
        view = viewManager
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
