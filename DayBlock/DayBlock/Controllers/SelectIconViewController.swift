//
//  SelectIconViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/13.
//

import UIKit

final class SelectIconViewController: UIViewController {
    
    // MARK: - Variable
    
    private let viewManager = SelectIconView()
    private let symbols = SFSymbols()
    
    
    // MARK: - ViewController LifeCycle
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupCollectionView()
    }
    
    
    
    // MARK: - Initial Method
    
    func setupDelegate() {
        viewManager.actionStackView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        viewManager.actionStackView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    func setupCollectionView() {
        let collectionView = viewManager.iconCollectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(IconCollectionViewCell.self, forCellWithReuseIdentifier: Cell.iconSelect)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.collectionViewLayout = viewManager.createCompositionalLayout()
    }
    
    
    
    // MARK: - Custom Method
    
    @objc func confirmButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
}



// MARK: - UICollectionView

extension SelectIconViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return symbols.symbolList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.iconSelect, for: indexPath) as! IconCollectionViewCell
        
        let icon = symbols.symbolList[indexPath.item]
        cell.icon.image = UIImage(systemName: icon)
        
        return cell
    }
}
