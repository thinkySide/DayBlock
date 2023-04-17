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
        viewManager.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    func setupTableViewCell() {
        
        /// 기본 선택값
        let index = blockManager.getGroupList().firstIndex { $0.name == blockManager.creation.name }!
        viewManager.tableView.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .top)
    }
    
    
    
    // MARK: - Method
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
        
//        /// 셀 선택
//        if cell.groupLabel.text == blockManager.creation.name {
//            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
