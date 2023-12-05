//
//  SimpleIconBlock.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/12.
//

import UIKit

final class SimpleIconBlock: UIView {
    
    // MARK: - Component
    
    let symbol: UIImageView = {
        let image = UIImageView()
        // image.image = UIImage(systemName: "book.closed.fill")
        image.contentMode = .scaleAspectFit
        image.tintColor = .white
        return image
    }()
    
    // MARK: - Initial Method
    
    init(size: CGFloat) {
        super.init(frame: .zero)
        
        // Design Setting
        self.backgroundColor = UIColor(rgb: 0xE8E8E8)
        self.clipsToBounds = true
        self.layer.cornerRadius = size / 3.5
        
        // AddView & translatesAutoresizingMaskIntoConstraints
        [symbol].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let spacing = size / 5
        
        // AutoLayout Setting
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: size),
            self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1),
            
            symbol.topAnchor.constraint(equalTo: topAnchor, constant: spacing),
            symbol.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -spacing),
            symbol.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing),
            symbol.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -spacing)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
