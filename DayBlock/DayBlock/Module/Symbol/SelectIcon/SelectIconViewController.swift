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
        setupCollectionView()
        setupEvent()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSelectedCell()
    }
    
    // MARK: - Initial Method
    
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
    
    private func setupEvent() {
        let iconSectionBar = viewManager.iconSectionBar
        iconSectionBar.firstSection.addTarget(self, action: #selector(firstSectionTapped), for: .touchUpInside)
        iconSectionBar.secondSection.addTarget(self, action: #selector(secondSectionTapped), for: .touchUpInside)
        iconSectionBar.thirdSection.addTarget(self, action: #selector(thirdSectionTapped), for: .touchUpInside)
        iconSectionBar.fourthSection.addTarget(self, action: #selector(fourthSectionTapped), for: .touchUpInside)
        iconSectionBar.fifthSection.addTarget(self, action: #selector(fifthSectionTapped), for: .touchUpInside)
        iconSectionBar.sixthSection.addTarget(self, action: #selector(sixthSectionTapped), for: .touchUpInside)
    }
    
    // MARK: - Section Event
    
    /// 첫번째 섹션, "전체"를 탭했을 때 호출되는 메서드입니다.
    @objc func firstSectionTapped() {
        viewManager.iconSectionBar.active(.first)
    }
    
    /// 두번째 섹션, "사물"를 탭했을 때 호출되는 메서드입니다.
    @objc func secondSectionTapped() {
        viewManager.iconSectionBar.active(.second)
    }
    
    /// 세번째 섹션, "자연"를 탭했을 때 호출되는 메서드입니다.
    @objc func thirdSectionTapped() {
        viewManager.iconSectionBar.active(.third)
    }
    
    /// 네번째 섹션, "건강"를 탭했을 때 호출되는 메서드입니다.
    @objc func fourthSectionTapped() {
        viewManager.iconSectionBar.active(.fourth)
    }
    
    /// 다섯번째 섹션, "운동"를 탭했을 때 호출되는 메서드입니다.
    @objc func fifthSectionTapped() {
        viewManager.iconSectionBar.active(.fifth)
    }
    
    /// 여섯번째 섹션, "교통"를 탭했을 때 호출되는 메서드입니다.
    @objc func sixthSectionTapped() {
        viewManager.iconSectionBar.active(.sixth)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemIndex = indexPath.item
        symbolManager.updateSelectedIndex(to: itemIndex)
        
        blockData.updateRemoteBlock(icon: symbolManager.selected())
        
        /// delegate
        delegate?.updateIcon()
        dismiss(animated: true)
    }
}
