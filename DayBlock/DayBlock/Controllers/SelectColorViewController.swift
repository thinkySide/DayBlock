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
    
    // MARK: - Variable
    
    private let viewManager = SelectColorView()
    private let blockManager = BlockManager.shared
    private let colorManager = ColorManager()
    weak var delegate: SelectColorViewControllerDelegate?
    
    
    // MARK: - ViewController LifeCycle
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupAddTarget()
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
        viewManager.actionStackView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        viewManager.actionStackView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    
    
    // MARK: - Custom Method
    
    @objc func confirmButtonTapped() {
        guard let indexPath = viewManager.colorCollectionView.indexPathsForSelectedItems else { return }
        let itemIndex = indexPath[0].item
        blockManager.updateRemoteBlock(color: colorManager.getColorList()[itemIndex])
        
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

