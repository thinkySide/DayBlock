//
//  SummaryView.swift
//  DayBlock
//
//  Created by 김민준 on 12/5/23.
//

import UIKit

final class SummaryView: UIView {
    
    var heightConstraint: NSLayoutConstraint!
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.bold, size: 20)
        label.textColor = Color.mainText
        label.textAlignment = .left
        label.text = "타임라인"
        return label
    }()
    
    let noTrackingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.semiBold, size: 14)
        label.textColor = Color.subText2
        label.textAlignment = .center
        label.text = "생산된 블럭이 없어요 😴"
        label.alpha = 0
        return label
    }()
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .white
        table.rowHeight = 56
        table.isScrollEnabled = false
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
        
        [tableView, noTrackingLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            // 여기서 SummarView의 높이값이 TableView에 따라 유동적으로 결정되어야 한다..
            self.topAnchor.constraint(equalTo: tableView.topAnchor, constant: -16),
            self.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            
            // headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            // headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            noTrackingLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        // TableView 높이
        heightConstraint = tableView.heightAnchor.constraint(equalToConstant: 1000)
        heightConstraint.isActive = true
    }
}
