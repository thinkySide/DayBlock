//
//  ManageBlockTableViewHeader.swift
//  DayBlock
//
//  Created by 김민준 on 10/19/23.
//

import UIKit

final class ManageBlockTableViewHeader: UITableViewHeaderFooterView {
    static let headerID = "ManageBlockTableViewHeader"
    
    let blockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.semiBold, size: 18)
        label.textColor = Color.mainText
        label.textAlignment = .left
        label.text = "블럭명"
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        
        contentView.addSubview(blockLabel)
        blockLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            blockLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            blockLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
