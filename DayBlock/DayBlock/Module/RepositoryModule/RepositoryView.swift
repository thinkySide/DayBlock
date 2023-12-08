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
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0xF7F7F7)
        return view
    }()
    
    let calendarView = CalendarView()
    let summaryView = SummaryView()
    
    let noTrackingLabelView: UIView = {
        let view = UIView()
        view.alpha = 0
        
        let label: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: Pretendard.semiBold, size: 14)
            label.textColor = Color.subText2
            label.textAlignment = .center
            label.text = "생산된 블럭이 없어요 😴"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return view
    }()
    
    // let timeLineView = TimeLineView() // 일정상 다음 업데이트로
    
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
        [calendarView, summaryView, noTrackingLabelView].forEach {
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
            contentView.bottomAnchor.constraint(equalTo: summaryView.bottomAnchor),
            
            calendarView.topAnchor.constraint(equalTo: contentView.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            summaryView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 12),
            summaryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            noTrackingLabelView.topAnchor.constraint(equalTo: summaryView.topAnchor),
            noTrackingLabelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            noTrackingLabelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            noTrackingLabelView.bottomAnchor.constraint(equalTo: tabBarStackView.bottomAnchor),

            tabBarStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tabBarStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabBarStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabBarStackView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
}
