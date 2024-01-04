//
//  SelectIconView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/13.
//

import UIKit

final class SelectIconView: UIView {
    
    // MARK: - Component
    
    private let title: UILabel = {
        let label = UILabel()
        label.text = "아이콘 선택"
        label.font = UIFont(name: Pretendard.semiBold, size: 18)
        label.textColor = Color.mainText
        label.textAlignment = .center
        return label
    }()
    
    let optionSelector = OptionSelector()
    
    let iconCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        // collection.backgroundColor = .red
        return collection
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
    
    // MARK: - Method
    func setupInitial() {
        backgroundColor = .white
        
        /// CornerRadius
        self.clipsToBounds = true
        self.layer.cornerRadius = 30
    }
    
    func setupAddSubView() {
        [title, optionSelector, iconCollectionView]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            // title
            title.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // optionSelector
            optionSelector.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            optionSelector.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            // iconCollectionView
            iconCollectionView.topAnchor.constraint(equalTo: optionSelector.bottomAnchor, constant: 16),
            iconCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            iconCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            iconCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
        ])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SelectIconView: UICollectionViewDelegateFlowLayout {
    
    func createCompositionalLayout() -> UICollectionViewLayout {
            
            /// 인스턴스 생성
            let layout = UICollectionViewCompositionalLayout {
                (_: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                
                /// item 사이즈
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1/5),
                    heightDimension: .fractionalWidth(1/5)
                )
                
                /// item 만들기
                let item = NSCollectionLayoutItem(
                    layoutSize: itemSize
                )
                
                /// item 간격 설정
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 0, leading: 0, bottom: 1, trailing: 1
                )
                
                /// item Group 사이즈
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalWidth(1/5)
                )
                
                /// Group 사이즈로 Group 만들기
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item, item, item]
                )
                
                /// 만든 Group으로 Section 만들기
                let section = NSCollectionLayoutSection(group: group)
                
                /// Section에 대한 간격 설정
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 0, leading: 0, bottom: 0, trailing: 0
                )
                return section
            }
            return layout
        }
}
