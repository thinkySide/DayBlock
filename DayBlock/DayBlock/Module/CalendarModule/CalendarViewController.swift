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
        
        let calendar = viewManager.calendar
        
        // 기본 설정
        calendar.dataSource = self
        calendar.delegate = self
        calendar.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.id)
        calendar.today = nil
        
        // 현재 Cell 불러오기
        calendar.visibleCells().forEach { cell in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
        }
        
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
    
    /// FSCalendar 셀을 반환합니다.
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: CalendarCell.id, for: date, at: position)
        return cell
    }
    
    /// FSCalendar의 셀이 보여지기 직전 호출되는 메서드입니다.
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let calendarCell = cell as! CalendarCell
        
        // 셀 날짜 설정
        let dayText = calendarManager.dayFormat(from: date)
        calendarCell.dateLabel.text = dayText
    }
    
    /// FSCalendar의 셀이 터치되었을 때 호출되는 메서드입니다.
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let cell = calendar.cell(for: date, at: monthPosition) as! CalendarCell
        cell.selectedDateCircle.alpha = 1
        cell.selectedDateLabel.text = calendarManager.dayFormat(from: date)
    }
    
    /// FSCalendar의 셀이 선택 해제 되었을 때 호출되는 메서드입니다.
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let cell = calendar.cell(for: date, at: monthPosition) as! CalendarCell
        cell.selectedDateCircle.alpha = 0
    }
}
