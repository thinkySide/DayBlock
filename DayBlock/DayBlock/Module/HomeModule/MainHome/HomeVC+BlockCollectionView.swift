//
//  HomeVC+BlockCollectionView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/18.
//

import UIKit

// MARK: - Setup Block CollectionView
extension HomeViewController {
    
    /// UICollectionView 기본 설정 메서드입니다.
    func setupBlockCollectionView() {
        let collectionView = viewManager.blockCollectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HomeBlockCollectionViewCell.self, forCellWithReuseIdentifier: Cell.block)
        
        configureCarouselLayout()
        configureStartGroupFocus()
    }
    
    /// UserDefault를 사용한 초기 CollectionView의 그룹 선택값을 설정합니다.
    private func configureStartGroupFocus() {
        let groupIndex = UserDefaults.standard.object(forKey: UserDefaultsKey.groupIndex) as? Int ?? 0
        switchHomeGroup(index: groupIndex)
        groupData.updateFocusIndex(to: groupIndex)
    }
    
    /// CollectionView 캐러셀 레이아웃 구성을 위한 메서드입니다.
    private func configureCarouselLayout() {
        
        // (전체 화면 가로 사이즈 - 블럭 가로 사이즈) / 2
        let inset: CGFloat = (UIScreen.main.bounds.width - Size.blockSize.width) / 2.0
        
        // 왼쪽과 오른쪽에 inset만큼 떨어트리기
        let contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        // CollectionView의 contentInset 설정
        viewManager.blockCollectionView.contentInset = contentInset
    }
}

// MARK: - UICollectionView Delegate
extension HomeViewController: UICollectionViewDataSource {
    
    /// 셀 개수를 리턴하는 Delegate 메서드입니다.
    /// - 블럭 추가 버튼을 위해 +1
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return blockManager.getCurrentBlockList().count + 1
    }
    
    /// 각 셀을 설정하는 Delegate 메서드입니다.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 셀 생성
        guard let cell = viewManager.blockCollectionView.dequeueReusableCell(
            withReuseIdentifier: Cell.block, for: indexPath) as? HomeBlockCollectionViewCell else {
            print("HomeBlockCollectionViewCell 생성에 실패했습니다.")
            return UICollectionViewCell()
        }
        
        // 셀 초기화(애니메이션 X) 메서드
        cell.reverseDirectionWithNoAnimation()
        
        // 삭제 버튼 & 편집 버튼 설정
        let blockData = blockManager.getCurrentBlockList()
        configureDeleteButton(cell)
        configureEditButton(cell, data: blockData, indexPath: indexPath)
        
        // 트래킹셀 or 추가셀 생성
        if indexPath.row + 1 <= blockData.count {
            return makeTrackingBlockCell(cell, blockEntity: blockData[indexPath.row])
        } else {
            return makeAddBlockCell(cell)
        }
    }
}

// MARK: - CollectionView Configure Each Cell
extension HomeViewController {
    
    /// 트래킹 셀(일반 블럭)을 생성합니다.
    ///
    /// - Parameter cell: 등록할 CollectionViewCell
    private func makeTrackingBlockCell(_ cell: HomeBlockCollectionViewCell, blockEntity: Block) -> HomeBlockCollectionViewCell {
        cell.plusLabel.textColor = groupData.focusColor()
        cell.totalProductivityLabel.text = "\(blockEntity.todayOutput)"
        cell.blockColorTag.backgroundColor = groupData.focusColor()
        cell.blockIcon.image = UIImage(systemName: blockEntity.icon)
        cell.blockLabel.text = blockEntity.taskLabel
        cell.stroke.isHidden = true
        return cell
    }
    
    /// 블럭 추가 셀을 생성합니다.
    ///
    /// - Parameter cell: 등록할 CollectionViewCell
    private func makeAddBlockCell(_ cell: HomeBlockCollectionViewCell) -> HomeBlockCollectionViewCell {
        cell.plusLabel.isHidden = true
        cell.totalProductivityLabel.isHidden = true
        cell.blockColorTag.isHidden = true
        cell.blockLabel.isHidden = true
        cell.blockIcon.image = UIImage(systemName: "plus.circle.fill")
        cell.blockIcon.tintColor = Color.addBlockButton
        cell.backgroundColor = .white
        cell.stroke.isHidden = false
        return cell
    }
}

