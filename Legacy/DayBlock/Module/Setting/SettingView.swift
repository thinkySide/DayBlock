//
//  SettingView.swift
//  DayBlock
//
//  Created by 김민준 on 12/13/23.
//

import UIKit

final class SettingView: UIView {
    
    var heightConstraint: NSLayoutConstraint!
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .white
        table.rowHeight = 56
        table.isScrollEnabled = false
        return table
    }()
    
    // MARK: - Initial Method
    
    init(rowCount: Int) {
        super.init(frame: .zero)
        self.backgroundColor = .white
        setupAutoLayout()
        
        // TableView 높이 (셀 기본 높이 * 셀 개수 + 마진값)
        let height = CGFloat(56 * rowCount + 24)
        heightConstraint = heightAnchor.constraint(equalToConstant: height)
        heightConstraint.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAutoLayout() {
        [tableView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
