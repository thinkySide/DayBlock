//
//  ManageGroupTableViewCell.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/16.
//

import UIKit

final class ManageGroupTableViewCell: UITableViewCell {
    
    // MARK: - Components
    
    let color: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 7
        return view
    }()
    
    let groupLabel: UILabel = {
        let label = UILabel()
        label.text = "그룹 없음" // ⛳️
        label.font = UIFont(name: Pretendard.semiBold, size: 16)
        label.textColor = Color.mainText
        label.textAlignment = .left
        return label
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.text = "+7" // ⛳️
        label.font = UIFont(name: Pretendard.medium, size: 15)
        label.textColor = Color.countText
        label.textAlignment = .left
        return label
    }()
    
    let checkMark: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "checkmark.circle.fill")
        image.contentMode = .scaleAspectFit
        image.tintColor = Color.mainText
        image.isHidden = true
        return image
    }()
    
    let chevron: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: Icon.selectIcon)?.withTintColor(UIColor(rgb: 0x898989))
        image.contentMode = .scaleAspectFit
        image.tintColor = Color.subText2
        image.isHidden = true
        return image
    }()
    
    let defaultGroupLabel: UILabel = {
        let label = UILabel()
        label.text = "기본 그룹"
        label.font = UIFont(name: Pretendard.semiBold, size: 13)
        label.textColor = Color.mainText
        label.backgroundColor = Color.contentsBlock
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 16
        label.alpha = 0
        return label
    }()
    
    // MARK: - Initial
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkMark.isHidden = selected ? false : true
    }
    
    override func prepareForReuse() {
        defaultGroupLabel.alpha = 0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupInitial()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInitial() {
        self.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        // 선택된 Cell 색상
        let selected = UIView()
        selected.backgroundColor = Color.contentsBlock
        self.selectedBackgroundView = selected
    }
    
    func setupAutoLayout() {
        
        /// addSubView & translatesAutoresizingMaskIntoConstraints
        [
            color, groupLabel, countLabel, checkMark, chevron, defaultGroupLabel
        ]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        // Constraint
        NSLayoutConstraint.activate([
            
            // color
            color.centerYAnchor.constraint(equalTo: centerYAnchor),
            color.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            color.widthAnchor.constraint(equalToConstant: 22),
            color.heightAnchor.constraint(equalTo: color.widthAnchor),
            
            // groupLabel
            groupLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            groupLabel.leadingAnchor.constraint(equalTo: color.trailingAnchor, constant: 8),
            
            // countLabel
            countLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            countLabel.leadingAnchor.constraint(equalTo: groupLabel.trailingAnchor, constant: 8),
            
            // checkMark
            checkMark.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkMark.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.margin),
            checkMark.widthAnchor.constraint(equalToConstant: 24),
            checkMark.heightAnchor.constraint(equalTo: checkMark.widthAnchor),
            
            // chevron
            chevron.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.margin),
            chevron.widthAnchor.constraint(equalToConstant: 24),
            chevron.heightAnchor.constraint(equalTo: chevron.widthAnchor),
            
            // defaultGroupLabel
            defaultGroupLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            defaultGroupLabel.leadingAnchor.constraint(equalTo: countLabel.trailingAnchor, constant: 8),
            defaultGroupLabel.widthAnchor.constraint(equalToConstant: 72),
            defaultGroupLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
}
