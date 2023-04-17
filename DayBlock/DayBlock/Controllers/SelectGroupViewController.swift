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
    weak var delegate: SelectGroupViewControllerDelegate?
    
    
    // MARK: - ViewController LifeCycle
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupDelegate()
        setupAddTarget()
        setupTableViewCell()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.updateGroup()
    }
    
    
    // MARK: - Initial
    
    func setupNavigation() {
        
        /// 커스텀
        title = "그룹 선택"
        navigationController?.navigationBar
            .titleTextAttributes = [.font: UIFont(name: Pretendard.semiBold, size: 16)!]
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 6)
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.clipsToBounds = true
        navigationController?.navigationBar.layer.cornerRadius = 30
        
        /// 뒤로가기 버튼
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = GrayScale.mainText
        navigationItem.backBarButtonItem = backBarButtonItem
        
        /// 그룹 추가 버튼
        navigationItem.rightBarButtonItem = viewManager.addBarButtonItem
    }
    
    func setupDelegate() {
        viewManager.delegate = self
        viewManager.tableView.dataSource = self
        viewManager.tableView.delegate = self
        viewManager.tableView.register(GroupSelectTableViewCell.self, forCellReuseIdentifier: Cell.groupSelect)
    }
    
    func setupAddTarget() {
        viewManager.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    func setupTableViewCell() {
        
        /// 기본 선택값
        let index = blockManager.getGroupList().firstIndex { $0.name == blockManager.getCreation().name }!
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = blockManager.getGroupList()[indexPath.row]
        blockManager.updateCreation(group: group.name)
    }
}



// MARK: - SelectGroupViewDelegate

extension SelectGroupViewController: SelectGroupViewDelegate {
    func addButtonTapped() {
        let createGroupVC = CreateGroupViewController()
        navigationController?.pushViewController(createGroupVC, animated: true)
    }
}
