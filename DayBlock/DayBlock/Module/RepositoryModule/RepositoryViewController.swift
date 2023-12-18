//
//  RepositoryViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/02.
//

import UIKit
import FSCalendar

final class RepositoryViewController: UIViewController {
    
    let viewManager = RepositoryView()
    lazy var calendarView = viewManager.calendarView
    let calendarManager = CalendarManager.shared
    let groupDataManager = GroupDataStore.shared
    let repositoryManager = RepositoryManager.shared
    
    // MARK: - ViewController LifeCycle
    override func loadView() {
        view = viewManager
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupCalendar()
        setupTableView()
        setupEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateRepositoryView(date: repositoryManager.currentDate)
    }
    
    // MARK: - Setup Method
    private func setupNavigation() {
        
        // 네비게이션바의 Appearance를 설정
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.shadowColor = .clear
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
    
    private func setupCalendar() {
        
        let calendar = calendarView.calendar
        
        // 기본 설정
        calendar.dataSource = self
        calendar.delegate = self
        calendar.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.id)
        calendar.today = nil
        
        // Header date 설정
        calendarView.calendarHeaderLabel.text = calendarManager.headerDateFormatter.string(from: Date())
        
        // 오늘 날짜 선택(기본값)
        calendarView.calendar.select(Date())
    }
    
    private func setupEvent() {
        calendarView.todayButton.addTarget(self, action: #selector(todayButtonTapped), for: .touchUpInside)
        calendarView.previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        calendarView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        // 테스트용 이벤트
        let testGesture = UITapGestureRecognizer(target: self, action: #selector(test))
        viewManager.summaryView.headerLabel.addGestureRecognizer(testGesture)
        viewManager.summaryView.headerLabel.isUserInteractionEnabled = true
    }
    
    // MARK: - Event Method
    
    /// 코어데이터 테스트용 메서드
    @objc func test() {
        groupDataManager.printCoreData()
    }
    
    /// today 버튼 탭 시 호출되는 메서드입니다.
    @objc private func todayButtonTapped() {
        let today = Date()
        repositoryManager.currentDate = today
        viewManager.calendarView.calendar.select(today, scrollToDate: true)
        calendarView.calendar.setCurrentPage(today, animated: true)
        updateRepositoryView(date: today)
        Vibration.selection.vibrate()
    }
    
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
        calendarView.calendar.select(endDate, scrollToDate: true)
        
        // SummaryView 업데이트
        repositoryManager.currentDate = endDate
        updateRepositoryView(date: endDate)
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
        calendarView.calendar.select(startDate, scrollToDate: true)
        
        // SummaryView 업데이트
        repositoryManager.currentDate = startDate
        updateRepositoryView(date: startDate)
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
        
        // 셀 타입 업데이트
        let dateString = calendarManager.fullDateFormat(from: date)
        let cellType = repositoryManager.blockTypeCount(dateString: dateString)
        let colors = repositoryManager.blockColors(dateString: dateString)
        cell.block.updateState(cellType, colors: colors)
        
        // 셀 선택 날짜 업데이트
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
        
        // 1. 현재 날짜 업데이트
        repositoryManager.currentDate = date
        
        // 2. 코어데이터에 해당 날짜의 모든 데이터 불러오기
        updateRepositoryView(date: date)
    }
    
    /// FSCalendar의 높이값이 변경될 때 호출되는 메서드입니다.
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        print(#function)
        NSLayoutConstraint.activate([
            calendar.heightAnchor.constraint(equalToConstant: bounds.height)
        ])
        self.viewManager.layoutIfNeeded()
    }
}
