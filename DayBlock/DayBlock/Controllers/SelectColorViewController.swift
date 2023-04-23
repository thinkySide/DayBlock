//
//  SelectColorViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/13.
//

import UIKit

final class SelectColorViewController: UIViewController {
    
    // MARK: - Variable
    
    private let viewManager = SelectColorView()
    private let colorManager = ColorManager()
    
    
    // MARK: - ViewController LifeCycle
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
    }
    
    
    
    // MARK: - Method
    
    func setupDelegate() {
        
        /// CollectionView
        let collectionView = viewManager.colorCollectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: Cell.colorSelect)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.collectionViewLayout = viewManager.createCompositionalLayout()
    }
}



// MARK: - UICollectionView

extension SelectColorViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = viewManager.colorCollectionView.dequeueReusableCell(
            withReuseIdentifier: Cell.colorSelect, for: indexPath) as! ColorCollectionViewCell
        cell.color.backgroundColor = colorManager.getColorList()[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

