//
//  OptionSelector.swift
//  DayBlock
//
//  Created by 김민준 on 1/4/24.
//

import UIKit

final class OptionSelector: UIButton {
    
    // MARK: - Properties
    let title: UILabel = {
        let label = UILabel()
        label.text = "전체"
        label.font = UIFont(name: Pretendard.semiBold, size: 14)
        label.textColor = Color.mainText
        label.textAlignment = .right
        return label
    }()
    
    private let arrow: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: Icon.menuIcon)
        return image
    }()
    
    // MARK: - Initial
    init() {
        super.init(frame: .zero)
        [title, arrow].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        self.backgroundColor = Color.contentsBlock
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 32),
            
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            arrow.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 1),
            arrow.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 2),
            arrow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            arrow.widthAnchor.constraint(equalToConstant: 20),
            arrow.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
