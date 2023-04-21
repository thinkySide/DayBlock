//
//  SelectGroupViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/13.
//

import UIKit

@objc protocol SelectGroupViewControllerDelegate: AnyObject {
    @objc optional func updateCreationGroup()
    @objc optional func switchHomeGroup()
}

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
        setupTableViewCell()
    }
    
    
    
    // MARK: - Initial
    
    func setupDelegate() {
        viewManager.tableView.dataSource = self
        viewManager.tableView.delegate = self
        viewManager.tableView.register(GroupSelectTableViewCell.self, forCellReuseIdentifier: Cell.groupSelect)
    }
    
    func setupAddTarget() {
        viewManager.addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        viewManager.actionStackView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        viewManager.actionStackView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    func setupTableViewCell() {
        
        /// 기본 선택값
        let index = blockManager.getGroupList().firstIndex { $0.name == blockManager.getCreation().name }!
        let indexPath = IndexPath(row: index, section: 0)
        
        /// 마지막 인덱스 일시 화면에서 가려지기 때문에 scrollPosition Bottom으로
        let tableView = viewManager.tableView
        if index == blockManager.getGroupList().count - 1 {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .bottom)
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
        } else {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
        }
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
        guard let indexPath = viewManager.tableView.indexPathForSelectedRow else { return }
        let group = blockManager.getGroupList()[indexPath.row]
        blockManager.updateCreation(group: group.name)
        
        delegate?.switchHomeGroup?()
        delegate?.updateCreationGroup?()
        dismiss(animated: true)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
}



// MARK: - UITableView

extension SelectGroupViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockManager.getGroupList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewManager.tableView.dequeueReusableCell(withIdentifier: Cell.groupSelect, for: indexPath) as! GroupSelectTableViewCell
        
        /// 셀 업데이트
        let groupList = blockManager.getGroupList()
        cell.groupLabel.text = groupList[indexPath.row].name
        cell.countLabel.text = "+\(blockManager.getBlockList(indexPath.row).count)"
        
        return cell
    }
}



// MARK: - CreateGroupViewControllerDelegate

extension SelectGroupViewController: CreateGroupViewControllerDelegate {
    func updateGroupList() {
        let lastIndex = blockManager.getGroupList().count - 1
        viewManager.tableView.reloadData()
        viewManager.tableView.selectRow(at: IndexPath(row: lastIndex, section: 0), animated: false, scrollPosition: .bottom)
    }
}

