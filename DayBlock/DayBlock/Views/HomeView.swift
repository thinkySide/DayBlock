//
//  HomeView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/03/31.
//

import UIKit

final class HomeView: UIView {
    
    // MARK: - TrackingMode
    
    enum TrakingMode {
        case active
        case inactive
    }
    
    var trackingMode: TrakingMode = .inactive
    
    // MARK: - Component
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.semiBold, size: 16)
        label.textColor = GrayScale.subText
        label.textAlignment = .left
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Poppins.bold, size: 56)
        label.textColor = GrayScale.mainText
        label.textAlignment = .left
        return label
    }()
    
    private let productivityLabel: UILabel = {
        let label = UILabel()
        label.text = "TODAY +5.5" // ⛳️
        label.font = UIFont(name: Poppins.bold, size: 23)
        label.textColor = GrayScale.mainText
        label.textAlignment = .left
        return label
    }()
    
    let blockPreview: BlockPreview = {
        let preview = BlockPreview()
        return preview
    }()
    
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
    
    private let trackingBlock: ContentsBlock = {
        let block = ContentsBlock(frame: .zero, blockSize: .middle)
        block.isHidden = true
        return block
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘 하루는 어떤 블럭으로\n채우고 계신가요?" // ⛳️
        label.font = UIFont(name: Pretendard.semiBold, size: 18)
        label.textColor = GrayScale.mainText
        label.alpha = 0.4
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let trackingTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.font = UIFont(name: Poppins.bold, size: 36)
        label.textColor = GrayScale.mainText
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let trackingProgressView: UIProgressView = {
        let progress = UIProgressView()
        progress.trackTintColor = GrayScale.contentsBlock
        progress.progressTintColor = .systemBlue
        progress.progress = 0.7
        progress.isHidden = true
        return progress
    }()
    
    private lazy var trackingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Icon.trackingStart), for: .normal)
        button.addTarget(self, action: #selector(trackingButtonTapped), for: .touchUpInside)
        return button
    }()

    private let tabBarStackView = TabBarActiveStackView()
    
    
    
    // MARK: - Method
    
    @objc func trackingButtonTapped() {
        
        /// Tracking 모드 변경
        trackingMode = trackingMode == .inactive ? .active : .inactive
        
        /// Tracking 모드 설정
        switch trackingMode {
        case .active:
            print("Tracking 시작")
            
            /// Tracking 버튼 설정
            trackingButton.setImage(
                UIImage(named: Icon.trackingStop),
                for: .normal)
            
            /// blockCollectionView 설정
            blockCollectionView.isHidden = true
            
            /// trackingBlock 설정
            trackingBlock.isHidden = false
            
            /// messageLabel 설정
            messageLabel.isHidden = true
            
            /// trackingTimeLabel 설정
            trackingTimeLabel.isHidden = false
            
            /// trackingProgressView 설정
            trackingProgressView.isHidden = false
            
            
            
        case .inactive:
            print("Tracking 종료")
            
            /// Tracking 버튼 설정
            trackingButton.setImage(
                UIImage(named: Icon.trackingStart),
                for: .normal)
            
            /// blockCollectionView 설정
            blockCollectionView.isHidden = false
            
            /// trackingBlock 설정
            trackingBlock.isHidden = true
            
            /// messageLabel 설정
            messageLabel.isHidden = false
            
            /// trackingTimeLabel 설정
            trackingTimeLabel.isHidden = true
            
            /// trackingProgressView 설정
            trackingProgressView.isHidden = true
        }
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
            trackingBlock,
            messageLabel,
            trackingTimeLabel,
            trackingProgressView,
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
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin+2), /// 시각 보정
            
            /// timeLabel
            timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            timeLabel.heightAnchor.constraint(equalToConstant: timeLabel.font.pointSize),
            
            /// productivityLabel
            productivityLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 3),
            productivityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin+2), /// 시각 보정
            
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
            
            /// trackingBlock
            trackingBlock.topAnchor.constraint(equalTo: productivityLabel.bottomAnchor, constant: 32),
            trackingBlock.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            /// messageLabel
            messageLabel.topAnchor.constraint(equalTo: blockCollectionView.bottomAnchor, constant: 64),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            /// trackingTimeLabel
            trackingTimeLabel.bottomAnchor.constraint(equalTo: trackingButton.topAnchor, constant: -24),
            trackingTimeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            /// trackingProgressView
            trackingProgressView.centerYAnchor.constraint(equalTo: trackingButton.centerYAnchor),
            trackingProgressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -1),
            trackingProgressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 1),
            trackingProgressView.heightAnchor.constraint(equalToConstant: 10),
            
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
