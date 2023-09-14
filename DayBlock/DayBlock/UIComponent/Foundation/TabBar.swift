//
//  TabBar.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/04.
//

import UIKit

final class TabBar: UIStackView {
    
    enum SwitchTabBar {
        case home
        case schedule
        case storage
    }
    
    // MARK: - Component
    private let homeActive: UIView = {
        let view = UIView()
        view.backgroundColor = GrayScale.mainText
        view.alpha = 1
        return view
    }()
    
    private let scheduleActive: UIView = {
        let view = UIView()
        view.backgroundColor = GrayScale.mainText
        view.alpha = 0
        return view
    }()
    
    private let storageActive: UIView = {
        let view = UIView()
        view.backgroundColor = GrayScale.mainText
        view.alpha = 0
        return view
    }()
    
    func switchTabBarActive(_ currentView: SwitchTabBar) {
        switch currentView {
        case .home:
            homeActive.alpha = 1
            scheduleActive.alpha = 0
            storageActive.alpha = 0
        case .schedule:
            homeActive.alpha = 0
            scheduleActive.alpha = 1
            storageActive.alpha = 0
        case .storage:
            homeActive.alpha = 0
            scheduleActive.alpha = 0
            storageActive.alpha = 1
        }
    }
    
    
    // MARK: - Method
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(rgb: 0xF7F7F7)
        
        /// StackView 설정
        axis = .horizontal
        distribution = .fillEqually
        alignment = .fill
        spacing = 0
        
        /// StackView에 추가
        addArrangedSubview(homeActive)
        addArrangedSubview(scheduleActive)
        addArrangedSubview(storageActive)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
