//
//  CustomUIMenu.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/13.
//

import UIKit

final class CustomUIMenu: UIView {
    
    /// UIMenu의 개수
    enum Number {
        case two
        case three
        case four
        case five
    }
    
    // MARK: - Property
    
    let firstItem = CustomUIMenuItem()
    let secondItem = CustomUIMenuItem()
    let thirdItem = CustomUIMenuItem()
    let fourthItem = CustomUIMenuItem()
    let fifthItem = CustomUIMenuItem()
    
    
    // MARK: - Initializer
    
    init(frame: CGRect, number: Number) {
        super.init(frame: frame)
        
        // backgroundColor = UIColor(rgb: 0xF4F5F7)
        backgroundColor = .white
        
        // CornerRadius
        clipsToBounds = true
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor(rgb: 0xF3F3F3).cgColor
        
        // Shadow Effect
        layer.borderWidth = 1
        layer.borderColor = UIColor(rgb: 0xF3F3F3).cgColor
        layer.masksToBounds = false
        layer.shadowColor = UIColor(rgb: 0x18274B).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 32
        
        [firstItem, secondItem, thirdItem, fourthItem, fifthItem].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        switch number {
        case .two:
            [firstItem, secondItem].forEach { addSubview($0) }
            NSLayoutConstraint.activate([
                firstItem.topAnchor.constraint(equalTo: topAnchor),
                firstItem.leadingAnchor.constraint(equalTo: leadingAnchor),
                firstItem.trailingAnchor.constraint(equalTo: trailingAnchor),
                
                secondItem.topAnchor.constraint(equalTo: firstItem.bottomAnchor),
                secondItem.bottomAnchor.constraint(equalTo: bottomAnchor),
                secondItem.leadingAnchor.constraint(equalTo: leadingAnchor),
                secondItem.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
            
            secondItem.seperator.isHidden = true
            
        case .three:
            [firstItem, secondItem, thirdItem].forEach { addSubview($0) }
            NSLayoutConstraint.activate([
                firstItem.topAnchor.constraint(equalTo: topAnchor),
                firstItem.leadingAnchor.constraint(equalTo: leadingAnchor),
                firstItem.trailingAnchor.constraint(equalTo: trailingAnchor),
                
                secondItem.topAnchor.constraint(equalTo: firstItem.bottomAnchor),
                secondItem.leadingAnchor.constraint(equalTo: leadingAnchor),
                secondItem.trailingAnchor.constraint(equalTo: trailingAnchor),
                
                thirdItem.topAnchor.constraint(equalTo: secondItem.bottomAnchor),
                thirdItem.bottomAnchor.constraint(equalTo: bottomAnchor),
                thirdItem.leadingAnchor.constraint(equalTo: leadingAnchor),
                thirdItem.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
            
            thirdItem.seperator.isHidden = true
            
        case .four:
            [firstItem, secondItem, thirdItem, fourthItem].forEach { addSubview($0) }
            NSLayoutConstraint.activate([
                firstItem.topAnchor.constraint(equalTo: topAnchor),
                firstItem.leadingAnchor.constraint(equalTo: leadingAnchor),
                firstItem.trailingAnchor.constraint(equalTo: trailingAnchor),
                
                secondItem.topAnchor.constraint(equalTo: firstItem.bottomAnchor),
                secondItem.leadingAnchor.constraint(equalTo: leadingAnchor),
                secondItem.trailingAnchor.constraint(equalTo: trailingAnchor),
                
                thirdItem.topAnchor.constraint(equalTo: secondItem.bottomAnchor),
                thirdItem.leadingAnchor.constraint(equalTo: leadingAnchor),
                thirdItem.trailingAnchor.constraint(equalTo: trailingAnchor),
                
                fourthItem.topAnchor.constraint(equalTo: thirdItem.bottomAnchor),
                fourthItem.bottomAnchor.constraint(equalTo: bottomAnchor),
                fourthItem.leadingAnchor.constraint(equalTo: leadingAnchor),
                fourthItem.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
            
            fourthItem.seperator.isHidden = true
            
        case .five:
            [firstItem, secondItem, thirdItem, fourthItem, fifthItem].forEach { addSubview($0) }
            
            NSLayoutConstraint.activate([
                firstItem.topAnchor.constraint(equalTo: topAnchor),
                firstItem.leadingAnchor.constraint(equalTo: leadingAnchor),
                firstItem.trailingAnchor.constraint(equalTo: trailingAnchor),
                
                secondItem.topAnchor.constraint(equalTo: firstItem.bottomAnchor),
                secondItem.leadingAnchor.constraint(equalTo: leadingAnchor),
                secondItem.trailingAnchor.constraint(equalTo: trailingAnchor),
                
                thirdItem.topAnchor.constraint(equalTo: secondItem.bottomAnchor),
                thirdItem.leadingAnchor.constraint(equalTo: leadingAnchor),
                thirdItem.trailingAnchor.constraint(equalTo: trailingAnchor),
                
                fourthItem.topAnchor.constraint(equalTo: thirdItem.bottomAnchor),
                fourthItem.leadingAnchor.constraint(equalTo: leadingAnchor),
                fourthItem.trailingAnchor.constraint(equalTo: trailingAnchor),
                
                fifthItem.topAnchor.constraint(equalTo: fourthItem.bottomAnchor),
                fifthItem.bottomAnchor.constraint(equalTo: bottomAnchor),
                fifthItem.leadingAnchor.constraint(equalTo: leadingAnchor),
                fifthItem.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
            
            fifthItem.seperator.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
