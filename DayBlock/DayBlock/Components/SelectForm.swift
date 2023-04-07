//
//  SelectForm.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/08.
//

import UIKit

final class SelectForm: UIView {
    
    // MARK: - Component
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.addSubview(contentStackView)
        view.addSubview(seperator)
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [selectLabel, selectStackView])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 4
        return stack
    }()
    
    private let selectLabel: UILabel = {
        let label = UILabel()
        label.text = "그룹"
        label.font = UIFont(name: Pretendard.semiBold, size: 16)
        label.textColor = GrayScale.subText
        label.textAlignment = .left
        return label
    }()
    
    private lazy var selectStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [polygon])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 8
        return stack
    }()
    
    private let polygon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: Icon.groupPolygon)
        return image
    }()
    
    private let seperator: UIView = {
        let line = UIView()
        line.backgroundColor = GrayScale.seperator
        return line
    }()
    
    
    
    // MARK: - Variable
    
    
    
    // MARK: - Method
    
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
        
    }
    
    func setupAddSubView() {
        /// 1. addSubView(component)
        [contentView]
            .forEach { addSubview($0) }
        
        /// 2. translatesAutoresizingMaskIntoConstraints = false
        [contentView, contentStackView, selectLabel, selectStackView, polygon, seperator]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
    
    func setupConstraints() {
        /// 3. NSLayoutConstraint.activate
        NSLayoutConstraint.activate([
            
            /// SelectForm(self)
            self.bottomAnchor.constraint(equalTo: seperator.bottomAnchor),
            
            /// contentView
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            /// contentStackView
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentStackView.heightAnchor.constraint(equalToConstant: 40),
            
            /// seperator
            seperator.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 8),
            seperator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            seperator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            seperator.heightAnchor.constraint(equalToConstant: Size.seperator),
        ])
    }
}
