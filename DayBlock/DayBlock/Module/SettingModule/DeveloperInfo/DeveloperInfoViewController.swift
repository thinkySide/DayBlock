//
//  DeveloperInfoViewController.swift
//  DayBlock
//
//  Created by 김민준 on 12/19/23.
//

import UIKit

final class DeveloperInfoViewController: UIViewController {
    
    private let viewManager = DeveloperInfoView()
    
    // MARK: - ViewController LifeCycle
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
    // MARK: - Setup Method
    private func setupNavigation() {
        title = "개발자 정보"
        navigationController?.navigationBar
            .titleTextAttributes = [.font: UIFont(name: Pretendard.semiBold, size: 16)!]
    }
}
