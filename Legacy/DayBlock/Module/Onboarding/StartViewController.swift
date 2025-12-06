//
//  StartViewController.swift
//  DayBlock
//
//  Created by 김민준 on 12/15/23.
//

import UIKit

final class StartViewController: UIViewController {
    
    private let viewManager = StartView()
    
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
        viewManager.startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Event Method
    @objc func startButtonTapped() {
        Vibration.selection.vibrate()
        let onboardingVC = OnboardingViewController(mode: .onboarding)
        onboardingVC.modalPresentationStyle = .fullScreen
        present(onboardingVC, animated: true)
    }
}
