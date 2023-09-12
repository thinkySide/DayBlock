//
//  TrackingCompleteView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/23.
//

import UIKit

final class TrackingCompleteView: UIView {
    
    // MARK: - Properties
    
    let backToHomeButton: ActionButton = {
        let button = ActionButton(frame: .zero, mode: .confirm)
        button.setTitle("홈 화면으로 돌아가기", for: .normal)
        return button
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            iconBlock, taskLabel])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 16
        return stack
    }()
    
    let iconBlock: IconBlock = {
        let icon = IconBlock()
        return icon
    }()
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.text = "Swift 공부" // ⛳️
        label.font = UIFont(name: Pretendard.bold, size: 20)
        label.textColor = GrayScale.mainText
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private let dashedSeparator = DashedSeparator(frame: .zero)
    
    // MARK: - Initial Method
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupAddView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Auto Layout Method
    
    private func setupAddView() {
        [titleStackView,
         dashedSeparator,
         backToHomeButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            // titleStackView
            titleStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32),
            titleStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // dashedSeparator
            dashedSeparator.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 32),
            dashedSeparator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 86),
            dashedSeparator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -86),

            // backToHomeButton
            backToHomeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            backToHomeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.margin),
            backToHomeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -56),
        ])
    }
}
