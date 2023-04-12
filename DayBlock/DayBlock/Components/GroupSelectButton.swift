//
//  GroupSelectButton.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/06.
//

import UIKit

final class GroupSelectButton: UIButton {
    
    lazy var groupStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [groupLabel, groupPolygon])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 0
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0) /// 시각보정
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    let groupLabel: UILabel = {
        let label = UILabel()
        label.text = "자기계발"
        label.font = UIFont(name: Pretendard.bold, size: 18)
        label.textColor = GrayScale.mainText
        label.textAlignment = .center
        return label
    }()
    
    private let groupPolygon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: Icon.menuIcon)
        return image
    }()
    
    
    
    // MARK: - Method
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /// addSubView & resizingMask
        addSubview(groupStackView)
        [groupStackView, groupLabel, groupPolygon]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        NSLayoutConstraint.activate([
            
            /// GroupSelectButton(self)
            self.widthAnchor.constraint(equalTo: groupStackView.widthAnchor),
            self.heightAnchor.constraint(equalToConstant: 40),
            
            /// groupStackView
            groupStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            groupStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            groupStackView.heightAnchor.constraint(equalToConstant: 40),
            
            /// groupPolygon
            groupPolygon.widthAnchor.constraint(equalToConstant: 22),
            groupPolygon.heightAnchor.constraint(equalToConstant: 22),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
