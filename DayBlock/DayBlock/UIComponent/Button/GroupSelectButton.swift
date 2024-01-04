//
//  GroupSelectButton.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/06.
//

import UIKit

final class GroupSelectButton: UIView {
    
    let color: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "그룹 없음"
        label.font = UIFont(name: Pretendard.bold, size: 17)
        label.textColor = Color.mainText
        label.textAlignment = .center
        return label
    }()
    
    private let arrow: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: Icon.menuIcon)
        return image
    }()

    // MARK: - Method
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /// addSubView & resizingMask
        [color, label, arrow]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        NSLayoutConstraint.activate([
            
            /// GroupSelectButton(self)
            self.leadingAnchor.constraint(equalTo: color.leadingAnchor, constant: -12),
            self.trailingAnchor.constraint(equalTo: arrow.trailingAnchor, constant: 12),
            self.heightAnchor.constraint(equalToConstant: 40),
            
            /// color
            color.centerYAnchor.constraint(equalTo: centerYAnchor),
            color.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -6),
            color.widthAnchor.constraint(equalToConstant: 16),
            color.heightAnchor.constraint(equalTo: color.widthAnchor),
            
            /// label
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            /// arrow
            arrow.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrow.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 0),
            arrow.widthAnchor.constraint(equalToConstant: 22),
            arrow.heightAnchor.constraint(equalTo: arrow.widthAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
