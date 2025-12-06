//
//  ValueLabel.swift
//  DayBlock
//
//  Created by 김민준 on 1/9/24.
//

import UIKit

final class ValueLabel: UIStackView {
    
    let value: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Poppins.semiBold, size: 16)
        label.textColor = UIColor(rgb: 0x545454)
        label.text = "0.0"
        label.textAlignment = .center
        return label
    }()
    
    let unit: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.extraBold, size: 13)
        label.textColor = UIColor(rgb: 0x545454)
        label.text = "개"
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
        
        // 스택뷰 설정
        self.addArrangedSubview(value)
        self.addArrangedSubview(unit)
        self.axis = .horizontal
        self.alignment = .center
        self.distribution = .equalCentering
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
