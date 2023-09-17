//
//  ListGroupViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/17.
//

import UIKit

final class ListGroupViewController: UIViewController {
    
    // Delegate
    weak var delegate: ListGroupViewControllerDelegate?
    
    // 딜레이를 위한 Dispath아이템
    var workItem: DispatchWorkItem?
    
    private let viewManager = ListGroupView()
    private let blockManager = BlockManager.shared
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupNavigation()
        setupTableView()
    }
    
    // MARK: - Setup Method
    
    private func setupDelegate() {
        viewManager.delegate = self
    }
    
    private func setupNavigation() {
        title = "그룹 리스트"
        navigationController?.navigationBar
            .titleTextAttributes = [.font: UIFont(name: Pretendard.semiBold, size: 16)!]
        
        // Dismiss 버튼
        navigationItem.leftBarButtonItem = viewManager.backBarButtonItem
        
        // 그룹 추가 버튼
        navigationItem.rightBarButtonItem = viewManager.addBarButtonItem
        
        // 뒤로가기 버튼(다음 화면)
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = Color.mainText
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    private func setupTableView() {
        viewManager.groupTableView.dataSource = self
        viewManager.groupTableView.delegate = self
        viewManager.groupTableView.register(SelectGroupTableViewCell.self, forCellReuseIdentifier: Cell.groupSelect)
    }
    
    
    // MARK: - Custom Method
    
    /// 토스트 메시지를 출력하는 메서드
    private func showToast(is active: Bool) {
    
        // 중복 클릭에 의한 불필요한 Dispatch 대기열 삭제
        workItem?.cancel()
        
        // 토스트 활성화
        if active {
            UIView.animate(withDuration: 0.2) { self.viewManager.toastView.alpha = 1 }
            
            // 2초 뒤 비활성화
            workItem = DispatchWorkItem {
                UIView.animate(withDuration: 0.2) { self.viewManager.toastView.alpha = 0 }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: workItem!)
            
            return
        }
        
        // 토스트 비활성화
        if !active {
            UIView.animate(withDuration: 0.2) { self.viewManager.toastView.alpha = 0 }
        }
    }
}


// MARK: - UITableViewDataSource & UITableViewDelegate

extension ListGroupViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockManager.getGroupList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewManager.groupTableView.dequeueReusableCell(withIdentifier: Cell.groupSelect, for: indexPath) as! SelectGroupTableViewCell
        
        // 셀 업데이트
        let groupList = blockManager.getGroupList()
        cell.color.backgroundColor = UIColor(rgb: groupList[indexPath.row].color)
        cell.groupLabel.text = groupList[indexPath.row].name
        cell.countLabel.text = "+\(blockManager.getBlockList(indexPath.row).count)"
        
        // 셀 커스텀
        cell.checkMark.alpha = 0
        cell.chevron.isHidden = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 셀 클릭 시, 바로 비활성화되는 애니메이션 추가
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 첫번째 그룹(그룹없음) 클릭 시, 수정 불가 안내
        if indexPath.row == 0 {
            showToast(is: true)
            return
        }
        
        // 현재 편집중인 그룹 인덱스 업데이트
        blockManager.updateCurrentEditGroupIndex(indexPath.row)
        
        // 토스트 비활성화
        showToast(is: false)
        
        // EditGroupDetailViewController로 Push
        let editGroupDetailVC = EditGroupViewController()
        editGroupDetailVC.delegate = self
        navigationController?.pushViewController(editGroupDetailVC, animated: true)
    }
}


// MARK: - EditGroupViewDelegate

extension ListGroupViewController: ListGroupViewDelegate {
    func dismissVC() {
        dismiss(animated: true)
        delegate?.reloadData()
    }
    
    func addGroup() {
        let createGroupVC = CreateGroupViewController()
        createGroupVC.delegate = self
        navigationController?.pushViewController(createGroupVC, animated: true)
    }
}


// MARK: - EditGroupDetailViewControllerDelegate

extension ListGroupViewController: EditGroupViewControllerDelegate {
    func reloadData() {
        viewManager.groupTableView.reloadData()
    }
}


// MARK: - CreateGroupViewControllerDelegate

extension ListGroupViewController: CreateGroupViewControllerDelegate {
    func updateGroupList() {
        viewManager.groupTableView.reloadData()
    }
}
