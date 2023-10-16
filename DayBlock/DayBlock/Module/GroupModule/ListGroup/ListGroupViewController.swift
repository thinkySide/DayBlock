//
//  ListGroupViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/17.
//

import UIKit

final class ListGroupViewController: UIViewController {
    
    // Delegate
    weak var delegate: ListGroupViewControllerDelegate?
    
    private let viewManager = ListGroupView()
    
    private let groupData = GroupDataStore.shared
    private let blockData = BlockDataStore.shared
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupNavigation()
        setupTableView()
    }
    
    // MARK: - Setup Method
    
    private func setupDelegate() {
        viewManager.delegate = self
        viewManager.groupTableView.dragDelegate = self
        viewManager.groupTableView.dropDelegate = self
        viewManager.groupTableView.dragInteractionEnabled = true
    }
    
    private func setupNavigation() {
        title = "그룹 리스트"
        navigationController?.navigationBar
            .titleTextAttributes = [.font: UIFont(name: Pretendard.semiBold, size: 16)!]
        
        // Dismiss 버튼
        navigationItem.leftBarButtonItem = viewManager.backBarButtonItem
        
        // 그룹 추가 버튼
        navigationItem.rightBarButtonItem = viewManager.addBarButtonItem
        
        // 뒤로가기 버튼(다음 화면)
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = Color.mainText
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    private func setupTableView() {
        viewManager.groupTableView.dataSource = self
        viewManager.groupTableView.delegate = self
        viewManager.groupTableView.register(SelectGroupTableViewCell.self, forCellReuseIdentifier: Cell.groupSelect)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension ListGroupViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupData.list().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewManager.groupTableView.dequeueReusableCell(withIdentifier: Cell.groupSelect, for: indexPath) as! SelectGroupTableViewCell
        
        // 셀 업데이트
        let groupList = groupData.list()
        cell.color.backgroundColor = UIColor(rgb: groupList[indexPath.row].color)
        cell.groupLabel.text = groupList[indexPath.row].name
        cell.countLabel.text = "+\(blockData.listInSelectedGroup(at: indexPath.row).count)"
        
        // 셀 커스텀
        cell.checkMark.alpha = 0
        cell.chevron.isHidden = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("\(groupData.list()[indexPath.row].order)")
        
        // 셀 클릭 시, 바로 비활성화되는 애니메이션 추가
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 첫번째 그룹(그룹없음) 클릭 시, 수정 불가 안내
        if indexPath.row == 0 {
            showToast(toast: viewManager.toastView, isActive: true)
            return
        }
        
        // 현재 편집중인 그룹 인덱스 업데이트
        groupData.updateEditIndex(to: indexPath.row)
        
        // 토스트 비활성화
        showToast(toast: viewManager.toastView, isActive: false)
        
        // EditGroupDetailViewController로 Push
        let editGroupDetailVC = EditGroupViewController()
        editGroupDetailVC.delegate = self
        navigationController?.pushViewController(editGroupDetailVC, animated: true)
    }
    
    /// 실제 셀이 드래그 & 드롭 되었을 때 실행될 메서드
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("\(sourceIndexPath.row) -> \(destinationIndexPath.row)")
        groupData.moveCell(aIndex: sourceIndexPath.row, bIndex: destinationIndexPath.row)
        viewManager.groupTableView.reloadData()
    }
}

// MARK: - EditGroupViewDelegate

extension ListGroupViewController: ListGroupViewDelegate {
    func dismissVC() {
        dismiss(animated: true)
        delegate?.reloadData()
    }
    
    func addGroup() {
        let createGroupVC = CreateGroupViewController()
        createGroupVC.delegate = self
        navigationController?.pushViewController(createGroupVC, animated: true)
    }
}

// MARK: - EditGroupDetailViewControllerDelegate

extension ListGroupViewController: EditGroupViewControllerDelegate {
    func reloadData() {
        viewManager.groupTableView.reloadData()
    }
}

// MARK: - CreateGroupViewControllerDelegate

extension ListGroupViewController: CreateGroupViewControllerDelegate {
    func updateGroupList() {
        viewManager.groupTableView.reloadData()
    }
}

// MARK: - UITableViewDragDelegate
extension ListGroupViewController: UITableViewDragDelegate {
    
    /// 드래그 시작 시 호출되는 메서드
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        dragItems()
    }
    
    func dragItems() -> [UIDragItem] {
        let itemProvider = NSItemProvider()
        return [UIDragItem(itemProvider: itemProvider)]
    }
}

// MARK: - UITableViewDropDelegate
extension ListGroupViewController: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    
    /// 내려놓을 때 실행할 메서드
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) { }
}
