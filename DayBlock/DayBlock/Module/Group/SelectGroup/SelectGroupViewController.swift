//
//  SelectGroupViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/13.
//

import UIKit

final class SelectGroupViewController: UIViewController {
    
    /// 그룹 선택 모드
    enum Mode {
        case home
        case create
    }
    
    // MARK: - Variable
    
    private let viewManager = SelectGroupView()
    weak var delegate: SelectGroupViewControllerDelegate?
    
    private let groupData = GroupDataStore.shared
    private let blockData = BlockDataStore.shared
    
    // 그룹 선택 모드
    var mode: Mode = .home
    
    // MARK: - ViewController LifeCycle
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupNavigation()
        setupSelectedCell()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 뒤로 갈 때 다시 HalfModal로 전환
        guard let sheet = navigationController?.sheetPresentationController else { return }
        sheet.animateChanges {
            sheet.detents = [.medium()]
            sheet.selectedDetentIdentifier = .medium
        }
    }
    
    // MARK: - Initial
    
    func setupDelegate() {
        viewManager.groupTableView.dataSource = self
        viewManager.groupTableView.delegate = self
        viewManager.groupTableView.register(ManageGroupTableViewCell.self, forCellReuseIdentifier: Cell.groupSelect)
        viewManager.groupTableView.register(SelectGroupTableViewFooter.self, forHeaderFooterViewReuseIdentifier: SelectGroupTableViewFooter.footerID)
    }
    
    private func setupNavigation() {
        title = "그룹 선택"
        
        // 네비게이션바 스크롤 색상 초기화
        let nbAppearance = UINavigationBarAppearance()
        nbAppearance.configureWithOpaqueBackground()
        nbAppearance.backgroundColor = .white
        nbAppearance.shadowColor = .clear
        nbAppearance.titleTextAttributes = [.font: UIFont(name: Pretendard.semiBold, size: 16)!]
        navigationController?.navigationBar.standardAppearance = nbAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = nbAppearance
        
        // 뒤로가기 버튼 커스텀
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = Color.mainText
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func setupSelectedCell() {
        
        var index = 0
        
        // 모드 스위칭
        switch mode {
        case .home:
            index = groupData.focusIndex()
        case .create:
            index = blockData.remoteIndex
        }
        
        // 리모트 블럭을 현재 선택된 그룹으로 업데이트
        blockData.remoteIndex = groupData.focusIndex()
        
        // 기본 선택값
        let indexPath = IndexPath(row: index, section: 0)
        
        let tableView = viewManager.groupTableView
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
    }
}

// MARK: - UITableView

extension SelectGroupViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupData.list().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewManager.groupTableView.dequeueReusableCell(withIdentifier: Cell.groupSelect, for: indexPath) as! ManageGroupTableViewCell
        
        // 셀 업데이트
        let groupList = groupData.list()
        cell.color.backgroundColor = UIColor(rgb: groupList[indexPath.row].color)
        cell.groupLabel.text = groupList[indexPath.row].name
        cell.countLabel.text = "+\(blockData.listInSelectedGroup(at: indexPath.row).count)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 현재 선택된 indexPath 값으로 블럭 정보 업데이트
        let group = groupData.list()[indexPath.row]
        blockData.updateRemote(group: group)
        blockData.remoteIndex = indexPath.row
        
        // delegate
        delegate?.switchHomeGroup?(index: indexPath.row)
        delegate?.updateGroup?()
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: SelectGroupTableViewFooter.footerID) as? SelectGroupTableViewFooter else {
            return UIView()
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(footerCellTapped))
        footer.addGestureRecognizer(gesture)
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // 헤더 숨기기
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 56
    }
    
    /// Footer(그룹 추가하기) 를 터치했을 때 실행되는 메서드입니다.
    @objc func footerCellTapped(_ gesture: UITapGestureRecognizer) {
        guard let footer = gesture.view as? SelectGroupTableViewFooter else { return }
        
        // 터치 애니메이션
        UIView.animate(withDuration: 0.05) {
            footer.contentView.backgroundColor = Color.contentsBlock.withAlphaComponent(0.8)
        } completion: { _ in
            UIView.animate(withDuration: 0.4) {
                footer.contentView.backgroundColor = .white
            }
        }
        
        // 그룹 생성 ViewController Push
        let createGroupVC = CreateGroupViewController()
        createGroupVC.delegate = self
        
        // Present 세팅
        createGroupVC.screenMode = .navigation
        
        self.navigationController?.pushViewController(createGroupVC, animated: true)
    }
}

// MARK: - CreateGroupViewControllerDelegate

extension SelectGroupViewController: CreateGroupViewControllerDelegate {
    func updateGroupList() {
        
        // 현재 선택된 indexPath 값으로 블럭 정보 업데이트
        let lastIndex = groupData.list().count - 1
        let group = groupData.list()[lastIndex]
        blockData.updateRemote(group: group)
        blockData.remoteIndex = lastIndex
        
        // delegate
        delegate?.switchHomeGroup?(index: lastIndex)
        delegate?.updateGroup?()
        dismiss(animated: true)
    }
}

// MARK: - ListGroupViewControllerDelegate

extension SelectGroupViewController: ManageGroupViewControllerDelegate {
    func reloadData() {
        viewManager.groupTableView.reloadData()
        
        // TableView 선택
        let currentIndex = groupData.focusIndex()
        viewManager.groupTableView.selectRow(at: IndexPath(row: currentIndex, section: 0), animated: false, scrollPosition: .bottom)
    }
}
