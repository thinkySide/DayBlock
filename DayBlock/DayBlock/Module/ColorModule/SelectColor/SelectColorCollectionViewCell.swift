//
//  SelectColorCollectionViewCell.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/23.
//

import UIKit

final class SelectColorCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Component
    
    let selectCircle: UIView = {
        let circle = UIView()
        circle.backgroundColor = GrayScale.entireBlock
        circle.layer.borderColor = UIColor(rgb: 0xAFAFAF).cgColor
        circle.layer.borderWidth = 3
        circle.clipsToBounds = true
        circle.layer.cornerRadius = 30
        circle.alpha = 0
        return circle
    }()

    let color: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = .systemRed
        return view
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
        
        [selectCircle, color]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        NSLayoutConstraint.activate([
            
            /// selectCircle
            selectCircle.centerXAnchor.constraint(equalTo: centerXAnchor),
            selectCircle.centerYAnchor.constraint(equalTo: centerYAnchor),
            selectCircle.widthAnchor.constraint(equalToConstant: 60),
            selectCircle.heightAnchor.constraint(equalTo: selectCircle.widthAnchor),
            
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

