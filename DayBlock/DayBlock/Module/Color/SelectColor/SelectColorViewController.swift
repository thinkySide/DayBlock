//
//  SelectColorViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/13.
//

import UIKit

final class SelectColorViewController: UIViewController {
    
    private let viewManager = SelectColorView()
    private let colorManager = ColorManager.shared
    weak var delegate: SelectColorViewControllerDelegate?
    
    private let groupData = GroupDataStore.shared
    private let blockData = BlockDataStore.shared
    
    /// 스크롤 제어를 위한 초깃값
    private var isScrolled: Bool = false
    
    // MARK: - ViewController LifeCycle
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupAddTarget()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSelectedCell()
    }
    
    // MARK: - Initial Method
    
    private func setupCollectionView() {
        
        /// CollectionView
        let collectionView = viewManager.colorCollectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SelectColorCollectionViewCell.self, forCellWithReuseIdentifier: Cell.colorSelect)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.collectionViewLayout = viewManager.createCompositionalLayout()
    }
    
    private func setupAddTarget() {
        let action = viewManager.actionStackView
        action.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        action.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    private func setupSelectedCell() {
        
        // 스크롤이 아직 되지 않았다면, 초깃값 설정
        if !isScrolled {
            isScrolled = true
            let indexPath = IndexPath(item: self.colorManager.getCurrentIndex(), section: 0)
            let collectionView = self.viewManager.colorCollectionView
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
        }
    }
    
    // MARK: - Custom Method
    
    @objc func confirmButtonTapped() {
        guard let indexPath = viewManager.colorCollectionView.indexPathsForSelectedItems else { return }
        let itemIndex = indexPath[0].item
        colorManager.updateCurrentIndex(to: itemIndex)
        groupData.updateRemote(color: colorManager.getSelectColor())
        
        // delegate
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
            withReuseIdentifier: Cell.colorSelect, for: indexPath) as! SelectColorCollectionViewCell
        cell.color.backgroundColor = colorManager.getColorList()[indexPath.item]
        return cell
    }
}
