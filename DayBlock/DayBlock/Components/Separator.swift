//
//  Seperator.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/16.
//

import UIKit

final class Separator: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /// Custom
        self.backgroundColor = UIColor(rgb: 0xE8E8E8)
        self.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.clipsToBounds = true
        self.layer.cornerRadius = 1
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
