//
//  RepositoryView.swift
//  DayBlock
//
//  Created by 김민준 on 11/6/23.
//

import UIKit

final class RepositoryView: UIView {
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0xF7F7F7)
        return view
    }()
    
    let calendarView = CalendarView()
    let timeLineView = TimeLineView()
    
    let tabBarStackView = TabBar(location: .calendar)
    
    // MARK: - Initial Method
    init() {
        super.init(frame: .zero)
        setupUI()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    private func setupUI() {
        backgroundColor = .white
    }
    
    private func setupAutoLayout() {
        
        // 1. ScrollView 추가
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        // 2. ContentView 추가
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // 3. 실제 내용 추가
        [calendarView, timeLineView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // 4. TabBar 추가
        addSubview(tabBarStackView)
        tabBarStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: tabBarStackView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: heightAnchor),
            
            calendarView.topAnchor.constraint(equalTo: contentView.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            calendarView.heightAnchor.constraint(equalToConstant: 400),
            
            timeLineView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 12),
            timeLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            timeLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            timeLineView.heightAnchor.constraint(equalToConstant: 200),

            tabBarStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tabBarStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabBarStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabBarStackView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
}
