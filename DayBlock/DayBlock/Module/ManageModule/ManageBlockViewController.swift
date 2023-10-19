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
        setupGesture()
        setupTableView()
    }
    
    // MARK: - Setup Method
    private func setupGesture() {
        let blockManage = viewManager.sectionBar.firstSection
        addTapGesture(blockManage, target: self, action: #selector(blockManageSectionTapped))
        
        let groupManage = viewManager.sectionBar.secondSection
        addTapGesture(groupManage, target: self, action: #selector(groupManageSectionTapped))
    }
    
    private func setupTableView() {
        viewManager.tableView.dataSource = self
        viewManager.tableView.delegate = self
        viewManager.tableView.register(
            ManageBlockTableViewCell.self,
            forCellReuseIdentifier: ManageBlockTableViewCell.cellID)
        viewManager.tableView.register(
            ManageBlockTableViewHeader.self,
            forHeaderFooterViewReuseIdentifier: ManageBlockTableViewHeader.headerID)
    }
    
    // MARK: - Gesture Method
    
    /// 블럭 관리 섹션을 탭했을 때 호출되는 메서드입니다.
    @objc func blockManageSectionTapped() {
        viewManager.sectionBar.active(.first)
    }
    
    /// 그룹 관리 섹션을 탭했을 때 호출되는 메서드입니다.
    @objc func groupManageSectionTapped() {
        viewManager.sectionBar.active(.second)
    }
}

extension ManageBlockViewController: UITableViewDataSource, UITableViewDelegate {
    
    /// HeaderView 설정 메서드
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ManageBlockTableViewHeader.headerID) as? ManageBlockTableViewHeader else {
            return UIView()
        }
        
        header.blockLabel.text = "\(groupData.list()[section].name)"
        return header
    }
    
    /// FooterView 설정 메서드
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .systemBlue
        return footer
    }
    
    /// Header 높이 값 설정 메서드
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 58
    }
    
    /// Footer 높이 값 설정 메서드
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 56
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupData.list().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let blockList = groupData.list()[section].blockList?.array as? [Block] else { return 0 }
        return blockList.count
    }
    
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
}
