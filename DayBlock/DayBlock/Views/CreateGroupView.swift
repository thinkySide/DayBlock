//
//  CreateGroupView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/17.
//

import UIKit

final class CreateGroupView: UIView {
    
    // MARK: - Component
    
    let dismissButton: UIButton = {
        let button = UIButton()
        let icon = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: icon), for: .normal)
        button.tintColor = GrayScale.mainText
        return button
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.text = "그룹 생성"
        label.font = UIFont(name: Pretendard.semiBold, size: 16)
        label.textColor = GrayScale.mainText
        label.textAlignment = .center
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
        
        /// CornerRadius
        self.clipsToBounds = true
        self.layer.cornerRadius = 30
    }
    
    func setupAddSubView() {
        [dismissButton, title]
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
            
            /// dismissButton
            dismissButton.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            dismissButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            dismissButton.widthAnchor.constraint(equalToConstant: 40),
            dismissButton.heightAnchor.constraint(equalTo: dismissButton.widthAnchor),
            
            /// title
            title.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
