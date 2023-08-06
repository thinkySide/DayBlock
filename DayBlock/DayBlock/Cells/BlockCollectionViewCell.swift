//
//  BlockCollectionViewCell.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/03.
//

import UIKit

final class BlockCollectionViewCell: UICollectionViewCell {
    
    /// 블럭 방향 열거형
    enum Direction {
        case front
        case back
        case last
    }
    
    typealias Closure = (BlockCollectionViewCell) -> Void
    var trashButtonTapped: Closure = { sender in }
    var editButtonTapped: Closure = { sender in }
    
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
        label.alpha = 0
        return label
    }()
    
    let backTotalLabel: UILabel = {
        let label = UILabel()
        label.text = "total"
        label.font = UIFont(name: Poppins.bold, size: 14)
        label.textColor = GrayScale.subText2
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    let seperator: UIView = {
        let line = UIView()
        line.backgroundColor = GrayScale.seperator2
        line.alpha = 0
        return line
    }()
    
    let backTodayValue: UILabel = {
        let label = UILabel()
        label.text = "0.0" // ⛳️
        label.font = UIFont(name: Poppins.bold, size: 20)
        label.textColor = GrayScale.mainText
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    let backTodayLabel: UILabel = {
        let label = UILabel()
        label.text = "today"
        label.font = UIFont(name: Poppins.bold, size: 14)
        label.textColor = GrayScale.subText2
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    lazy var backTrashIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "trash.circle.fill") // ⛳️
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor(rgb: 0x525252)
        image.alpha = 0
        
        // Gesture
        let gesture = UITapGestureRecognizer(target: self, action: #selector(backTrashIconTapped))
        image.addGestureRecognizer(gesture)
        image.isUserInteractionEnabled = true
        return image
    }()
    
    lazy var backEditIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "pencil.circle.fill") // ⛳️
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor(rgb: 0x525252)
        image.alpha = 0
        
        // Gesture
        let gesture = UITapGestureRecognizer(target: self, action: #selector(backEditIconTapped))
        image.addGestureRecognizer(gesture)
        image.isUserInteractionEnabled = true
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
    
    @objc func backTrashIconTapped() {
        trashButtonTapped(self)
    }
    
    @objc func backEditIconTapped() {
        editButtonTapped(self)
    }
    
    func reverseDirectionWithNoAnimation() {
        backTotalValue.alpha = 0
        backTotalLabel.alpha = 0
        seperator.alpha = 0
        backTodayValue.alpha = 0
        backTodayLabel.alpha = 0
        backTrashIcon.alpha = 0
        backEditIcon.alpha = 0
        plusLabel.alpha = 1
        totalProductivityLabel.alpha = 1
        blockColorTag.alpha = 1
        blockIcon.alpha = 1
        blockLabel.alpha = 1
    }
    
    /// 블럭의 앞면, 뒷면, 마지막 UI 전환 메서드
    func reverseDirection(_ direction: Direction) {
        
        // 앞면
        if direction == .front {
            
            self.backTotalValue.alpha = 0
            self.backTotalLabel.alpha = 0
            self.seperator.alpha = 0
            self.backTodayValue.alpha = 0
            self.backTodayLabel.alpha = 0
            self.backTrashIcon.alpha = 0
            self.backEditIcon.alpha = 0
            
            UIView.animate(withDuration: 0.3) {
                self.plusLabel.alpha = 1
                self.totalProductivityLabel.alpha = 1
                self.blockColorTag.alpha = 1
                self.blockIcon.alpha = 1
                self.blockLabel.alpha = 1
                return
            }
        }
        
        // 뒷면
        if direction == .back {
            self.plusLabel.alpha = 0
            self.totalProductivityLabel.alpha = 0
            self.blockColorTag.alpha = 0
            self.blockIcon.alpha = 0
            self.blockLabel.alpha = 0
            
            UIView.animate(withDuration: 0.3) {
                self.backTotalValue.alpha = 1
                self.backTotalLabel.alpha = 1
                self.seperator.alpha = 1
                self.backTodayValue.alpha = 1
                self.backTodayLabel.alpha = 1
                self.backTrashIcon.alpha = 1
                self.backEditIcon.alpha = 1
                return
            }
        }
        
        // 마지막
        if direction == .last {
            self.backTotalValue.alpha = 0
            self.backTotalLabel.alpha = 0
            self.seperator.alpha = 0
            self.backTodayValue.alpha = 0
            self.backTodayLabel.alpha = 0
            self.backTrashIcon.alpha = 0
            self.backEditIcon.alpha = 0
            
            UIView.animate(withDuration: 0.3) {
                self.blockIcon.alpha = 1
                return
            }
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
