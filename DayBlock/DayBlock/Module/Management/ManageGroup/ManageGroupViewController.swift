//
//  ManageGroupViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/17.
//

import UIKit

final class ManageGroupViewController: UIViewController {
    
    // Delegate
    weak var delegate: ManageGroupViewControllerDelegate?
    
    private let viewManager = ManageGroupView()
    
    private let groupData = GroupDataStore.shared
    private let blockData = BlockDataStore.shared
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupDelegate()
        setupGesture()
        setupNavigation()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewManager.groupTableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        showToast(toast: viewManager.toastView, isActive: false)
    }
    
    // MARK: - Setup Method
    
    private func setupTabBar() {
        tabBarController?.tabBar.selectedItem?.title = "관리소"
        tabBarController?.tabBar.selectedItem?.image = UIImage(named: Icon.storage)
    }
    
    private func setupDelegate() {
        viewManager.delegate = self
        viewManager.groupTableView.dragDelegate = self
        viewManager.groupTableView.dropDelegate = self
        viewManager.groupTableView.dragInteractionEnabled = true
    }
    
    private func setupGesture() {
        let groupManage = viewManager.sectionBar.firstSection
        addTapGesture(groupManage, target: self, action: #selector(groupManageSectionTapped))
        
        let blockManage = viewManager.sectionBar.secondSection
        addTapGesture(blockManage, target: self, action: #selector(blockManageSectionTapped))
    }
    
    private func setupNavigation() {
        navigationController?.navigationBar
            .titleTextAttributes = [.font: UIFont(name: Pretendard.semiBold, size: 16)!]
        
        // 뒤로가기 버튼(다음 화면)
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = Color.mainText
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    private func setupTableView() {
        viewManager.groupTableView.dataSource = self
        viewManager.groupTableView.delegate = self
        viewManager.groupTableView.register(ManageGroupTableViewCell.self, forCellReuseIdentifier: Cell.groupSelect)
        viewManager.groupTableView.register(SelectGroupTableViewFooter.self, forHeaderFooterViewReuseIdentifier: SelectGroupTableViewFooter.footerID)
    }
    
    // MARK: - Gesture Method
    
    /// 블럭 관리 섹션을 탭했을 때 호출되는 메서드입니다.
    @objc func blockManageSectionTapped() {
        viewManager.sectionBar.active(.second)
        
        guard var viewControllers = tabBarController?.viewControllers else {
            return
        }
        
        let manageBlockVC = UINavigationController(rootViewController: ManageBlockViewController())
        viewControllers[2] = manageBlockVC
        tabBarController?.setViewControllers(viewControllers, animated: true)
    }
    
    /// 그룹 관리 섹션을 탭했을 때 호출되는 메서드입니다.
    @objc func groupManageSectionTapped() {
        viewManager.sectionBar.active(.first)
        
        // 스크롤 위치 초기화
        viewManager.groupTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension ManageGroupViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupData.list().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewManager.groupTableView.dequeueReusableCell(withIdentifier: Cell.groupSelect, for: indexPath) as! ManageGroupTableViewCell
        
        // 셀 업데이트
        let groupList = groupData.list()
        cell.color.backgroundColor = UIColor(rgb: groupList[indexPath.row].color)
        cell.groupLabel.text = groupList[indexPath.row].name
        cell.countLabel.text = "+\(blockData.listInSelectedGroup(at: indexPath.row).count)"
        
        // 기본 그룹 설정
        if indexPath.row == 0 { cell.defaultGroupLabel.alpha = 1 }
        
        // 셀 커스텀
        cell.checkMark.alpha = 0
        cell.chevron.isHidden = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 셀 클릭 시, 바로 비활성화되는 애니메이션 추가
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 현재 편집중인 그룹 인덱스 업데이트
        groupData.updateEditIndex(to: indexPath.row)
        
        // 첫번째 그룹(기본 그룹) 필터
        let isDefaultGroup = indexPath.row == 0 ? true : false
        
        // EditGroupDetailViewController로 Push
        let editGroupDetailVC = EditGroupViewController(isDefaultGroup: isDefaultGroup)
        editGroupDetailVC.delegate = self
        editGroupDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(editGroupDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: SelectGroupTableViewFooter.footerID) as? SelectGroupTableViewFooter else {
            return UIView()
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(footerCellTapped))
        footer.addGestureRecognizer(gesture)
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 56
    }
    
    /// Footer(그룹 추가하기) 를 터치했을 때 실행되는 메서드입니다.
    @objc func footerCellTapped(_ gesture: UITapGestureRecognizer) {
        guard let footer = gesture.view as? SelectGroupTableViewFooter else { return }
        
        // 터치 애니메이션
        UIView.animate(withDuration: 0.05) {
            footer.contentView.backgroundColor = Color.contentsBlock.withAlphaComponent(0.8)
        } completion: { _ in
            UIView.animate(withDuration: 0.4) {
                footer.contentView.backgroundColor = .white
            }
        }
        
        // 그룹 생성 ViewController Push
        let createGroupVC = CreateGroupViewController()
        createGroupVC.delegate = self
        
        // Present 세팅
        createGroupVC.screenMode = .navigation
        createGroupVC.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(createGroupVC, animated: true)
    }
}

// MARK: - EditGroupViewDelegate

extension ManageGroupViewController: ManageGroupViewDelegate {
    func dismissVC() {
        dismiss(animated: true)
        delegate?.reloadData()
    }
    
    func addGroup() {
        let createGroupVC = CreateGroupViewController()
        createGroupVC.delegate = self
        createGroupVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(createGroupVC, animated: true)
    }
}

// MARK: - EditGroupDetailViewControllerDelegate

extension ManageGroupViewController: EditGroupViewControllerDelegate {
    func reloadData() {
        viewManager.groupTableView.reloadData()
    }
}

// MARK: - CreateGroupViewControllerDelegate

extension ManageGroupViewController: CreateGroupViewControllerDelegate {
    func updateGroupList() {
        viewManager.groupTableView.reloadData()
    }
}

// MARK: - UITableViewDragDelegate
extension ManageGroupViewController: UITableViewDragDelegate {
    
    /// 드래그 시작 시 호출되는 메서드
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        // 만약 0번째 아이템이라면 빈 배열 반환
        if indexPath.row == 0 { return [] }
        
        let itemProvider = NSItemProvider()
        return [UIDragItem(itemProvider: itemProvider)]
    }
    
    /// 셀이 이동될 수 있는지 여부를 판단하는 메서드
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        // 만약 0번째 아이템이라면 이동 취소
        if indexPath.row == 0 {
            showToast(toast: viewManager.toastView, isActive: true)
            return false
        }
        
        return true
    }
    
    /// 실제 셀이 드래그 & 드롭 되었을 때 실행될 메서드
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        // 만약 첫번째 그룹을 이동시키려 한다면 실행 취소
        if sourceIndexPath.row == 0 || destinationIndexPath.row == 0 {
            showToast(toast: viewManager.toastView, isActive: true)
            viewManager.groupTableView.reloadData()
            return
        }
        
        groupData.moveCell(sourceIndexPath.row, destinationIndexPath.row)
        viewManager.groupTableView.reloadData()
    }
}

// MARK: - UITableViewDropDelegate
extension ManageGroupViewController: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    
    /// 다른 APP으로 내려놓을 때 실행할 메서드
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) { }
}
