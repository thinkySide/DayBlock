//
//  ViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/03/31.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - Object
    
    private let viewManager = HomeView()
    

    // MARK: - ViewController LifeCycle
    
    override func loadView() {
        super.loadView()
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitial()
    }
    
    
    
    // MARK: - Method
    
    func setupInitial() {
        // title = "자기계발"
    }

}

