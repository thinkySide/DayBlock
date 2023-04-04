//
//  ViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/03/31.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - Object
    
    private let viewManager = HomeView()
    
    
    
    // MARK: - ViewController LifeCycle
    
    override func loadView() {
        super.loadView()
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitial()
        setupDelegate()
        setupContentInset()
    }
    
    
    
    // MARK: - Method
    
    func setupInitial() {
        navigationItem.title = "자기계발"
    }
    
    func setupDelegate() {
        
        /// blockCollectionView
        viewManager.blockCollectionView.dataSource = self
        viewManager.blockCollectionView.delegate = self
        viewManager.blockCollectionView.register(BlockCollectionViewCell.self,
                                                 forCellWithReuseIdentifier: Cell.block)
    }
    
    func setupContentInset() {
        
        /// (전체 화면 가로 사이즈 - 블럭 가로 사이즈) / 2
        let inset: CGFloat = (UIScreen.main.bounds.width - Size.blockSize.width) / 2.0
        
        /// 왼쪽과 오른쪽에 inset만큼 떨어트리기
        let contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        /// CollectionView의 contentInset 설정
        viewManager.blockCollectionView.contentInset = contentInset
    }
    
}



// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = viewManager.blockCollectionView.dequeueReusableCell(
            withReuseIdentifier: Cell.block, for: indexPath) as! BlockCollectionViewCell
        
        cell.backgroundColor = GrayScale.contentsBlock
        
        return cell
    }
    
}



// MARK: - UIScrollViewDelegate

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        /// 스크롤된 크기 = 스크롤이 멈춘 x좌표 + 스크롤뷰 inset
        let scrollSize = targetContentOffset.pointee.x + scrollView.contentInset.left
        
        /// 블럭 크기 = 블럭 가로 사이즈 + 블럭 여백 (보이는 영역 보다 크게 사이즈를 잡아야 캐러셀 구현 가능)
        let blockWidth = Size.blockSize.width + Size.blockSpacing
        
        /// 블럭 인덱스 = 스크롤된 크기 / 블럭 크기
        let blockIndex = round(scrollSize / blockWidth)
        
        /// 최종 스크롤 위치 지정
        targetContentOffset.pointee = CGPoint(x: blockIndex * blockWidth - scrollView.contentInset.left,
                                              y: scrollView.contentInset.top)
    }
    
}
