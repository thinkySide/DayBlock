//
//  HomeView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/03/31.
//

import UIKit

final class HomeView: UIView {
    
    // MARK: - Component
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "3월 8일 수요일"
        label.font = UIFont(name: Pretendard.semiBold, size: 16)
        label.textColor = GrayScale.subText
        label.textAlignment = .left
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "22:37"
        label.font = UIFont(name: Poppins.bold, size: 56)
        label.textColor = GrayScale.mainText
        label.textAlignment = .left
        return label
    }()
    
    private let productivityLabel: UILabel = {
        let label = UILabel()
        label.text = "TODAY +5.5"
        label.font = UIFont(name: Poppins.bold, size: 23)
        label.textColor = GrayScale.mainText
        label.textAlignment = .left
        return label
    }()
    
    private let blockPreview = BlockPreview()
    
    lazy var blockCollectionView: UICollectionView = {
        
        /// layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = Size.blockSize
        layout.minimumLineSpacing = Size.blockSpacing
        layout.minimumInteritemSpacing = 0
        
        /// collectionView
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.clipsToBounds = true
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.decelerationRate = .fast
        return collectionView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘 하루는 어떤 블럭으로\n채우고 계신가요?"
        label.font = UIFont(name: Pretendard.semiBold, size: 18)
        label.textColor = GrayScale.mainText
        label.alpha = 0.4
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var trackingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Icon.trackingStartButton), for: .normal)
        button.addTarget(self, action: #selector(trackingButtonTapped), for: .touchUpInside)
        return button
    }()

    private let tabBarStackView = TabBarActiveStackView()
    
    
    
    // MARK: - Method
    
    @objc func trackingButtonTapped() {
        print(#function)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitial()
        setupAddSubView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInitial() {
        backgroundColor = .white
        tabBarStackView.switchTabBarActive(.home)
    }
    
    func setupAddSubView() {
        
        [
            dateLabel, timeLabel, productivityLabel,
            blockPreview,
            blockCollectionView,
            messageLabel,
            trackingButton,
            tabBarStackView,
        ]
            .forEach {
                
                /// 1. addSubView(component)
                addSubview($0)
                
                /// 2. translatesAutoresizingMaskIntoConstraints = false
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
    }
    
    func setupConstraints() {
        
        /// 3. isActive = true
        NSLayoutConstraint.activate([
            
            /// dateLabel
            dateLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            
            /// timeLabel
            timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            timeLabel.heightAnchor.constraint(equalToConstant: timeLabel.font.pointSize),
            
            /// productivityLabel
            productivityLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 3),
            productivityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            
            /// blockPreview
            blockPreview.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            blockPreview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.margin),
            blockPreview.widthAnchor.constraint(equalToConstant: 128),
            blockPreview.heightAnchor.constraint(equalToConstant: 84),
            
            /// blockCollectionView
            blockCollectionView.topAnchor.constraint(equalTo: productivityLabel.bottomAnchor, constant: 32),
            blockCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blockCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blockCollectionView.heightAnchor.constraint(equalToConstant: Size.blockSize.height),
            
            /// messageLabel
            messageLabel.topAnchor.constraint(equalTo: blockCollectionView.bottomAnchor, constant: 64),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            /// trackingButton
            trackingButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -48),
            trackingButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            trackingButton.widthAnchor.constraint(equalToConstant: 72),
            trackingButton.heightAnchor.constraint(equalToConstant: 72),
            
            /// tabBarStackView
            tabBarStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tabBarStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabBarStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabBarStackView.heightAnchor.constraint(equalToConstant: 2),
        ])
    }
}
