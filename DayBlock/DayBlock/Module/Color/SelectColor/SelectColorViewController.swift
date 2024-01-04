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
    
    private func setupSelectedCell() {
        
        // 스크롤이 아직 되지 않았다면, 초깃값 설정
        if !isScrolled {
            isScrolled = true
            let indexPath = IndexPath(item: colorManager.getCurrentIndex(), section: 0)
            let collectionView = self.viewManager.colorCollectionView
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemIndex = indexPath.item
        colorManager.updateCurrentIndex(to: itemIndex)
        groupData.updateRemote(color: colorManager.getSelectColor())
        
        // delegate
        delegate?.updateColor(index: indexPath.item)
        dismiss(animated: true)
    }
}
