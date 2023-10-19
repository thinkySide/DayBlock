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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ManageBlockTableViewHeader.headerID) as? ManageBlockTableViewHeader else {
            return UIView()
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .systemBlue
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 56
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupData.list().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
