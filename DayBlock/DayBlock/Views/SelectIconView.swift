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
        label.font = UIFont(name: Pretendard.semiBold, size: 16)
        label.textColor = GrayScale.mainText
        label.textAlignment = .center
        return label
    }()
    
    let iconCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()

    
    let actionStackView: ActionStackView = {
        let stack = ActionStackView()
        return stack
    }()
    
    
    // MARK: - Variable
    
    
    
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
        [title, iconCollectionView, actionStackView]
            .forEach {
                /// 1. addSubView(component)
                addSubview($0)
                
                /// 2. translatesAutoresizingMaskIntoConstraints = false
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
    }
    
    func setupConstraints() {
        
        /// 3. NSLayoutConstraint.activate
        NSLayoutConstraint.activate([
            
            /// title
            title.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            /// iconCollectionView
            iconCollectionView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16),
            iconCollectionView.bottomAnchor.constraint(equalTo: actionStackView.topAnchor, constant: -8),
            iconCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            iconCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            /// actionStackView
            actionStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            actionStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            actionStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.margin),
        ])
    }
}



// MARK: - UICollectionViewDelegateFlowLayout

extension SelectIconView: UICollectionViewDelegateFlowLayout {
    
    func createCompositionalLayout() -> UICollectionViewLayout {
            
            /// 인스턴스 생성
            let layout = UICollectionViewCompositionalLayout {
                (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                
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
                    top: 0, leading: 0, bottom: 16, trailing: 16
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
