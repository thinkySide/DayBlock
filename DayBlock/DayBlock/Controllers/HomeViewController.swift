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

}



// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = viewManager.blockCollectionView.dequeueReusableCell(
            withReuseIdentifier: Cell.block, for: indexPath) as! BlockCollectionViewCell
        
        cell.backgroundColor = .red
        
        return cell
    }
    
}
