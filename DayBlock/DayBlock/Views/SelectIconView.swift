//
//  SelectIconView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/13.
//

import UIKit

final class SelectIconView: UIView {
    
    // MARK: - Component
    
    private let title: UILabel = {
        let label = UILabel()
        label.text = "아이콘 선택"
        label.font = UIFont(name: Pretendard.semiBold, size: 16)
        label.textColor = GrayScale.mainText
        label.textAlignment = .center
        return label
    }()
    
    let actionStackView: ActionStackView = {
        let stack = ActionStackView()
        return stack
    }()
    
    
    // MARK: - Variable
    
    
    
    // MARK: - Initial
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitial()
        setupAddSubView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Method
    func setupInitial() {
        backgroundColor = .white
        
        /// CornerRadius
        self.clipsToBounds = true
        self.layer.cornerRadius = 30
    }
    
    func setupAddSubView() {
        [title, actionStackView]
            .forEach {
                /// 1. addSubView(component)
                addSubview($0)
                
                /// 2. translatesAutoresizingMaskIntoConstraints = false
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
    }
    
    func setupConstraints() {
        
        /// 3. NSLayoutConstraint.activate
        NSLayoutConstraint.activate([
            
            /// title
            title.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            /// actionStackView
            actionStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            actionStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            actionStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.margin),
        ])
    }
}
