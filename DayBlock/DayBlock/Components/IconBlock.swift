//
//  IconBlock.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/12.
//

import UIKit

final class IconBlock: UIView {
    
    // MARK: - Component
    
    let symbol: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "book.closed.fill")
        image.contentMode = .scaleAspectFit
        image.tintColor = .white
        return image
    }()
    
    
    // MARK: - Initial Method
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Design Setting
        self.backgroundColor = Color.testBlue
        self.clipsToBounds = true
        self.layer.cornerRadius = 12
        
        // AddView & translatesAutoresizingMaskIntoConstraints
        [symbol].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // AutoLayout Setting
        NSLayoutConstraint.activate([
            
            // self(IconBlock)
            self.widthAnchor.constraint(equalToConstant: 44),
            self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1),
            
            // symbol
            symbol.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            symbol.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            symbol.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            symbol.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
