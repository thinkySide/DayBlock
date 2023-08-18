//
//  EditGroupViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/17.
//

import UIKit

protocol EditGroupViewControllerDelegate: AnyObject {
    func reloadData()
}

final class EditGroupViewController: UIViewController {
    
    weak var delegate: EditGroupViewControllerDelegate?
    
    private let viewManager = EditGroupView()
    private let blockManager = BlockManager.shared
    
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
    }
    
    private func setupNavigation() {
        title = "그룹 리스트"
        navigationController?.navigationBar
            .titleTextAttributes = [.font: UIFont(name: Pretendard.semiBold, size: 16)!]
        
        // Dismiss 버튼
        navigationItem.leftBarButtonItem = viewManager.backBarButtonItem
        
        // 뒤로가기 버튼(다음 화면)
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = GrayScale.mainText
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    private func setupTableView() {
        viewManager.groupTableView.dataSource = self
        viewManager.groupTableView.delegate = self
        viewManager.groupTableView.register(GroupSelectTableViewCell.self, forCellReuseIdentifier: Cell.groupSelect)
    }
}


// MARK: - UITableViewDataSource & UITableViewDelegate

extension EditGroupViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockManager.getGroupList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewManager.groupTableView.dequeueReusableCell(withIdentifier: Cell.groupSelect, for: indexPath) as! GroupSelectTableViewCell
        
        // 셀 업데이트
        let groupList = blockManager.getGroupList()
        cell.color.backgroundColor = UIColor(rgb: groupList[indexPath.row].color)
        cell.groupLabel.text = groupList[indexPath.row].name
        cell.countLabel.text = "+\(blockManager.getBlockList(indexPath.row).count)"
        
        // 셀 커스텀
        cell.checkMark.alpha = 0
        cell.chevron.isHidden = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 현재 편집중인 그룹 인덱스 업데이트
        blockManager.updateCurrentEditGroupIndex(indexPath.row)
        
        let editGroupDetailVC = EditGroupDetailViewController()
        editGroupDetailVC.delegate = self
        navigationController?.pushViewController(editGroupDetailVC, animated: true)
    }
}


// MARK: - EditGroupViewDelegate

extension EditGroupViewController: EditGroupViewDelegate {
    func dismissVC() {
        dismiss(animated: true)
        delegate?.reloadData()
    }
}


// MARK: - 내용입력

extension EditGroupViewController: EditGroupDetailViewControllerDelegate {
    func reloadData() {
        viewManager.groupTableView.reloadData()
    }
}
