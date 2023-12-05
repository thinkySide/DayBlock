//
//  CalendarView.swift
//  DayBlock
//
//  Created by 김민준 on 10/19/23.
//

import UIKit
import FSCalendar

final class CalendarView: UIView {
    
    var calendarHeight: NSLayoutConstraint?
    
    let calendarHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Poppins.bold, size: 22)
        label.textColor = Color.mainText
        label.textAlignment = .left
        return label
    }()
    
    let previousButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        let image = UIImage(systemName: "chevron.left")?.withConfiguration(configuration)
        button.setImage(image, for: .normal)
        button.tintColor = Color.mainText
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        let image = UIImage(systemName: "chevron.right")?.withConfiguration(configuration)
        
        button.setImage(image, for: .normal)
        button.tintColor = Color.mainText
        return button
    }()

    let calendar: FSCalendar = {
        let calendar = FSCalendar()
        
        // 기본 설정
        calendar.placeholderType = .none // 현재 달의 날짜만 표시
        
        // 기본 Header 삭제
        calendar.headerHeight = 0
        
        // 요일 라벨 설정
        calendar.appearance.weekdayFont = UIFont(name: Poppins.bold, size: 13)
        calendar.appearance.weekdayTextColor = UIColor(rgb: 0x757575)
        
        // 선택 효과 가리기
        calendar.appearance.selectionColor = .none
        
        // 페이징 삭제
        calendar.scrollEnabled = false
        
        return calendar
    }()
    
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
        [calendarHeaderLabel, previousButton, nextButton, calendar].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(equalTo: calendar.bottomAnchor),
            
            calendarHeaderLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            calendarHeaderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            previousButton.widthAnchor.constraint(equalToConstant: 20),
            previousButton.heightAnchor.constraint(equalToConstant: 20),
            previousButton.centerYAnchor.constraint(equalTo: calendarHeaderLabel.centerYAnchor),
            previousButton.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor, constant: -16),
            
            nextButton.widthAnchor.constraint(equalToConstant: 20),
            nextButton.heightAnchor.constraint(equalToConstant: 20),
            nextButton.centerYAnchor.constraint(equalTo: calendarHeaderLabel.centerYAnchor),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            calendar.topAnchor.constraint(equalTo: calendarHeaderLabel.bottomAnchor),
            calendar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            calendar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            calendar.heightAnchor.constraint(equalToConstant: 360)
        ])
    }
}
