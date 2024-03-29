//
//  MenuItem.swift
//  DayBlock
//
//  Created by 김민준 on 1/3/24.
//

import UIKit

final class MenuItem: UIView {
    
    // MARK: - Property
    
    let title: UILabel = {
        let label = UILabel()
        label.text = "액션"
        label.font = UIFont(name: Pretendard.semiBold, size: 15)
        label.textColor = Color.mainText
        label.textAlignment = .left
        return label
    }()
    
    let icon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.tintColor = Color.subText
        image.image = UIImage(systemName: "bag.fill")
        return image
    }()
    
    let seperator = Separator()
    
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [title, icon, seperator].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            // self
            self.bottomAnchor.constraint(equalTo: seperator.bottomAnchor),
            self.trailingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 16),
            
            // title
            title.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            title.widthAnchor.constraint(equalToConstant: 72),
            
            // icon
            icon.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            icon.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 32),
            icon.widthAnchor.constraint(equalToConstant: 20),
            icon.heightAnchor.constraint(equalToConstant: 20),
            
            // seperator
            seperator.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 12),
            seperator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            seperator.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
