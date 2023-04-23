//
//  ColorCollectionViewCell.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/23.
//

import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Component
    
    let color: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = .systemRed
        return view
    }()
    
    
    // MARK: - Method
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [color]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        NSLayoutConstraint.activate([
            
            /// color
            color.centerXAnchor.constraint(equalTo: centerXAnchor),
            color.centerYAnchor.constraint(equalTo: centerYAnchor),
            color.widthAnchor.constraint(equalToConstant: 32),
            color.heightAnchor.constraint(equalTo: color.widthAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

