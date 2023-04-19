//
//  ActionButtons.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/19.
//

import UIKit

final class ActionStackView: UIStackView {
    
    // MARK: - Button
    
    let cancelButton: ActionButton = {
        let button = ActionButton(frame: .zero, mode: .cancel)
        return button
    }()
    
    let confirmButton: ActionButton = {
        let button = ActionButton(frame: .zero, mode: .confirm)
        return button
    }()
    
    
    // MARK: - Method
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /// StackView 설정
        axis = .horizontal
        distribution = .fillEqually
        alignment = .fill
        spacing = 12
        
        /// StackView에 추가
        addArrangedSubview(cancelButton)
        addArrangedSubview(confirmButton)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
