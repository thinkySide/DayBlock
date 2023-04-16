//
//  SelectGroupView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/13.
//

import UIKit

final class SelectGroupView: UIView {
    
    // MARK: - Component
    
    let title: UILabel = {
        let label = UILabel()
        label.text = "그룹 추가" // ⛳️
        label.font = UIFont(name: Pretendard.semiBold, size: 17)
        label.textColor = GrayScale.mainText
        label.textAlignment = .center
        return label
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = true
        return table
    }()
    
    let confirmButton: ConfirmButton = {
        let button = ConfirmButton()
        button.setTitle("확인", for: .normal)
        return button
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
        [title, tableView, confirmButton]
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
            
            /// tableView
            tableView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 12),
            tableView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -24),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            /// confirmButton
            confirmButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            confirmButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.margin),
        ])
    }
}
