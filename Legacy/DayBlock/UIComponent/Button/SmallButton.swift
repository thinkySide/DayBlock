//
//  SmallButton.swift
//  DayBlock
//
//  Created by 김민준 on 12/6/23.
//

import UIKit

final class SmallButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        self.setBackgroundColor(Color.contentsBlock, for: .normal)
        self.titleLabel?.font = UIFont(name: Poppins.bold, size: 13)
        self.setTitleColor(Color.mainText, for: .normal)
        self.setTitle("today", for: .normal)
        
        // CornerRadius
        self.clipsToBounds = true
        self.layer.cornerRadius = 13
        
        // Size
        self.heightAnchor.constraint(equalToConstant: 26).isActive = true
    }
}
