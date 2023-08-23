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
        return button
    }()
    
    
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
        [backToHomeButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            // backToHomeButton
            backToHomeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            backToHomeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.margin),
            backToHomeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -56),
        ])
    }
}
