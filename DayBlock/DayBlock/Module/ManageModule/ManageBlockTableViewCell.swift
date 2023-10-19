//
//  ManageBlockTableViewCell.swift
//  DayBlock
//
//  Created by 김민준 on 10/19/23.
//

import UIKit

final class ManageBlockTableViewCell: UITableViewCell {
    
    static let cellID = "ManageBlockTableViewCell"
    
    let iconBlock: SimpleIconBlock = {
        let icon = SimpleIconBlock(size: 32)
        return icon
    }()
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.text = "독서하기"
        label.font = UIFont(name: Pretendard.semiBold, size: 16)
        label.textColor = Color.mainText
        label.textAlignment = .left
        return label
    }()
    
    let outputLabel: UILabel = {
        let label = UILabel()
        label.text = "total +72.5"
        label.font = UIFont(name: Pretendard.medium, size: 15)
        label.textColor = Color.countText
        label.textAlignment = .left
        return label
    }()
    
    lazy var vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [taskLabel, outputLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 1
        return stackView
    }()
    
    let chevron: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "chevron.right")
        image.contentMode = .scaleAspectFit
        image.tintColor = Color.subText2
        return image
    }()
    
    // MARK: - Init Method
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        // 셀 선택 색상 변경
        let selected = UIView()
        selected.backgroundColor = Color.contentsBlock
        self.selectedBackgroundView = selected
        
        [iconBlock, vStack, chevron].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 64),
            
            iconBlock.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            iconBlock.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            vStack.leadingAnchor.constraint(equalTo: iconBlock.trailingAnchor, constant: 12),
            vStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            chevron.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.margin),
            chevron.widthAnchor.constraint(equalToConstant: 24),
            chevron.heightAnchor.constraint(equalTo: chevron.widthAnchor)
        ])
    }
}
