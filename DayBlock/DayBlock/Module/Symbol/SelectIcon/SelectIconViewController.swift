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
    private let symbolManager = IconManager.shared
    weak var delegate: SelectIconViewControllerDelegate?
    
    private let blockData = BlockDataStore.shared
    
    /// 스크롤 제어를 위한 초깃값
    private var isScrolled: Bool = false
    
    // MARK: - ViewController LifeCycle
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSelectedCell()
    }
    
    // MARK: - Initial Method
    
    private func setupDelegate() {
        viewManager.actionStackView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        viewManager.actionStackView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        let collectionView = viewManager.iconCollectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SelectIconCollectionViewCell.self, forCellWithReuseIdentifier: Cell.iconSelect)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.collectionViewLayout = viewManager.createCompositionalLayout()
    }
    
    private func setupSelectedCell() {
        if !isScrolled {
            isScrolled = true
            let indexPath = IndexPath(item: symbolManager.selectedIndex(), section: 0)
            let collectionView = viewManager.iconCollectionView
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
        }
    }
    
    // MARK: - Custom Method
    
    @objc func confirmButtonTapped() {
        guard let indexPath = viewManager.iconCollectionView.indexPathsForSelectedItems else { return }
        let itemIndex = indexPath[0].item
        symbolManager.updateSelectedIndex(to: itemIndex)
        
        blockData.updateRemoteBlock(icon: symbolManager.selected())
        
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
        return symbolManager.list().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.iconSelect, for: indexPath) as! SelectIconCollectionViewCell
        
        let icon = symbolManager.list()[indexPath.item]
        cell.icon.image = UIImage(systemName: icon)
        
        return cell
    }
}
