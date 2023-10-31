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
    private let calendarManager = CalendarManager.shared
    
    // MARK: - ViewController LifeCycle
    override func loadView() {
        view = viewManager
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendar()
    }
    
    // MARK: - Setup Method
    private func setupCalendar() {
        viewManager.calendar.dataSource = self
        viewManager.calendar.delegate = self
        
        // Header date 설정
        viewManager.calendarHeaderLabel.text = calendarManager.headerDateFormatter.string(from: Date())
    }
}

// MARK: - FSCalendarDataSource & FSCalendarDelegate
extension CalendarViewController: FSCalendarDataSource & FSCalendarDelegate {
    
    /// 캘린더 달이 변경될 때마다 호출되는 메서드입니다.
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentDate = calendar.currentPage
        viewManager.calendarHeaderLabel.text = calendarManager.headerDateFormatter.string(from: currentDate)
    }
}
