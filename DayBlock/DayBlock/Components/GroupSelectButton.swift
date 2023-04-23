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
        view.layer.cornerRadius = 7
        return view
    }()
    
    lazy var groupStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [groupLabel, groupPolygon])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 0
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    let groupLabel: UILabel = {
        let label = UILabel()
        label.text = "그룹 없음"
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
        addSubview(color)
        addSubview(groupStackView)
        [groupStackView, color, groupLabel, groupPolygon]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        NSLayoutConstraint.activate([
            
            /// GroupSelectButton(self)
            self.widthAnchor.constraint(equalTo: groupStackView.widthAnchor),
            self.heightAnchor.constraint(equalToConstant: 40),
            
            /// color
            color.centerYAnchor.constraint(equalTo: centerYAnchor),
            color.leadingAnchor.constraint(equalTo: leadingAnchor),
            color.widthAnchor.constraint(equalToConstant: 20),
            color.heightAnchor.constraint(equalTo: color.widthAnchor),
            
            /// groupStackView
            groupStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            groupStackView.leadingAnchor.constraint(equalTo: color.trailingAnchor, constant: 6),
            groupStackView.heightAnchor.constraint(equalToConstant: 40),
            
            /// groupPolygon
            groupPolygon.widthAnchor.constraint(equalToConstant: 22),
            groupPolygon.heightAnchor.constraint(equalTo: groupPolygon.widthAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
