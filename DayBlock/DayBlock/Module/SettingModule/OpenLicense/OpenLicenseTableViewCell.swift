//
//  OpenLicenseTableViewCell.swift
//  DayBlock
//
//  Created by 김민준 on 12/19/23.
//

import UIKit

final class OpenLicenseTableViewCell: UITableViewCell {
    
    static let cellID = "OpenLicenseTableViewCell"
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Library"
        label.font = UIFont(name: Pretendard.semiBold, size: 16)
        label.textColor = Color.subText
        label.textAlignment = .left
        return label
    }()
    
    let urlLabel: UILabel = {
        let label = UILabel()
        label.text = "http:12345/6789"
        label.font = UIFont(name: Pretendard.medium, size: 13)
        label.textColor = .systemBlue
        label.textAlignment = .left
        return label
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
        [mainLabel, urlLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            mainLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            urlLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 4),
            urlLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }
}
