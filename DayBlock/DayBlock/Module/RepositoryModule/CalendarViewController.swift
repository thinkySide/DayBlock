//
//  CalendarViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/02.
//

import UIKit
import FSCalendar

final class CalendarViewController: UIViewController {
    
    private let viewManager = CalendarView()
    
    // MARK: - ViewController LifeCycle
    override func loadView() {
        view = viewManager
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Setup Method
    private func setupCalendar() {
        viewManager.calendar.dataSource = self
        viewManager.calendar.delegate = self
    }
}

// MARK: - FSCalendarDataSource & FSCalendarDelegate
extension CalendarViewController: FSCalendarDataSource & FSCalendarDelegate {
    
}
