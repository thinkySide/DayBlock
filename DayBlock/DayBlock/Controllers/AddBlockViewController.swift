//
//  AddBlockViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/07.
//

import UIKit

final class AddBlockViewController: UIViewController {
    
    // MARK: - Variable
    
    private let viewManager = AddBlockView()
    
    
    
    // MARK: - ViewController LifeCycle
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitial()
    }
    
    
    
    // MARK: - Method
    
    func setupInitial() {
        title = "블럭 추가"
    }
}
