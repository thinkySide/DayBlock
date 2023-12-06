//
//  SummaryTableViewCell.swift
//  DayBlock
//
//  Created by 김민준 on 12/5/23.
//

import UIKit

final class SummaryTableViewCell: UITableViewCell {
    
    static let id = "SummaryTableViewCell"
    
    let iconBlock = SimpleIconBlock(size: 32)
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.bold, size: 16)
        label.textColor = Color.mainText
        label.textAlignment = .left
        label.text = "독서하기"
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Poppins.semiBold, size: 14)
        label.textColor = Color.subText2
        label.textAlignment = .left
        label.text = "00:00-00:00"
        return label
    }()
    
    lazy var textVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [taskLabel, timeLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 0
        return stackView
    }()
    
    let plus: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Poppins.bold, size: 16)
        label.text = "+"
        label.textColor = .systemBlue
        label.textAlignment = .left
        return label
    }()
    
    let outputLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Poppins.bold, size: 16)
        label.text = "0.0"
        label.textColor = Color.mainText
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - Method
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [iconBlock, textVStackView, plus, outputLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            iconBlock.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            iconBlock.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            textVStackView.leadingAnchor.constraint(equalTo: iconBlock.trailingAnchor, constant: 14),
            textVStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            plus.trailingAnchor.constraint(equalTo: outputLabel.leadingAnchor, constant: 0),
            plus.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            outputLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            outputLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
