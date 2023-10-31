//
//  CalendarView.swift
//  DayBlock
//
//  Created by 김민준 on 10/19/23.
//

import UIKit

final class CalendarView: UIView {
    
    let calendarView: UICalendarView = {
        let calendar = UICalendarView()
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.fontDesign = .rounded
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
        [tabBarStackView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            tabBarStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tabBarStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabBarStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabBarStackView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
}
