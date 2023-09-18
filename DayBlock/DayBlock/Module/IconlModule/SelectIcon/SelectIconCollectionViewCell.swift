//
//  SelectIconCollectionViewCell.swift
//  DayBlock
//
//  Created by 김민준 on 2023/05/09.
//

import UIKit

final class SelectIconCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Component
    
    let icon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.tintColor = Color.mainText
        return image
    }()
    
    let selectCircle: UIView = {
        let circle = UIView()
        circle.backgroundColor = Color.entireBlock
        circle.layer.borderColor = UIColor(rgb: 0xAFAFAF).cgColor
        circle.layer.borderWidth = 3
        circle.clipsToBounds = true
        circle.layer.cornerRadius = 30
        circle.alpha = 0
        return circle
    }()
    
    // MARK: - Method
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectCircle.alpha = 1
            } else {
                selectCircle.alpha = 0
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [selectCircle, icon]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        NSLayoutConstraint.activate([
            
            // color
            icon.centerXAnchor.constraint(equalTo: centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 32),
            icon.heightAnchor.constraint(equalTo: icon.widthAnchor),
            
            // selectCircle
            selectCircle.centerXAnchor.constraint(equalTo: centerXAnchor),
            selectCircle.centerYAnchor.constraint(equalTo: centerYAnchor),
            selectCircle.widthAnchor.constraint(equalToConstant: 60),
            selectCircle.heightAnchor.constraint(equalTo: selectCircle.widthAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
