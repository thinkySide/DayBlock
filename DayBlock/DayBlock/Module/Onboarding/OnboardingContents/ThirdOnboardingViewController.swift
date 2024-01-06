//
//  ThirdOnboardingViewController.swift
//  DayBlock
//
//  Created by 김민준 on 12/15/23.
//

import UIKit

final class ThirdOnboardingViewController: UIViewController {
    
    var mode: OnboardingViewController.Mode
    
    private let viewManager = ThirdOnboardingView()
    
    // MARK: - ViewController LifeCycle
    init(mode: OnboardingViewController.Mode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
