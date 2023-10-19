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
        view.backgroundColor = UIColor(rgb: 0xF2F2F7)
        return view
    }()
    
    let blockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.bold, size: 18)
        label.textColor = Color.mainText
        label.textAlignment = .left
        label.text = "블럭명"
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        
        contentView.addSubview(spacer)
        contentView.addSubview(blockLabel)
        spacer.translatesAutoresizingMaskIntoConstraints = false
        blockLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            spacer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            spacer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            spacer.heightAnchor.constraint(equalToConstant: 12),
            
            blockLabel.topAnchor.constraint(equalTo: spacer.bottomAnchor, constant: 20),
            blockLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
