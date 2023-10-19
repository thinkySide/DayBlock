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
    private let customBottomModalDelegate = BottomModalDelegate()
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
        setupGesture()
        setupSelectedCell()
    }
    
    // MARK: - Initial
    
    func setupDelegate() {
        viewManager.groupTableView.dataSource = self
        viewManager.groupTableView.delegate = self
        viewManager.groupTableView.register(ListGroupTableViewCell.self, forCellReuseIdentifier: Cell.groupSelect)
    }
    
    func setupGesture() {
        viewManager.menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        viewManager.actionStackView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        viewManager.actionStackView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        // Menu Gesture
        let createGroupGesture = UITapGestureRecognizer(target: self, action: #selector(createGroupMenuTapped))
        viewManager.customUIMenu.firstItem.addGestureRecognizer(createGroupGesture)
        
        let editGroupGesture = UITapGestureRecognizer(target: self, action: #selector(editGroupMenuTapped))
        viewManager.customUIMenu.secondItem.addGestureRecognizer(editGroupGesture)
        
        // Menu Background Gesture
        let backgroundGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        viewManager.backgroundView.addGestureRecognizer(backgroundGesture)
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
        
        // 마지막 인덱스 선택 시, 화면에서 가려지기 때문에 scrollPosition Bottom으로
        let tableView = viewManager.groupTableView
        if index == groupData.list().count - 1 {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .bottom)
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
        } else {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
        }
    }
    
    // MARK: - Method
    
    @objc func confirmButtonTapped() {
        
        guard let indexPath = viewManager.groupTableView.indexPathForSelectedRow else { return }
        let group = groupData.list()[indexPath.row]
        
        // 현재 선택된 indexPath 값으로 블럭 정보 업데이트
        blockData.updateRemote(group: group)
        blockData.remoteIndex = indexPath.row
        
        // delegate
        delegate?.switchHomeGroup?(index: indexPath.row)
        delegate?.updateGroup?()
        dismiss(animated: true)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    /// CustomUIMenu를 애니메이션과 함께 출력합니다.
    @objc func menuButtonTapped() {
        UIView.animate(withDuration: 0.2) {
            let menu = self.viewManager.customUIMenu
            let background = self.viewManager.backgroundView
            menu.alpha = menu.alpha == 1 ? 0 : 1
            background.alpha = background.alpha == 1 ? 0 : 1
        }
    }
    
    /// CustomUIMenu 활성화시 같이 표시되는 투명한 View Tap Event 메서드입니다.
    @objc func backgroundTapped() {
        menuButtonTapped()
    }
    
    @objc func createGroupMenuTapped() {
        let createGroupVC = CreateGroupViewController()
        createGroupVC.delegate = self
        
        // Present 세팅
        createGroupVC.setupBackButton()
        createGroupVC.screenMode = .present
        
        let navController = UINavigationController(rootViewController: createGroupVC)
        navController.modalPresentationStyle = .overFullScreen
        present(navController, animated: true)
        
        // 다시 메뉴 가리기
        menuButtonTapped()
    }
    
    @objc func editGroupMenuTapped() {
        let editGroupVC = ListGroupViewController()
        editGroupVC.delegate = self
        let navController = UINavigationController(rootViewController: editGroupVC)
        navController.modalPresentationStyle = .overFullScreen
        present(navController, animated: true)
        
        // 다시 메뉴 가리기
        menuButtonTapped()
    }
}

// MARK: - UITableView

extension SelectGroupViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupData.list().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewManager.groupTableView.dequeueReusableCell(withIdentifier: Cell.groupSelect, for: indexPath) as! ListGroupTableViewCell
        
        /// 셀 업데이트
        let groupList = groupData.list()
        cell.color.backgroundColor = UIColor(rgb: groupList[indexPath.row].color)
        cell.groupLabel.text = groupList[indexPath.row].name
        cell.countLabel.text = "+\(blockData.listInSelectedGroup(at: indexPath.row).count)"
        
        return cell
    }
}

// MARK: - CreateGroupViewControllerDelegate

extension SelectGroupViewController: CreateGroupViewControllerDelegate {
    func updateGroupList() {
        let lastIndex = groupData.list().count - 1
        viewManager.groupTableView.reloadData()
        viewManager.groupTableView.selectRow(at: IndexPath(row: lastIndex, section: 0), animated: false, scrollPosition: .bottom)
    }
}

// MARK: - ListGroupViewControllerDelegate

extension SelectGroupViewController: ListGroupViewControllerDelegate {
    func reloadData() {
        viewManager.groupTableView.reloadData()
        
        // TableView 선택
        let currentIndex = groupData.focusIndex()
        viewManager.groupTableView.selectRow(at: IndexPath(row: currentIndex, section: 0), animated: false, scrollPosition: .bottom)
    }
}
