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
        setupDelegate()
        setupAddTarget()
    }
    
    
    
    // MARK: - Initial Method
    
    func setupDelegate() {
        
    }
    
    func setupAddTarget() {
        viewManager.dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    }
    
    
    
    // MARK: - Custom Method
    
    @objc func dismissButtonTapped() {
        dismiss(animated: true)
    }
}
