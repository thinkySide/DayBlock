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
        setupEvent()
    }
    
    // MARK: - Setup Method
    private func setupCalendar() {
        viewManager.calendar.dataSource = self
        viewManager.calendar.delegate = self
        
        // Header date 설정
        viewManager.calendarHeaderLabel.text = calendarManager.headerDateFormatter.string(from: Date())
    }
    
    private func setupEvent() {
        viewManager.previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        
        viewManager.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Event Method
    
    /// 달력 이전 버튼 클릭 시 호출되는 메서드입니다.
    @objc private func previousButtonTapped() {
        guard let previousDate = 
                Calendar.current.date(
                    byAdding: .weekOfMonth,
                    value: -1,
                    to: viewManager.calendar.currentPage) else { return }
        viewManager.calendar.setCurrentPage(previousDate, animated: true)
    }
    
    /// 달력 다음 버튼 클릭 시 호출되는 메서드입니다.
    @objc private func nextButtonTapped() {
        guard let nextDate =
                Calendar.current.date(
                    byAdding: .month,
                    value: 1,
                    to: viewManager.calendar.currentPage) else { return }
        viewManager.calendar.setCurrentPage(nextDate, animated: true)
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
