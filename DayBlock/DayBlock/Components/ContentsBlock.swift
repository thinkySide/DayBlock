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
        [plus, totalProductivityLabel, colorTag, icon, taskLabel]
            .forEach { view.addSubview($0) }
        return view
    }()
    
    let plus: UILabel = {
        let label = UILabel()
        label.text = "+"
        label.font = UIFont(name: Poppins.bold, size: 18)
        label.textColor = .systemBlue // ⛳️
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
    
    private let colorTag: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue // ⛳️
        view.clipsToBounds = true
        view.layer.cornerRadius = 9
        
        /// 하단 왼쪽, 하단 오른쪽만 cornerRadius 값 주기
        view.layer.maskedCorners = CACornerMask(
            arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        return view
    }()
    
    private let icon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "batteryblock.fill") // ⛳️
        image.contentMode = .scaleAspectFit
        image.tintColor = GrayScale.mainText
        return image
    }()
    
    private let taskLabel: UILabel = {
        let label = UILabel()
        label.text = "블럭 쌓기" // ⛳️
        label.font = UIFont(name: Pretendard.bold, size: 17)
        label.textColor = GrayScale.mainText
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    
    
    // MARK: - Variable
    private let middleSize = CGSize(width: 180, height: 180)
    private let largeSize = CGSize(width: 240, height: 240)
    
    
    
    // MARK: - Method
    
    init(frame: CGRect, blockSize: BlockSize) {
        self.blockSize = blockSize
        super.init(frame: frame)
        setupInitial()
        setupAddSubView()
        setupConstraints()
        print(self.blockSize)
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

    func setupInitial() {
        /// BlockSize
        switch blockSize {
        case .middle:
            self.widthAnchor.constraint(equalToConstant: middleSize.width).isActive = true
            self.heightAnchor.constraint(equalToConstant: middleSize.height).isActive = true
        case .large:
            self.widthAnchor.constraint(equalToConstant: largeSize.width).isActive = true
            self.heightAnchor.constraint(equalToConstant: largeSize.height).isActive = true
        }
    }
    
    func setupAddSubView() {
        /// 1. addSubView(component)
        [contentsView]
            .forEach { addSubview($0) }
        
        /// 2. translatesAutoresizingMaskIntoConstraints = false
        [contentsView, plus, totalProductivityLabel,
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
            
            /// plus
            plus.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 16),
            plus.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 16),
            
            /// totalProductivityLabel
            totalProductivityLabel.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 16),
            totalProductivityLabel.leadingAnchor.constraint(equalTo: plus.trailingAnchor),
            
            /// colorTag
            colorTag.topAnchor.constraint(equalTo: contentsView.topAnchor),
            colorTag.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -32),
            colorTag.widthAnchor.constraint(equalToConstant: 20),
            colorTag.heightAnchor.constraint(equalToConstant: 30),
            
            /// icon
            icon.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 54),
            icon.centerXAnchor.constraint(equalTo: contentsView.centerXAnchor),
            icon.widthAnchor.constraint(equalToConstant: 56),
            icon.heightAnchor.constraint(equalToConstant: 56),
            
            /// taskLabel
            taskLabel.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 12),
            taskLabel.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 20),
            taskLabel.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -20),
        ])
    }
}


