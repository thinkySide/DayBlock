//
//  CalendarView.swift
//  DayBlock
//
//  Created by 김민준 on 10/19/23.
//

import UIKit
import FSCalendar

final class CalendarView: UIView {

    let calendar: FSCalendar = {
        let calendar = FSCalendar()
        return calendar
    }()
    
    let tabBarStackView = TabBar(location: .calendar)
    
    // MARK: - Initial Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        addConstraints()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    private func setupUI() {
        backgroundColor = .white
    }
    
    private func addView() {
        [calendar, tabBarStackView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: trailingAnchor),
            calendar.heightAnchor.constraint(equalToConstant: 400),
            
            tabBarStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tabBarStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabBarStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabBarStackView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
}
