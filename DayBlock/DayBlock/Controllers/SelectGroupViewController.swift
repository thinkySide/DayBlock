//
//  SelectGroupViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/13.
//

import UIKit

protocol SelectGroupViewControllerDelegate: AnyObject {
    func updateGroup()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.updateGroup()
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
    }
    
    func setupTableViewCell() {
        
        /// 기본 선택값
        let index = blockManager.getGroupList().firstIndex { $0.name == blockManager.getCreation().name }!
        viewManager.tableView.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .top)
    }
    
    
    
    // MARK: - Method
    
    @objc func addButtonTapped() {
        let createGroupVC = CreateGroupViewController()
        createGroupVC.modalPresentationStyle = .custom
        createGroupVC.transitioningDelegate = customBottomModalDelegate
        present(createGroupVC, animated: true)
    }
    
    @objc func confirmButtonTapped() {
        dismiss(animated: true)
    }
}



// MARK: - UITableView

extension SelectGroupViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockManager.getGroupListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewManager.tableView.dequeueReusableCell(withIdentifier: Cell.groupSelect, for: indexPath) as! GroupSelectTableViewCell
        
        /// 셀 업데이트
        let group = blockManager.getGroupList()[indexPath.row]
        cell.groupLabel.text = group.name
        cell.countLabel.text = "+\(blockManager.getBlockListCount(group.name))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = blockManager.getGroupList()[indexPath.row]
        blockManager.updateCreation(group: group.name)
    }
}
