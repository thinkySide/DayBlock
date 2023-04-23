//
//  ColorCollectionViewCell.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/23.
//

import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Component
    

    
    // MARK: - Method
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemRed
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

