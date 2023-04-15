//
//  SwitchGroupView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/15.
//

import UIKit

final class SwitchGroupView: UIView {
    
    // MARK: - Component
    
    
    
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
    }
    
    func setupAddSubView() {
        // 1. addSubView(component)
        
    }
    
    func setupConstraints() {
        // 2. translatesAutoresizingMaskIntoConstraints = false
//        [<#component#>]
//            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        // 3. NSLayoutConstraint.activate
        NSLayoutConstraint.activate([
            
        ])
    }
}
