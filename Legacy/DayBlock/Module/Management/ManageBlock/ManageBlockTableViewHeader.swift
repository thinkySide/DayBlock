//
//  ManageBlockTableViewHeader.swift
//  DayBlock
//
//  Created by 김민준 on 10/19/23.
//

import UIKit

final class ManageBlockTableViewHeader: UITableViewHeaderFooterView {
    static let headerID = "ManageBlockTableViewHeader"
    
    let groupColor: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.backgroundColor = .black
        return view
    }()
    
    let groupLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.bold, size: 17)
        label.textColor = Color.mainText
        label.textAlignment = .left
        label.text = "그룹명"
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        
        contentView.addSubview(groupColor)
        contentView.addSubview(groupLabel)
        
        groupColor.translatesAutoresizingMaskIntoConstraints = false
        groupLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            groupColor.centerYAnchor.constraint(equalTo: groupLabel.centerYAnchor),
            groupColor.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            groupColor.widthAnchor.constraint(equalToConstant: 16),
            groupColor.heightAnchor.constraint(equalToConstant: 16),
            
            groupLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            groupLabel.leadingAnchor.constraint(equalTo: groupColor.trailingAnchor, constant: 6)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
