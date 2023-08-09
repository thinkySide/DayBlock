//
//  DeletePopupView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/08.
//

import UIKit

final class DeletePopupView: UIView {
    
    // MARK: - Component
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "블럭을 삭제할까요?"
        label.font = UIFont(name: Pretendard.bold, size: 18)
        label.textColor = GrayScale.mainText
        label.textAlignment = .center
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.text = "그동안 기록된 블럭 정보가 모두 삭제돼요"
        label.font = UIFont(name: Pretendard.medium, size: 15)
        label.textColor = GrayScale.subText
        label.textAlignment = .center
        return label
    }()
    
    let actionStackView: ActionStackView = {
        let stack = ActionStackView()
        stack.cancelButton.setTitle("아니오", for: .normal)
        stack.confirmButton.setTitle("삭제할래요", for: .normal)
        stack.confirmButton.setBackgroundColor(UIColor(rgb: 0xD23939), for: .normal)
        return stack
    }()
    
    // ActionButton
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.clipsToBounds = true
        self.layer.cornerRadius = 24
        
        // addSubView & resizingMask
        [mainLabel, subLabel, actionStackView]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        // NSLayoutConstraint
        NSLayoutConstraint.activate([
            
            // self
            self.topAnchor.constraint(equalTo: mainLabel.topAnchor, constant: -24),
            self.bottomAnchor.constraint(equalTo: actionStackView.bottomAnchor, constant: 24),
            
            // mainLabel
            mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // subLabel
            subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 10),
            subLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // actionStackView
            actionStackView.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 24),
            actionStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            actionStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
