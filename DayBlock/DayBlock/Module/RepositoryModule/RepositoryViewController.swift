//
//  RepositoryViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/02.
//

import UIKit
import FSCalendar

final class RepositoryViewController: UIViewController {
    
    private let viewManager = RepositoryView()
    private lazy var calendarView = viewManager.calendarView
    private let calendarManager = CalendarManager.shared
    
    // MARK: - ViewController LifeCycle
    override func loadView() {
        view = viewManager
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupCalendar()
        setupEvent()
    }
    
    // MARK: - Setup Method
    private func setupNavigation() {
        
        // 네비게이션바의 Appearance를 설정
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.tintColor = .white
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
    
    private func setupCalendar() {
        
        let calendar = calendarView.calendar
        
        // 기본 설정
        calendar.dataSource = self
        calendar.delegate = self
        calendar.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.id)
        calendar.today = nil
        
        // 현재 Cell 불러오기
//        calendar.visibleCells().forEach { cell in
//            let date = calendar.date(for: cell)
//            let position = calendar.monthPosition(for: cell)
//            calendarView.calendar.select(date)
//        }
        
        // Header date 설정
        calendarView.calendarHeaderLabel.text = calendarManager.headerDateFormatter.string(from: Date())
    }
    
    private func setupEvent() {
        calendarView.previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        calendarView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Event Method
    
    /// 달력 이전 버튼 클릭 시 호출되는 메서드입니다.
    @objc private func previousButtonTapped() {
        
        // 이전 달로 달력 전환
        guard let previousDate =
                Calendar.current.date(
                    byAdding: .weekOfMonth,
                    value: -1,
                    to: calendarView.calendar.currentPage) else { return }
        calendarView.calendar.setCurrentPage(previousDate, animated: true)
        
        // 마지막 날짜 Select
        let endDate = Date().lastDayOfMonth(from: previousDate)
        calendarView.calendar.select(endDate)
    }
    
    /// 달력 다음 버튼 클릭 시 호출되는 메서드입니다.
    @objc private func nextButtonTapped() {
        guard let nextDate =
                Calendar.current.date(
                    byAdding: .month,
                    value: 1,
                    to: calendarView.calendar.currentPage) else { return }
        calendarView.calendar.setCurrentPage(nextDate, animated: true)
        
        // 시작 날짜 Select
        let startDate = Date().firstDayOfMonth(from: nextDate)
        calendarView.calendar.select(startDate)
    }
}

// MARK: - FSCalendarDataSource & FSCalendarDelegate
extension RepositoryViewController: FSCalendarDataSource & FSCalendarDelegate {
    
    /// 캘린더 달이 변경될 때마다 호출되는 메서드입니다.
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentDate = calendar.currentPage
        calendarView.calendarHeaderLabel.text = calendarManager.headerDateFormatter.string(from: currentDate)
    }
    
    /// FSCalendar 셀을 반환합니다.
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: CalendarCell.id, for: date, at: position) as! CalendarCell
        cell.selectedDateLabel.text = calendarManager.dayFormat(from: date)
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
        //
    }
    
    /// FSCalendar의 셀이 선택 해제 되었을 때 호출되는 메서드입니다.
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //
    }
}
