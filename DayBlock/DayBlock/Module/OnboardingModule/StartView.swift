//
//  StartView.swift
//  DayBlock
//
//  Created by 김민준 on 12/15/23.
//

import UIKit

final class StartView: UIView {
    
    let startButton: ActionButton = {
        let button = ActionButton(frame: .zero, mode: .confirm)
        button.setTitle("시작하기", for: .normal)
        return button
    }()
    
    // MARK: - Initial Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAutoLayout()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAutoLayout() {
        [startButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            startButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -56),
            startButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
