//
//  MainTextFieldView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/08.
//

import UIKit

final class MainTextFieldView: UIView {
    
    // MARK: - Component
    
    private let textFieldLabel: UILabel = {
        let label = UILabel()
        label.text = "작업명"
        label.font = UIFont(name: Pretendard.semiBold, size: 16)
        label.textColor = GrayScale.subText
        label.textAlignment = .left
        return label
    }()
    
    private lazy var textFieldBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = GrayScale.contentsBlock
        view.clipsToBounds = true
        view.addSubview(textFieldStackView)
        return view
    }()
    
    private lazy var textFieldStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [textField, countLabel])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 4
        return stack
    }()
    
    private lazy var textField: UITextField = {
        let field = UITextField()
        field.placeholder = "블럭 쌓기"
        field.font = .systemFont(ofSize: 18, weight: .bold)
        field.textColor = GrayScale.mainText
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.isSecureTextEntry = false
        field.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        return field
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.text = "0/18"
        label.font = UIFont(name: Pretendard.semiBold, size: 14)
        label.textColor = UIColor(rgb: 0xA5A5A5)
        label.textAlignment = .right
        return label
    }()
    
    
    // MARK: - Variable
    
    
    
    // MARK: - Method
    
    @objc func textFieldChanged() {
        print(#function)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitial()
        setupAddSubView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        /// CornerRadius
        textFieldBackgroundView.layer.cornerRadius = textFieldBackgroundView.frame.height / 5
    }
    
    
    
    // MARK: - Method
    func setupInitial() {
        
    }
    
    func setupAddSubView() {
        /// 1. addSubView(component)
        [textFieldLabel, textFieldBackgroundView]
            .forEach { addSubview($0) }
        
        /// 2. translatesAutoresizingMaskIntoConstraints = false
        [textFieldLabel, textFieldBackgroundView,
         textFieldStackView, textField, countLabel]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }

    func setupConstraints() {
        /// 3. NSLayoutConstraint.activate
        NSLayoutConstraint.activate([
            
            /// MainTextFieldView(self)
            self.bottomAnchor.constraint(equalTo: textFieldBackgroundView.bottomAnchor),
            
            /// textFieldLabel
            textFieldLabel.topAnchor.constraint(equalTo: topAnchor),
            textFieldLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            
            /// textFieldBackgroundView
            textFieldBackgroundView.topAnchor.constraint(equalTo: textFieldLabel.bottomAnchor, constant: 10),
            textFieldBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textFieldBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textFieldBackgroundView.heightAnchor.constraint(equalToConstant: 56),
            
            /// textFieldStackView
            textFieldStackView.centerYAnchor.constraint(equalTo: textFieldBackgroundView.centerYAnchor),
            textFieldStackView.leadingAnchor.constraint(equalTo: textFieldBackgroundView.leadingAnchor, constant: 16),
            textFieldStackView.trailingAnchor.constraint(equalTo: textFieldBackgroundView.trailingAnchor, constant: -16),
                
            /// countLabel
            countLabel.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
}

