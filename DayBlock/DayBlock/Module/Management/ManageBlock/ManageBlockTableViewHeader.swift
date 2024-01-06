//
//  ManageBlockTableViewHeader.swift
//  DayBlock
//
//  Created by 김민준 on 10/19/23.
//

import UIKit

final class ManageBlockTableViewHeader: UITableViewHeaderFooterView {
    static let headerID = "ManageBlockTableViewHeader"
    
    let spacer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0
        return view
    }()
    
    let groupLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.bold, size: 18)
        label.textColor = Color.mainText
        label.textAlignment = .left
        label.text = "그룹명"
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        
        contentView.addSubview(spacer)
        contentView.addSubview(groupLabel)
        spacer.translatesAutoresizingMaskIntoConstraints = false
        groupLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            spacer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            spacer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            spacer.heightAnchor.constraint(equalToConstant: 8),
            
            groupLabel.topAnchor.constraint(equalTo: spacer.bottomAnchor, constant: 20),
            groupLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
