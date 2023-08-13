//
//  SelectGroupView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/13.
//

import UIKit

final class SelectGroupView: UIView {
    
    // MARK: - Component
    
    private let title: UILabel = {
        let label = UILabel()
        label.text = "그룹 선택"
        label.font = UIFont(name: Pretendard.semiBold, size: 16)
        label.textColor = GrayScale.mainText
        label.textAlignment = .center
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        let icon = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        button.setImage(UIImage(systemName: "plus", withConfiguration: icon), for: .normal)
        button.tintColor = GrayScale.mainText
        return button
    }()
    
    let groupTableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = true
        return table
    }()
    
    let actionStackView: ActionStackView = {
        let stack = ActionStackView()
        return stack
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
        [title, addButton, groupTableView, actionStackView]
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
            
            /// title
            title.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            /// addButton
            addButton.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            addButton.widthAnchor.constraint(equalToConstant: 40),
            addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor),
            
            /// groupTableView
            groupTableView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            groupTableView.bottomAnchor.constraint(equalTo: actionStackView.topAnchor, constant: -16),
            groupTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            groupTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            /// actionStackView
            actionStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            actionStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            actionStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.margin),
        ])
    }
}
