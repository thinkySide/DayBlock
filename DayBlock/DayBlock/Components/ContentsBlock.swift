//
//  ContentsBlock.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/08.
//

import UIKit

final class ContentsBlock: UIView {
    
    // MARK: - Size
    
    enum BlockSize {
        case middle
        case large
    }
    
    var blockSize: BlockSize
    
    
    
    // MARK: - Component

    private lazy var contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = GrayScale.contentsBlock
        view.clipsToBounds = true
        [plus, currentProductivityLabel, colorTag, icon, taskLabel]
            .forEach { view.addSubview($0) }
        return view
    }()
    
    let plus: UILabel = {
        let label = UILabel()
        label.text = "+"
        label.textColor = .systemBlue
        label.textAlignment = .left
        return label
    }()
    
    var currentProductivityLabel: UILabel = {
        let label = UILabel()
        label.text = "0.0"
        label.textColor = GrayScale.mainText
        label.textAlignment = .left
        return label
    }()
    
    private let colorTag: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.clipsToBounds = true
        
        /// 하단 왼쪽, 하단 오른쪽만 cornerRadius 값 주기
        view.layer.maskedCorners = CACornerMask(
            arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        return view
    }()
    
    private let icon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "batteryblock.fill")
        image.contentMode = .scaleAspectFit
        image.tintColor = GrayScale.mainText
        return image
    }()
    
    private let taskLabel: UILabel = {
        let label = UILabel()
        label.text = "Github 브랜치 관리하기"
        label.textColor = GrayScale.mainText
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    
    
    // MARK: - Variable
    private let middleSize = CGSize(width: 180, height: 180)
    private let largeSize = CGSize(width: 250, height: 250)
    
    
    
    // MARK: - Method
    
    func setupBlockContents(group: Group, block: Block) {
        plus.textColor = UIColor(rgb: group.color)
        colorTag.backgroundColor = UIColor(rgb: group.color)
        icon.image = UIImage(systemName: block.icon)!
        taskLabel.text = block.taskLabel
    }
    
    init(frame: CGRect, blockSize: BlockSize) {
        self.blockSize = blockSize
        super.init(frame: frame)
        setupBlockSize()
        setupAddSubView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        /// CornerRaius
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height / 7
    }

    func setupBlockSize() {
        /// BlockSize
        switch blockSize {
        case .middle:
            self.widthAnchor.constraint(equalToConstant: middleSize.width).isActive = true
            self.heightAnchor.constraint(equalToConstant: middleSize.height).isActive = true
            
            /// 디자인 설정
            plus.font = UIFont(name: Poppins.bold, size: 18)
            plus.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 16).isActive = true
            plus.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 16).isActive = true
            
            currentProductivityLabel.font = UIFont(name: Poppins.bold, size: 18)
            currentProductivityLabel.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 16).isActive = true
            
            colorTag.layer.cornerRadius = 9
            colorTag.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -32).isActive = true
            colorTag.widthAnchor.constraint(equalToConstant: 20).isActive = true
            colorTag.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            icon.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 48).isActive = true
            icon.widthAnchor.constraint(equalToConstant: 56).isActive = true
            icon.heightAnchor.constraint(equalToConstant: 56).isActive = true
            
            taskLabel.font = UIFont(name: Pretendard.bold, size: 17)
            
        case .large:
            self.widthAnchor.constraint(equalToConstant: largeSize.width).isActive = true
            self.heightAnchor.constraint(equalToConstant: largeSize.height).isActive = true
            
            /// 디자인 설정
            plus.font = UIFont(name: Poppins.bold, size: 24)
            plus.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 24).isActive = true
            plus.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 24).isActive = true
            
            currentProductivityLabel.font = UIFont(name: Poppins.bold, size: 24)
            currentProductivityLabel.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 24).isActive = true
            
            colorTag.layer.cornerRadius = 11
            colorTag.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -48).isActive = true
            colorTag.widthAnchor.constraint(equalToConstant: 26).isActive = true
            colorTag.heightAnchor.constraint(equalToConstant: 38).isActive = true
            
            icon.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 68).isActive = true
            icon.widthAnchor.constraint(equalToConstant: 88).isActive = true
            icon.heightAnchor.constraint(equalToConstant: 88).isActive = true
            
            taskLabel.font = UIFont(name: Pretendard.bold, size: 24)
        }
    }
    
    func setupAddSubView() {
        /// 1. addSubView(component)
        [contentsView]
            .forEach { addSubview($0) }
        
        /// 2. translatesAutoresizingMaskIntoConstraints = false
        [contentsView, plus, currentProductivityLabel,
         colorTag, icon, taskLabel]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }

    func setupConstraints() {
        /// 3. NSLayoutConstraint.activate
        NSLayoutConstraint.activate([
            
            /// contentsView
            contentsView.topAnchor.constraint(equalTo: topAnchor),
            contentsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            /// totalProductivityLabel
            currentProductivityLabel.leadingAnchor.constraint(equalTo: plus.trailingAnchor),
            
            /// colorTag
            colorTag.topAnchor.constraint(equalTo: contentsView.topAnchor),
            
            /// icon
            icon.centerXAnchor.constraint(equalTo: contentsView.centerXAnchor),
            
            /// taskLabel
            taskLabel.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 12),
            taskLabel.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 24),
            taskLabel.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -24),
        ])
    }
}


