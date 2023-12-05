//
//  SummaryView.swift
//  DayBlock
//
//  Created by 김민준 on 12/5/23.
//

import UIKit

final class SummaryView: UIView {
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.bold, size: 20)
        label.textColor = Color.mainText
        label.textAlignment = .left
        label.text = "타임라인"
        return label
    }()
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .white
        return table
    }()
    
    // MARK: - 기본 메서드
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - AutoLayout Method
    private func setupUI() {
        backgroundColor = .white
        
        [headerLabel, tableView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
