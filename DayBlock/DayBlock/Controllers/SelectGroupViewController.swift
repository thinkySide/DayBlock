//
//  SelectGroupViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/13.
//

import UIKit

final class SelectGroupViewController: UIViewController {
    
    // MARK: - Variable
    
    private let viewManager = SelectGroupView()
    private let blockManager = BlockManager.shared
    private let customBottomModalDelegate = CustomBottomModalDelegate()
    weak var delegate: SelectGroupViewControllerDelegate?
    
    
    // MARK: - ViewController LifeCycle
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupAddTarget()
        setupSelectedCell()
    }
    
    
    
    // MARK: - Initial
    
    func setupDelegate() {
        viewManager.groupTableView.dataSource = self
        viewManager.groupTableView.delegate = self
        viewManager.groupTableView.register(GroupSelectTableViewCell.self, forCellReuseIdentifier: Cell.groupSelect)
    }
    
    func setupAddTarget() {
        viewManager.addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        viewManager.actionStackView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        viewManager.actionStackView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    func setupSelectedCell() {
        
//        /// 기본 선택값
//        let index = blockManager.getGroupList().firstIndex { $0.name == blockManager.getRemoteBlock().name }!
//        let indexPath = IndexPath(row: index, section: 0)
//        
//        /// 마지막 인덱스 선택 시, 화면에서 가려지기 때문에 scrollPosition Bottom으로
//        let tableView = viewManager.groupTableView
//        if index == blockManager.getGroupList().count - 1 {
//            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .bottom)
//            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
//        } else {
//            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
//        }
    }
    
    
    
    // MARK: - Method
    
    @objc func addButtonTapped() {
        let createGroupVC = CreateGroupViewController()
        createGroupVC.delegate = self
        
        let navController = UINavigationController(rootViewController: createGroupVC)
        navController.modalPresentationStyle = .overFullScreen
        present(navController, animated: true)
    }
    
    @objc func confirmButtonTapped() {
        
        /// 현재 선택된 indexPath 값으로 블럭 정보 업데이트
        guard let indexPath = viewManager.groupTableView.indexPathForSelectedRow else { return }
        let group = blockManager.getGroupList()[indexPath.row]
        blockManager.updateRemoteBlock(group: group)
        
        /// delegate
        delegate?.switchHomeGroup?(index: indexPath.row)
        delegate?.updateGroup?()
        dismiss(animated: true)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
}



// MARK: - UITableView

extension SelectGroupViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return blockManager.getGroupList().count
        return blockManager.groupEntity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewManager.groupTableView.dequeueReusableCell(withIdentifier: Cell.groupSelect, for: indexPath) as! GroupSelectTableViewCell
        
        /// 셀 업데이트
        let groupList = blockManager.groupEntity
        cell.color.backgroundColor = UIColor(rgb: groupList[indexPath.row].color)
        cell.groupLabel.text = groupList[indexPath.row].name
        cell.countLabel.text = "+\(blockManager.getBlockList(indexPath.row).count)"
        
        return cell
    }
}



// MARK: - CreateGroupViewControllerDelegate

extension SelectGroupViewController: CreateGroupViewControllerDelegate {
    func updateGroupList() {
        let lastIndex = blockManager.getGroupList().count - 1
        viewManager.groupTableView.reloadData()
        viewManager.groupTableView.selectRow(at: IndexPath(row: lastIndex, section: 0), animated: false, scrollPosition: .bottom)
    }
}

