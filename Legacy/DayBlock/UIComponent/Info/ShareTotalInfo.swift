//
//  ShareTotalInfo.swift
//  DayBlock
//
//  Created by 김민준 on 1/5/24.
//

import UIKit

final class ShareTotalInfo: UIView {
    
    private let shareLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Poppins.bold, size: 14)
        label.textColor = UIColor(rgb: 0x616161)
        label.textAlignment = .right
        label.text = "share"
        return label
    }()
    
    let shareValue: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Poppins.bold, size: 18)
        label.textColor = Color.mainText
        label.textAlignment = .right
        label.text = "13%"
        return label
    }()
    
    private let separator: UIView = {
        let line = UIView()
        line.backgroundColor = Color.seperator2
        return line
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Poppins.bold, size: 14)
        label.textColor = UIColor(rgb: 0x616161)
        label.textAlignment = .right
        label.text = "total"
        return label
    }()
    
    let totalValue: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Poppins.bold, size: 18)
        label.textColor = Color.mainText
        label.textAlignment = .right
        label.text = "+72.5"
        return label
    }()
    
    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAutoLayout() {
        [shareLabel, shareValue, separator, totalLabel, totalValue].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            self.trailingAnchor.constraint(equalTo: totalValue.trailingAnchor),
            self.heightAnchor.constraint(equalToConstant: 28),
            
            shareLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            shareLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            shareValue.centerYAnchor.constraint(equalTo: centerYAnchor),
            shareValue.leadingAnchor.constraint(equalTo: shareLabel.trailingAnchor, constant: 6),
            
            separator.centerYAnchor.constraint(equalTo: centerYAnchor),
            separator.leadingAnchor.constraint(equalTo: shareValue.trailingAnchor, constant: 12),
            separator.widthAnchor.constraint(equalToConstant: 2),
            separator.heightAnchor.constraint(equalToConstant: 13),
            
            totalLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            totalLabel.leadingAnchor.constraint(equalTo: separator.trailingAnchor, constant: 12),
            
            totalValue.centerYAnchor.constraint(equalTo: centerYAnchor),
            totalValue.leadingAnchor.constraint(equalTo: totalLabel.trailingAnchor, constant: 6)
        ])
    }
}
