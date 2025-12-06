//
//  SettingViewTableViewCell.swift
//  DayBlock
//
//  Created by 김민준 on 12/13/23.
//

import UIKit

final class SettingViewTableViewCell: UITableViewCell {
    
    static let cellID = "SettingViewTableViewCell"
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "이메일 문의"
        label.font = UIFont(name: Pretendard.semiBold, size: 16)
        label.textColor = Color.mainText
        label.textAlignment = .left
        return label
    }()
    
    let chevron: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: Icon.selectIcon)?.withTintColor(UIColor(rgb: 0x898989))
        image.contentMode = .scaleAspectFit
        image.tintColor = Color.subText2
        return image
    }()
    
    // MARK: - Initial Method
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAutoLayout()
        
        // 셀 선택 색상 변경
        let selected = UIView()
        selected.backgroundColor = Color.contentsBlock
        self.selectedBackgroundView = selected
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAutoLayout() {
        [label, chevron].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            chevron.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            chevron.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevron.widthAnchor.constraint(equalToConstant: 24),
            chevron.heightAnchor.constraint(equalTo: chevron.widthAnchor)
        ])
    }
}
