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
    private let blockManager = BlockManager.shared
    private let symbolManager = SymbolManager.shared
    weak var delegate: SelectIconViewControllerDelegate?
    
    
    // MARK: - ViewController LifeCycle
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupCollectionView()
        setupSelectedCell()
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
    
    func setupSelectedCell() {
        let indexPath = IndexPath(item: symbolManager.getCurrentIndex(), section: 0)
        let collectionView = viewManager.iconCollectionView
        
        // 현재 스크롤 기능 작동하지 않음 ⭐️
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
    
    
    
    // MARK: - Custom Method
    
    @objc func confirmButtonTapped() {
        guard let indexPath = viewManager.iconCollectionView.indexPathsForSelectedItems else { return }
        let itemIndex = indexPath[0].item
        symbolManager.updateCurrentIndex(to: itemIndex)
        blockManager.updateRemoteBlock(icon: symbolManager.getSelectIcon())
        
        /// delegate
        delegate?.updateIcon()
        dismiss(animated: true)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
}



// MARK: - UICollectionView

extension SelectIconViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return symbolManager.getSymbolList().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.iconSelect, for: indexPath) as! IconCollectionViewCell
        
        let icon = symbolManager.getSymbolList()[indexPath.item]
        cell.icon.image = UIImage(systemName: icon)
        
        return cell
    }
}
