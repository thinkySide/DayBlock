//
//  SecondOnboardingView.swift
//  DayBlock
//
//  Created by 김민준 on 12/15/23.
//

import UIKit

final class SecondOnboardingView: UIView {
    
    // MARK: - Initial Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAutoLayout()
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAutoLayout() {
//        [].forEach {
//            addSubview($0)
//            $0.translatesAutoresizingMaskIntoConstraints = false
//        }
        
        NSLayoutConstraint.activate([
            
        ])
    }
}
