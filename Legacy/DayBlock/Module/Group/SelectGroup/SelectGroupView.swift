//
//  SelectGroupView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/13.
//

import UIKit

final class SelectGroupView: UIView {
    
    // MARK: - Component
    
    let groupTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .white
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = true
        return table
    }()
    
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
    
    private func setupInitial() {
        backgroundColor = .white
        
        // CornerRadius
        self.clipsToBounds = true
        self.layer.cornerRadius = 30
    }
    
    private func setupAddSubView() {
        [groupTableView]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            groupTableView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            groupTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            groupTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            groupTableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
