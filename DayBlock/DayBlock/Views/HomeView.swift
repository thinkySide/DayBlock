//
//  HomeView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/03/31.
//

import UIKit

final class HomeView: UIView {
    
    // MARK: - Component
    private let myLabel: UILabel = {
        let label = UILabel()
        label.text = "22:30"
        label.font = UIFont(name: Poppins.bold, size: 40)
        return label
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
    }
    
    func setupAddSubView() {
        // 1. addSubView(component)
        addSubview(myLabel)
    }

    func setupConstraints() {
        // 2. translatesAutoresizingMaskIntoConstraints = false
        [myLabel]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        // 3. NSLayoutConstraint.activate
        NSLayoutConstraint.activate([
            myLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            myLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
