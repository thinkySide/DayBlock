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
        setupNavigion()
        setupDelegate()
    }
    
    
    
    // MARK: - Method
    
    func setupNavigion() {
        
        /// Custom
        title = "그룹 생성"
        navigationController?.navigationBar
            .titleTextAttributes = [.font: UIFont(name: Pretendard.semiBold, size: 16)!]
    }
    
    func setupDelegate() {
        
    }
}
