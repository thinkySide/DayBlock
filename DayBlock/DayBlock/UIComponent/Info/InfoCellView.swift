//
//  InfoCellView.swift
//  DayBlock
//
//  Created by 김민준 on 12/13/23.
//

import UIKit

final class InfoCellView: UIView {
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.semiBold, size: 16)
        label.textColor = Color.mainText
        label.textAlignment = .left
        label.text = "버전"
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.medium, size: 14)
        label.textColor = Color.subText2
        label.textAlignment = .center
        label.text = "0.1"
        return label
    }()
    
    // MARK: - Initial Method
    init(tagLabel: String, valueLabel: String) {
        super.init(frame: .zero)
        setupAutoLayout()
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAutoLayout() {
        [tagLabel, valueLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 32),
            
            tagLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            tagLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }
}
