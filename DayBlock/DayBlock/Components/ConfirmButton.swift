//
//  ConfirmButton.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/16.
//

import UIKit

final class ConfirmButton: UIButton {
    
    // MARK: - Initial
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /// .normal
        self.setBackgroundColor(GrayScale.mainText, for: .normal)
        self.titleLabel?.font = UIFont(name: Pretendard.semiBold, size: 17)
        self.setTitleColor(.white, for: .normal)
        
        /// Corener Raduis
        self.clipsToBounds = true
        self.layer.cornerRadius = 13
        
        /// Size
        self.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
