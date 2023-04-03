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
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: blockSize, height: blockSize)
        layout.minimumLineSpacing = 32
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.clipsToBounds = true
        collectionView.backgroundColor = .gray
        return collectionView
    }()
    
    
    // MARK: - Initial
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitial()
        setupAddSubView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Variable
    private let blockSize: CGFloat = 160
    
    
    // MARK: - Method
    
    func setupInitial() {
        backgroundColor = .white
    }
    
    func setupAddSubView() {
        
        [
            dateLabel, timeLabel, productivityLabel,
            blockPreview,
            blockCollectionView,
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
            
            // dateLabel
            dateLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margin.defaults),
            
            // timeLabel
            timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margin.defaults),
            timeLabel.heightAnchor.constraint(equalToConstant: timeLabel.font.pointSize),
            
            // productivityLabel
            productivityLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 3),
            productivityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margin.defaults),
            
            // blockPreview
            blockPreview.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            blockPreview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Margin.defaults),
            blockPreview.widthAnchor.constraint(equalToConstant: 128),
            blockPreview.heightAnchor.constraint(equalToConstant: 84),
            
            // blockCollectionView
            blockCollectionView.topAnchor.constraint(equalTo: productivityLabel.bottomAnchor, constant: 32),
            blockCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blockCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blockCollectionView.heightAnchor.constraint(equalToConstant: blockSize),
        ])
    }
}
