//
//  TabBarActiveStackView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/04.
//

import UIKit

class TabBarActiveStackView: UIStackView {
    
    // MARK: - Component
    private let firstActive: UIView = {
        let view = UIView()
        view.backgroundColor = GrayScale.mainText
        view.alpha = 1
        return view
    }()
    
    private let secondActive: UIView = {
        let view = UIView()
        view.backgroundColor = GrayScale.mainText
        view.alpha = 0
        return view
    }()
    
    private let thirdActive: UIView = {
        let view = UIView()
        view.backgroundColor = GrayScale.mainText
        view.alpha = 0
        return view
    }()
    
    
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
        addArrangedSubview(firstActive)
        addArrangedSubview(secondActive)
        addArrangedSubview(thirdActive)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
