//
//  GroupSelectTableViewCell.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/16.
//

import UIKit

final class GroupSelectTableViewCell: UITableViewCell {
    
    // MARK: - Components
    
    let groupLabel: UILabel = {
        let label = UILabel()
        label.text = "그룹 없음" // ⛳️
        label.font = UIFont(name: Pretendard.semiBold, size: 17)
        label.textColor = GrayScale.mainText
        label.textAlignment = .left
        return label
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.text = "+7" // ⛳️
        label.font = UIFont(name: Pretendard.medium, size: 15)
        label.textColor = GrayScale.subText
        label.textAlignment = .left
        return label
    }()
    
    private let seperator: Seperator = {
        let line = Seperator()
        return line
    }()
    
    private let blockPreviewIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "checkmark.circle.fill")
        image.contentMode = .scaleAspectFit
        image.tintColor = GrayScale.mainText
        return image
    }()
    

    // MARK: - Initial
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupInitial()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInitial() {
        self.heightAnchor.constraint(equalToConstant: 52).isActive = true
        self.selectionStyle = .none
    }
    
    func setupAutoLayout() {
        
        /// addSubView & translatesAutoresizingMaskIntoConstraints
        [
            groupLabel, countLabel, blockPreviewIcon, seperator,
        ]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        /// Constraint
        NSLayoutConstraint.activate([
            
            /// groupLabel
            groupLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            groupLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            /// countLabel
            countLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            countLabel.leadingAnchor.constraint(equalTo: groupLabel.trailingAnchor, constant: 8),
            
            /// blockPreviewIcon
            blockPreviewIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            blockPreviewIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.margin),
            blockPreviewIcon.widthAnchor.constraint(equalToConstant: 22),
            blockPreviewIcon.heightAnchor.constraint(equalTo: blockPreviewIcon.widthAnchor),
            
            /// seperator
            seperator.bottomAnchor.constraint(equalTo: bottomAnchor),
            seperator.leadingAnchor.constraint(equalTo: leadingAnchor),
            seperator.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
}
