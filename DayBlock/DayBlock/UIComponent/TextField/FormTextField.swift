//
//  FieldForm.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/08.
//

import UIKit

final class FormTextField: UIView {
    
    // MARK: - Component
    
    let textFieldLabel: UILabel = {
        let label = UILabel()
        label.text = "작업명"
        label.font = UIFont(name: Pretendard.semiBold, size: 16)
        label.textColor = Color.subText
        label.textAlignment = .left
        return label
    }()
    
    private lazy var textFieldBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.contentsBlock
        view.clipsToBounds = true
        view.layer.borderColor = UIColor(rgb: 0xD23939).cgColor
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
    
    lazy var textField: DisablePasteTextField = {
        let field = DisablePasteTextField()
        field.placeholder = "블럭 쌓기"
        field.font = .systemFont(ofSize: 18, weight: .bold)
        field.textColor = Color.mainText
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.isSecureTextEntry = false
        return field
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.text = "0/18"
        label.font = UIFont(name: Pretendard.semiBold, size: 14)
        label.textColor = UIColor(rgb: 0xA5A5A5)
        label.textAlignment = .right
        return label
    }()
    
    let warningLabel: UILabel = {
        let label = UILabel()
        label.text = "그룹 내 중복되는 작업명의 블럭은 사용할 수 없어요"
        label.font = UIFont(name: Pretendard.medium, size: 13)
        label.textColor = UIColor(rgb: 0xD23939)
        label.textAlignment = .left
        label.alpha = 0
        return label
    }()

    
    // MARK: - Initial Method
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    /// 경고 라벨 상태 설정 메서드
    func isWarningLabelEnabled(_ bool: Bool) {
        if bool {
            warningLabel.alpha = 1
            // textFieldBackgroundView.layer.borderWidth = 2
        }
        else {
            warningLabel.alpha = 0
            // textFieldBackgroundView.layer.borderWidth = 0
        }
    }
    
    
    // MARK: - AutoLayout Method
    
    func setupAddSubView() {
        /// 1. addSubView(component)
        [textFieldLabel, textFieldBackgroundView, warningLabel]
            .forEach { addSubview($0) }
        
        /// 2. translatesAutoresizingMaskIntoConstraints = false
        [textFieldLabel, textFieldBackgroundView,
         textFieldStackView, textField, countLabel, warningLabel]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }

    func setupConstraints() {
        /// 3. NSLayoutConstraint.activate
        NSLayoutConstraint.activate([
            
            /// MainTextFieldView(self)
            self.bottomAnchor.constraint(equalTo: warningLabel.bottomAnchor),
            
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
            
            // warningLabel
            warningLabel.topAnchor.constraint(equalTo: textFieldBackgroundView.bottomAnchor,constant: 4),
            warningLabel.leadingAnchor.constraint(equalTo: textFieldLabel.leadingAnchor),
        ])
    }
}

