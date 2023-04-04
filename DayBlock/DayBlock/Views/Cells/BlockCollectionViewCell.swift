//
//  BlockCollectionViewCell.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/03.
//

import UIKit

final class BlockCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Component
    
    private let plusLabel: UILabel = {
        let label = UILabel()
        label.text = "+"
        label.font = UIFont(name: Poppins.bold, size: 18)
        label.textColor = UIColor(rgb: 0x0076FF) // ⛳️
        label.textAlignment = .left
        return label
    }()
    
    private let totalProductivityLabel: UILabel = {
        let label = UILabel()
        label.text = "72.5" // ⛳️
        label.font = UIFont(name: Poppins.bold, size: 18)
        label.textColor = GrayScale.mainText
        label.textAlignment = .left
        return label
    }()
    
    private let blockColorTag: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0x0076FF) // ⛳️
        view.clipsToBounds = true
        view.layer.cornerRadius = 9
        
        /// 하단 왼쪽, 하단 오른쪽만 cornerRadius 값 주기
        view.layer.maskedCorners = CACornerMask(
            arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        return view
    }()
    
    private let blockIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "book.closed.fill")
        image.contentMode = .scaleAspectFit
        image.tintColor = GrayScale.mainText
        return image
    }()
    
    private let blockLabel: UILabel = {
        let label = UILabel()
        label.text = "SwiftUI 강의" // ⛳️
        label.font = UIFont(name: Pretendard.bold, size: 17)
        label.textColor = GrayScale.mainText
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - Method
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAutoLayout()
        
        /// CornerRadius
        clipsToBounds = true
        layer.cornerRadius = frame.height / 7
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAutoLayout() {
        
        /// addSubView & translatesAutoresizingMaskIntoConstraints
        [
            plusLabel, totalProductivityLabel, blockColorTag,
            blockIcon, blockLabel,
        ]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        /// Constraint
        NSLayoutConstraint.activate([
            
            /// plusLabel
            plusLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            plusLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            /// totalProductivityLabel
            totalProductivityLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            totalProductivityLabel.leadingAnchor.constraint(equalTo: plusLabel.trailingAnchor),
            
            /// blockColorTag
            blockColorTag.topAnchor.constraint(equalTo: topAnchor),
            blockColorTag.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            blockColorTag.widthAnchor.constraint(equalToConstant: 20),
            blockColorTag.heightAnchor.constraint(equalToConstant: 30),
            
            /// blockIcon
            blockIcon.topAnchor.constraint(equalTo: topAnchor, constant: 54),
            blockIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            blockIcon.widthAnchor.constraint(equalToConstant: 56),
            blockIcon.heightAnchor.constraint(equalToConstant: 56),
            
            /// blockLabel
            blockLabel.topAnchor.constraint(equalTo: blockIcon.bottomAnchor, constant: 12),
            blockLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            blockLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
    
}
