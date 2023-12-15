//
//  FirstOnboardingViewController.swift
//  DayBlock
//
//  Created by 김민준 on 12/15/23.
//

import UIKit

final class FirstOnboardingViewController: UIViewController {
    
    private let viewManager = FirstOnboardingView()
    
    // MARK: - ViewController LifeCycle
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEvent()
    }
    
    // MARK: - Setup Method
    private func setupEvent() {
        
    }
}
