//
//  ManageViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/02.
//

import UIKit

final class ManageBlockViewController: UIViewController {
    
    let viewManager = ManageBlockView()
    let groupData = GroupDataStore.shared
    let blockData = BlockDataStore.shared
    let trackingData = TrackingDataStore.shared
    
    // MARK: - ViewController LifeCycle
    override func loadView() {
        view = viewManager
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupGesture()
        setupNavigation()
        setupTableView()
        
        viewManager.testButton.addTarget(self, action: #selector(test), for: .touchUpInside)
    }
    
    @objc func test() {
        let groupList = groupData.list()
        for group in groupList {
            
            print("[\(group.name) Group]")
            print("• color: \(group.color)")
            print("")
            
            if let blockList = group.blockList?.array as? [Block] {
                for block in blockList {
                    print("   [\(block.taskLabel) Block]")
                    print("   • order: \(block.order)")
                    print("")
                }
            }
            print("------------------------------------------\n")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewManager.tableView.reloadData()
    }
    
    // MARK: - Setup Method
    private func setupTabBar() {
        
        // 선택된 탭바 지정
        tabBarController?.tabBar.selectedItem?.title = "관리소"
        tabBarController?.tabBar.selectedItem?.image = UIImage(named: Icon.schedule)
    }
    
    private func setupGesture() {
        let blockManage = viewManager.sectionBar.firstSection
        addTapGesture(blockManage, target: self, action: #selector(blockManageSectionTapped))
        
        let groupManage = viewManager.sectionBar.secondSection
        addTapGesture(groupManage, target: self, action: #selector(groupManageSectionTapped))
    }
    
    private func setupNavigation() {
        
        // 뒤로가기 버튼 커스텀
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = Color.mainText
        navigationItem.backBarButtonItem = backBarButtonItem
        
        // 네비게이션바의 Appearance를 설정
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.tintColor = .white
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
    
    private func setupTableView() {
        let tableView = viewManager.tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        
        tableView.register(
            ManageBlockTableViewCell.self,
            forCellReuseIdentifier: ManageBlockTableViewCell.cellID)
        
        tableView.register(
            ManageBlockTableViewHeader.self,
            forHeaderFooterViewReuseIdentifier: ManageBlockTableViewHeader.headerID)
        
        tableView.register(
            ManageBlockTableViewFooter.self,
            forHeaderFooterViewReuseIdentifier: ManageBlockTableViewFooter.footerID)
    }
    
    // MARK: - Gesture Method
    
    /// 블럭 관리 섹션을 탭했을 때 호출되는 메서드입니다.
    @objc func blockManageSectionTapped() {

        // 스크롤 위치 초기화
        viewManager.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    /// 그룹 관리 섹션을 탭했을 때 호출되는 메서드입니다.
    @objc func groupManageSectionTapped() {
        guard var viewControllers = tabBarController?.viewControllers else {
            return
        }
        
        let manageGroupVC = UINavigationController(rootViewController: ManageGroupViewController())
        viewControllers[1] = manageGroupVC
        tabBarController?.setViewControllers(viewControllers, animated: true)
    }
}

// MARK: - UITableView
extension ManageBlockViewController: UITableViewDataSource, UITableViewDelegate {
    
    /// HeaderView 설정 메서드
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ManageBlockTableViewHeader.headerID) as? ManageBlockTableViewHeader else {
            return UIView()
        }
        
        header.layoutMargins = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
        
        header.groupLabel.text = "\(groupData.list()[section].name)"
        return header
    }
    
    /// FooterView 설정 메서드
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: ManageBlockTableViewFooter.footerID) as? ManageBlockTableViewFooter else {
            return UIView()
        }
        
        // 섹션 정보 저장
        footer.tag = section
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(footerCellTapped))
        footer.addGestureRecognizer(gesture)
        
        return footer
    }
    
    /// Header 높이 값 설정 메서드
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    /// Footer 높이 값 설정 메서드
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 64
    }
    
