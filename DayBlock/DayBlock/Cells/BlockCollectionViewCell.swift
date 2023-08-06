//
//  BlockCollectionViewCell.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/03.
//

import UIKit

final class BlockCollectionViewCell: UICollectionViewCell {
    
    enum Direction {
        case front
        case back
        case last
    }
    
    // MARK: - Front Component
    
    let plusLabel: UILabel = {
        let label = UILabel()
        label.text = "+"
        label.font = UIFont(name: Poppins.bold, size: 18)
        label.textColor = UIColor(rgb: 0x0076FF) // ⛳️
        label.textAlignment = .left
        return label
    }()
    
    let totalProductivityLabel: UILabel = {
        let label = UILabel()
        label.text = "72.5" // ⛳️
        label.font = UIFont(name: Poppins.bold, size: 18)
        label.textColor = GrayScale.mainText
        label.textAlignment = .left
        return label
    }()
    
    let blockColorTag: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0x0076FF) // ⛳️
        view.clipsToBounds = true
        view.layer.cornerRadius = 9
        
        /// 하단 왼쪽, 하단 오른쪽만 cornerRadius 값 주기
        view.layer.maskedCorners = CACornerMask(
            arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        return view
    }()
    
    let blockIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "book.closed.fill") // ⛳️
        image.contentMode = .scaleAspectFit
        image.tintColor = GrayScale.mainText
        return image
    }()
    
    let blockLabel: UILabel = {
        let label = UILabel()
        label.text = "SwiftUI 강의" // ⛳️
        label.font = UIFont(name: Pretendard.bold, size: 17)
        label.textColor = GrayScale.mainText
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - Back Component
    
    let backTotalValue: UILabel = {
        let label = UILabel()
        label.text = "0.0" // ⛳️
        label.font = UIFont(name: Poppins.bold, size: 20)
        label.textColor = GrayScale.mainText
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    let backTotalLabel: UILabel = {
        let label = UILabel()
        label.text = "total"
        label.font = UIFont(name: Poppins.bold, size: 14)
        label.textColor = GrayScale.subText2
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    let seperator: UIView = {
        let line = UIView()
        line.backgroundColor = GrayScale.seperator2
        line.isHidden = true
        return line
    }()
    
    let backTodayValue: UILabel = {
        let label = UILabel()
        label.text = "0.0" // ⛳️
        label.font = UIFont(name: Poppins.bold, size: 20)
        label.textColor = GrayScale.mainText
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    let backTodayLabel: UILabel = {
        let label = UILabel()
        label.text = "today"
        label.font = UIFont(name: Poppins.bold, size: 14)
        label.textColor = GrayScale.subText2
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    let backTrashIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "trash.circle.fill") // ⛳️
        image.contentMode = .scaleAspectFit
        image.tintColor = .systemRed
        image.isHidden = true
        return image
    }()
    
    let backEditIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "square.and.pencil.circle.fill") // ⛳️
        image.contentMode = .scaleAspectFit
        image.tintColor = GrayScale.mainText
        image.isHidden = true
        return image
    }()
    
    
    // MARK: - Last Component
    
    lazy var stroke: CAShapeLayer = {
        let stroke = CAShapeLayer()
        stroke.strokeColor = GrayScale.entireBlock.cgColor
        stroke.lineWidth = 6
        stroke.lineDashPattern = [6, 6]
        stroke.frame = self.bounds
        stroke.fillColor = nil
        stroke.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.height / 7).cgPath
        return stroke
    }()

    
    // MARK: - Method
    
    /// 블럭의 앞면, 뒷면, 마지막 UI 전환 메서드
    func reverseDirection(_ direction: Direction) {
        
        // 앞면
        if direction == .front {
            plusLabel.isHidden = false
            totalProductivityLabel.isHidden = false
            blockColorTag.isHidden = false
            blockIcon.isHidden = false
            blockLabel.isHidden = false
            
            backTotalValue.isHidden = true
            backTotalLabel.isHidden = true
            seperator.isHidden = true
            backTodayValue.isHidden = true
            backTodayLabel.isHidden = true
            backTrashIcon.isHidden = true
            backEditIcon.isHidden = true
            return
        }
        
        // 뒷면
        if direction == .back {
            plusLabel.isHidden = true
            totalProductivityLabel.isHidden = true
            blockColorTag.isHidden = true
            blockIcon.isHidden = true
            blockLabel.isHidden = true
            
            backTotalValue.isHidden = false
            backTotalLabel.isHidden = false
            seperator.isHidden = false
            backTodayValue.isHidden = false
            backTodayLabel.isHidden = false
            backTrashIcon.isHidden = false
            backEditIcon.isHidden = false
            return
        }
        
        // 마지막
        if direction == .last {
            backTotalValue.isHidden = true
            backTotalLabel.isHidden = true
            seperator.isHidden = true
            backTodayValue.isHidden = true
            backTodayLabel.isHidden = true
            blockIcon.isHidden = false
            backTrashIcon.isHidden = true
            backEditIcon.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        /// 블럭 재사용 문제 해결
        plusLabel.isHidden = false
        totalProductivityLabel.isHidden = false
        blockColorTag.isHidden = false
        blockIcon.tintColor = GrayScale.mainText
        blockLabel.isHidden = false
        stroke.isHidden = true
        self.backgroundColor = GrayScale.contentsBlock
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAutoLayout()
        setupUI()
        setupClosure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        /// Custom
        backgroundColor = GrayScale.contentsBlock
        self.layer.addSublayer(stroke)
        
        /// CornerRadius
        clipsToBounds = true
        layer.cornerRadius = frame.height / 7
    }
    
    func setupClosure() {
        
    }
    
    func setupAutoLayout() {
        
        // addSubView & translatesAutoresizingMaskIntoConstraints
        [
            plusLabel, totalProductivityLabel, blockColorTag,
            blockIcon, blockLabel,
            backTotalValue, backTotalLabel,
            seperator,
            backTodayValue, backTodayLabel,
            backTrashIcon, backEditIcon,
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
            
            // backTotalValue
            backTotalValue.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            backTotalValue.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            
            // backTotalLabel
            backTotalLabel.topAnchor.constraint(equalTo: backTotalValue.bottomAnchor, constant: 0),
            backTotalLabel.centerXAnchor.constraint(equalTo: backTotalValue.centerXAnchor),
            
            // seperator
            seperator.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            seperator.centerXAnchor.constraint(equalTo: centerXAnchor),
            seperator.widthAnchor.constraint(equalToConstant: 2),
            seperator.heightAnchor.constraint(equalToConstant: 20),
            
            // backTotalValue
            backTodayValue.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            backTodayValue.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            // backTodayLabel
            backTodayLabel.topAnchor.constraint(equalTo: backTodayValue.bottomAnchor, constant: 0),
            backTodayLabel.centerXAnchor.constraint(equalTo: backTodayValue.centerXAnchor),
            
            // backTrashIcon
            backTrashIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            backTrashIcon.centerXAnchor.constraint(equalTo: backTotalLabel.centerXAnchor),
            backTrashIcon.widthAnchor.constraint(equalToConstant: 56),
            backTrashIcon.heightAnchor.constraint(equalToConstant: 56),
            
            // backEditIcon
            backEditIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            backEditIcon.centerXAnchor.constraint(equalTo: backTodayLabel.centerXAnchor),
            backEditIcon.widthAnchor.constraint(equalToConstant: 56),
            backEditIcon.heightAnchor.constraint(equalToConstant: 56),
        ])
    }
}
