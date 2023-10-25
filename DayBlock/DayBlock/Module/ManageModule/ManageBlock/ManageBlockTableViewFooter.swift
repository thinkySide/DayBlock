//
//  ManageBlockTableViewFooter.swift
//  DayBlock
//
//  Created by 김민준 on 10/19/23.
//

import UIKit

final class ManageBlockTableViewFooter: UITableViewHeaderFooterView {
    static let footerID = "ManageBlockTableViewFooter"
    
    let iconBlock: SimpleIconBlock = {
        let icon = SimpleIconBlock(size: 32)
        let configuration = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: "plus", withConfiguration: configuration)
        icon.symbol.tintColor = Color.subText2
        icon.symbol.image = image
        icon.backgroundColor = UIColor(rgb: 0xE8E8E8)
        return icon
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "블럭 추가하기"
        label.font = UIFont(name: Pretendard.semiBold, size: 16)
        label.textColor = Color.subText2
        label.textAlignment = .left
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        
        contentView.addSubview(iconBlock)
        contentView.addSubview(label)
        iconBlock.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconBlock.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconBlock.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 21),
            
            label.centerYAnchor.constraint(equalTo: iconBlock.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: iconBlock.trailingAnchor, constant: 12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
