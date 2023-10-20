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
        setupTabBar()
        setupGesture()
        setupNavigation()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewManager.tableView.reloadData()
        
        // 네비게이션바 스크롤 색상 초기화
        let nbAppearance = UINavigationBarAppearance()
        nbAppearance.configureWithOpaqueBackground()
        nbAppearance.backgroundColor = .white
        nbAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = nbAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = nbAppearance
        
        // 탭배 스크롤 색상 초기화
        let tbAppearance = UITabBarAppearance()
        tbAppearance.configureWithOpaqueBackground()
        tbAppearance.backgroundColor = .white
        tbAppearance.shadowColor = .clear
        tabBarController?.tabBar.standardAppearance = tbAppearance
        if #available(iOS 15.0, *) {
            tabBarController?.tabBar.scrollEdgeAppearance = tbAppearance
        }
    }
    
    // MARK: - Setup Method
    private func setupTabBar() {
        tabBarController?.tabBar.selectedItem?.title = "관리소"
        tabBarController?.tabBar.selectedItem?.image = UIImage(named: Icon.schedule)
    }
    
    private func setupGesture() {
        let blockManage = viewManager.sectionBar.firstSection
        addTapGesture(blockManage, target: self, action: #selector(blockManageSectionTapped))
        
        let groupManage = viewManager.sectionBar.secondSection
        addTapGesture(groupManage, target: self, action: #selector(groupManageSectionTapped))
    }
    
    private func setupNavigation() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = Color.mainText
        navigationItem.backBarButtonItem = backBarButtonItem
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
        
        viewManager.tableView.register(
            ManageBlockTableViewFooter.self,
            forHeaderFooterViewReuseIdentifier: ManageBlockTableViewFooter.footerID)
    }
    
    // MARK: - Gesture Method
    
    /// 블럭 관리 섹션을 탭했을 때 호출되는 메서드입니다.
    @objc func blockManageSectionTapped() {

        // 스크롤 위치 초기화
        viewManager.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    /// 그룹 관리 섹션을 탭했을 때 호출되는 메서드입니다.
    @objc func groupManageSectionTapped() {
        guard var viewControllers = tabBarController?.viewControllers else {
            return
        }
        
        let manageGroupVC = UINavigationController(rootViewController: ManageGroupViewController())
        viewControllers[1] = manageGroupVC
        tabBarController?.setViewControllers(viewControllers, animated: true)
    }
}

// MARK: - UITableView
extension ManageBlockViewController: UITableViewDataSource, UITableViewDelegate {
    
    /// HeaderView 설정 메서드
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ManageBlockTableViewHeader.headerID) as? ManageBlockTableViewHeader else {
            return UIView()
        }
        
        header.layoutMargins = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
        
        header.blockLabel.text = "\(groupData.list()[section].name)"
        return header
    }
    
    /// FooterView 설정 메서드
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: ManageBlockTableViewFooter.footerID) as? ManageBlockTableViewFooter else {
            return UIView()
        }
        
        // 섹션 정보 저장
        footer.tag = section
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(footerCellTapped))
        footer.addGestureRecognizer(gesture)
        
        return footer
    }
    
    /// Header 높이 값 설정 메서드
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 68
    }
    
    /// Footer 높이 값 설정 메서드
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 64
    }
    
    /// 섹션 개수 값 설정 메서드
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupData.list().count
    }
    
    /// 섹션 안에 들어갈 아이템 개수 값 설정 메서드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let blockList = groupData.list()[section].blockList?.array as? [Block] else { return 0 }
        return blockList.count
    }
    
    /// 개별 셀 설정 메서드
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
    
    /// 셀 선택 시 호출되는 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 셀 클릭 시, 바로 비활성화되는 애니메이션 추가
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// Footer(블럭 추가하기) 탭 시 호출되는 메서드
    @objc func footerCellTapped(_ gesture: UITapGestureRecognizer) {
        guard let footer = gesture.view as? ManageBlockTableViewFooter else { return }
        
        // 관리 중인 섹션 인덱스 업데이트
        let section = footer.tag
        groupData.updateManageIndex(to: section)
        
        // 탭 애니메이션 실행
        UIView.animate(withDuration: 0.05) {
            footer.contentView.backgroundColor = Color.contentsBlock.withAlphaComponent(0.8)
        } completion: { _ in
            UIView.animate(withDuration: 0.4) {
                footer.contentView.backgroundColor = .white
            }
        }
        
        // 섹션에 속한 그룹의 블럭 생성 화면 Push
        let createBlockVC = CreateBlockViewController()
        createBlockVC.hidesBottomBarWhenPushed = true
        createBlockVC.setupCreateMode()
        createBlockVC.configureManageMode()
        navigationController?.pushViewController(createBlockVC, animated: true)
    }
}