    /// 섹션 개수 값 설정 메서드
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupData.list().count
    }
    
    /// 섹션 안에 들어갈 아이템 개수 값 설정 메서드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let blockList = groupData.list()[section].blockList?.array as? [Block] else { return 0 }
        return blockList.count
    }
    
    /// 개별 셀 설정 메서드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = viewManager.tableView.dequeueReusableCell(withIdentifier: ManageBlockTableViewCell.cellID) as? ManageBlockTableViewCell else {
            return UITableViewCell()
        }
        
        let blockList = blockData.listInSelectedGroup(at: indexPath.section)
        let block = blockList[indexPath.row]
        cell.iconBlock.symbol.image = UIImage(systemName: block.icon)
        cell.iconBlock.backgroundColor = UIColor(rgb: block.superGroup.color)
        cell.taskLabel.text = block.taskLabel
        cell.outputLabel.text = "total +\(trackingData.totalOutput(block))"
        
        return cell
    }
    
    /// 셀 선택 시 호출되는 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 셀 클릭 시, 바로 비활성화되는 애니메이션 추가
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 관리 중인 섹션 인덱스 업데이트
        groupData.updateManageIndex(to: indexPath.section)
        
        // 관리 블럭 및 그룹 인덱스 업데이트
        groupData.updateManageIndex(to: indexPath.section)
        blockData.updateManageIndex(to: indexPath.row)
        
        // 편집 할 블럭 및 리모트 블럭 업데이트
        let editBlock = blockData.listInSelectedGroup(at: indexPath.section)[indexPath.row]
        blockData.updateRemote(group: groupData.list()[indexPath.section])
        blockData.updateRemoteBlock(label: editBlock.taskLabel)
        blockData.updateRemoteBlock(todayOutput: editBlock.todayOutput)
        blockData.updateRemoteBlock(icon: editBlock.icon)
        
        // 해당 블럭 편집 화면 Push
        let editBlockVC = CreateBlockViewController()
        editBlockVC.hidesBottomBarWhenPushed = true
        editBlockVC.configureManageEditMode()
        navigationController?.pushViewController(editBlockVC, animated: true)
    }
    
    /// Footer(블럭 추가하기) 탭 시 호출되는 메서드
    @objc func footerCellTapped(_ gesture: UITapGestureRecognizer) {
        guard let footer = gesture.view as? ManageBlockTableViewFooter else { return }
        
        // 관리 중인 섹션 인덱스 업데이트
        let section = footer.tag
        groupData.updateManageIndex(to: section)
        
        // 탭 애니메이션 실행
        UIView.animate(withDuration: 0.05) {
            footer.contentView.backgroundColor = Color.contentsBlock.withAlphaComponent(0.8)
        } completion: { _ in
            UIView.animate(withDuration: 0.4) {
                footer.contentView.backgroundColor = .white
            }
        }
        
        // 섹션에 속한 그룹의 블럭 생성 화면 Push
        let createBlockVC = CreateBlockViewController()
        createBlockVC.hidesBottomBarWhenPushed = true
        createBlockVC.setupCreateMode()
        createBlockVC.configureManageCreateMode()
        navigationController?.pushViewController(createBlockVC, animated: true)
    }
}

// MARK: - UITableViewDragDelegate
extension ManageBlockViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        print(#function)
        let itemProvider = NSItemProvider()
        return [UIDragItem(itemProvider: itemProvider)]
    }
    
    /// 실제 셀이 드래그 & 드롭 되었을 때 실행될 메서드
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        // 같은 셀 이동했을 때 불필요한 코드 실행 방지
        if sourceIndexPath == destinationIndexPath { return }
        
        blockData.moveCell(sourceIndexPath, destinationIndexPath)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        let sourceList = blockData.listInSelectedGroup(at: sourceIndexPath.section)
        let destinationList = blockData.listInSelectedGroup(at: proposedDestinationIndexPath.section)
        
        if sourceIndexPath.section != proposedDestinationIndexPath.section &&
            destinationList.contains(where: { block in
                block.taskLabel == sourceList[sourceIndexPath.row].taskLabel
            }) {
            showToast(toast: viewManager.toastView, isActive: true)
            return sourceIndexPath
        }
        
        showToast(toast: viewManager.toastView, isActive: false)
        return proposedDestinationIndexPath
    }
}

// MARK: - UITableViewDropDelegate
extension ManageBlockViewController: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    
    /// App이나 View 간의 드래그 앤 드롭 발생시 호출되는 메서드
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        print(#function)
    }
}
