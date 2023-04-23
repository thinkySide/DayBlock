//
//  SelectColorViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/13.
//

import UIKit

protocol SelectColorViewControllerDelegate: AnyObject {
    func updateColor()
}

final class SelectColorViewController: UIViewController {
    
    // MARK: - Manager
    
    private let viewManager = SelectColorView()
    private let blockManager = BlockManager.shared
    private let colorManager = ColorManager.shared
    weak var delegate: SelectColorViewControllerDelegate?
    
    
    
    // MARK: - ViewController LifeCycle
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupAddTarget()
        setupSelectedCell()
    }
    
    
    
    // MARK: - Initial Method
    
    func setupDelegate() {
        
        /// CollectionView
        let collectionView = viewManager.colorCollectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: Cell.colorSelect)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.collectionViewLayout = viewManager.createCompositionalLayout()
    }
    
    func setupAddTarget() {
        let action = viewManager.actionStackView
        action.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        action.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    func setupSelectedCell() {
        let indexPath = IndexPath(item: colorManager.getIndex(), section: 0)
        let collectionView = viewManager.colorCollectionView
        
        // 현재 스크롤 기능 작동하지 않음 ⭐️
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
    
    
    
    // MARK: - Custom Method
    
    @objc func confirmButtonTapped() {
        guard let indexPath = viewManager.colorCollectionView.indexPathsForSelectedItems else { return }
        let itemIndex = indexPath[0].item
        colorManager.updateIndex(to: itemIndex)
        // blockManager.updateRemoteBlock(color: colorManager.getSelectColor())
        
        /// delegate
        delegate?.updateColor()
        dismiss(animated: true)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
}



// MARK: - UICollectionView

extension SelectColorViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorManager.getColorList().count
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

