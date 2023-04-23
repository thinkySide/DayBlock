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
    
    let selectCircle: UIView = {
        let circle = UIView()
        circle.backgroundColor = .none
        circle.layer.borderColor = GrayScale.mainText.cgColor
        circle.layer.borderWidth = 3
        circle.clipsToBounds = true
        circle.layer.cornerRadius = 28
        circle.alpha = 0
        return circle
    }()
    
    
    // MARK: - Method
    
    /// 블럭 재사용 문제 해결
    override func prepareForReuse() {
        // selectCircle.isHidden = true
    }
    
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
        
        [color, selectCircle]
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
            
            /// selectCircle
            selectCircle.centerXAnchor.constraint(equalTo: centerXAnchor),
            selectCircle.centerYAnchor.constraint(equalTo: centerYAnchor),
            selectCircle.widthAnchor.constraint(equalToConstant: 56),
            selectCircle.heightAnchor.constraint(equalTo: selectCircle.widthAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

