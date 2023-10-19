//
//  ManageBlockView.swift
//  DayBlock
//
//  Created by 김민준 on 10/19/23.
//

import UIKit

final class ManageBlockView: UIView {
    
    let sectionBar: SectionBar = {
        let sectionBar = SectionBar()
        sectionBar.firstSection.label.text = "블럭 관리"
        sectionBar.secondSection.label.text = "그룹 관리"
        return sectionBar
    }()
    
    let tableHeaderView: UIView = {
        let header = UIView()
        header.backgroundColor = .systemBlue
        
        let label = UILabel()
        label.font = UIFont(name: Pretendard.semiBold, size: 18)
        label.textColor = Color.mainText
        label.textAlignment = .left
        label.text = "블럭명"
        
        header.addSubview(label)
        return header
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemGreen
        return tableView
    }()
    
    let tabBarStackView = TabBar(location: .manage)
    
    // MARK: - Initial Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        addConstraints()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    private func setupUI() {
        backgroundColor = .white
    }
    
    private func addView() {
        [sectionBar, tableView, tabBarStackView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            sectionBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            sectionBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            sectionBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: sectionBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: tabBarStackView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            tabBarStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tabBarStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabBarStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabBarStackView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
