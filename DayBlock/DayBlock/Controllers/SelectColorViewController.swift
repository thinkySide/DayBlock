//
//  SelectColorViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/13.
//

import UIKit

final class SelectColorViewController: UIViewController {
    
    // MARK: - Variable
    
    private let viewManager = SelectColorView()
    
    
    
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
        title = "색상 선택"
    }
    
    func setupDelegate() {
        
    }
}

