//
//  CreateGroupViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/17.
//

import UIKit

final class CreateGroupViewController: UIViewController {
    
    // MARK: - Variable
    
    private let viewManager = CreateGroupView()
    
    
    
    // MARK: - ViewController LifeCycle
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupDelegate()
        setupAddTarget()
    }
    
    
    
    // MARK: - Initial Method
    
    func setupNavigation() {
        
        /// Custom
        title = "새 그룹 생성"
        navigationController?.navigationBar
            .titleTextAttributes = [.font: UIFont(name: Pretendard.semiBold, size: 16)!]
        
        /// 뒤로가기 버튼
        navigationItem.leftBarButtonItem = viewManager.backBarButtonItem
    }
    
    func setupDelegate() {
        viewManager.delegate = self
    }
    
    func setupAddTarget() {
        
    }
    
    
    
    // MARK: - Custom Method

    
}



// MARK: - CreateGroupViewDelegate

extension CreateGroupViewController: CreateGroupViewDelegate {
    func dismissVC() {
        dismiss(animated: true)
    }
}