// MARK: - CollectionView Gesture
extension HomeViewController: UICollectionViewDelegate {
    
    /// 셀을 선택할 때 호출되는 Delegate 메서드입니다.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 셀 생성
        guard let cell = collectionView.cellForItem(at: indexPath) as? HomeBlockCollectionViewCell else {
            print("HomeBlockCollectionViewCell 생성에 실패했습니다.")
            return
        }
        
        // 현재 포커스 되어있는 블럭만 활성화
        if indexPath.item != blockManager.getCurrentBlockIndex() {
            print("현재 포커스 되어 있지 않은 블럭은 선택할 수 없습니다.")
            return
        }
        
        // 블럭 토글 이벤트
        if cell.blockIcon.alpha == 0 { cell.reverseDirection(.front) }
        else { cell.reverseDirection(.back) }
        
        // 마지막 블럭이라면 AddBlockViewController 화면 이동
        if blockIndex == indexPath.item &&
            blockManager.getCurrentBlockList().count == indexPath.item {
            cell.reverseDirection(.last)
            viewManager.toggleTrackingButton(false)
            pushAddBlockViewController()
        }
    }
    
    /// Cell의 삭제 버튼 제스처를 설정합니다.
    ///
    /// - Parameter cell: 등록할 CollectionViewCell
    private func configureDeleteButton(_ cell: HomeBlockCollectionViewCell) {
        cell.trashButtonTapped = { [weak self] _ in
            let deletePopup = PopupViewController()
            deletePopup.delegate = self
            deletePopup.modalPresentationStyle = .overCurrentContext
            deletePopup.modalTransitionStyle = .crossDissolve
            self?.present(deletePopup, animated: true)
        }
    }
    
    /// Cell의 편집 버튼 제스처를 설정합니다.
    ///
    /// - Parameter cell: 등록할 CollectionViewCell
    /// - Parameter data: 편집 블럭 설정용 BlockEntity
    /// - Parameter indexPath: CollectionView IndexPath
    private func configureEditButton(_ cell: HomeBlockCollectionViewCell, data: [Block], indexPath: IndexPath) {
        cell.editButtonTapped = { [weak self] _ in
            guard let self else { return }
            let editBlock = data[indexPath.row]
            blockManager.updateRemoteBlock(group: groupData.focusEntity())
            blockManager.updateRemoteBlock(label: editBlock.taskLabel)
            blockManager.updateRemoteBlock(output: editBlock.todayOutput)
            blockManager.updateRemoteBlock(icon: editBlock.icon)
            blockManager.updateCurrentBlockIndex(indexPath.row)
            pushEditBlockViewController()
        }
    }
}

// MARK: - Navigation Method
extension HomeViewController {
    
    /// 블럭 추가 ViewController로 Push합니다.
    private func pushAddBlockViewController() {
        let createBlockVC = CreateBlockViewController()
        createBlockVC.delegate = self
        createBlockVC.hidesBottomBarWhenPushed = true
        createBlockVC.setupCreateMode()
        navigationController?.pushViewController(createBlockVC, animated: true)
    }
    
    /// 블럭 편집 ViewController로 Push합니다.
    private func pushEditBlockViewController() {
        let editBlockVC = CreateBlockViewController()
        editBlockVC.delegate = self
        editBlockVC.hidesBottomBarWhenPushed = true
        editBlockVC.setupEditMode()
        navigationController?.pushViewController(editBlockVC, animated: true)
    }
}

// MARK: - PopupViewControllerDelegate
extension HomeViewController: PopupViewControllerDelegate {
    
    /// Popup의 블럭 "삭제할래요" 버튼 클릭 시 호출되는 메서드입니다.
    func confirmButtonTapped() {
        let deleteBlock = blockManager.getCurrentBlockList()[blockManager.getCurrentBlockIndex()]
        blockManager.deleteBlockEntitiy(deleteBlock)
        viewManager.blockCollectionView.reloadData()
        
        // 그룹 리스트가 비어있을 시, 트래킹 버튼 비활성화
        let blockList = groupData.focusEntity().blockList?.array as! [Block]
        if blockList.isEmpty || (blockManager.getCurrentBlockIndex() == blockList.count) {
            viewManager.toggleTrackingButton(false)
        } else {
            viewManager.toggleTrackingButton(true)
        }
    }
}
