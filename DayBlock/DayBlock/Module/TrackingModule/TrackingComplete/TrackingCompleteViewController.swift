//
//  TrackingCompleteViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/23.
//

import UIKit

protocol TrackingCompleteViewControllerDelegate: AnyObject {
    func endTrackingMode()
}

final class TrackingCompleteViewController: UIViewController {
    
    weak var delegate: TrackingCompleteViewControllerDelegate?
    
    // MARK: - Manager
    
    private let viewManager = TrackingCompleteView()
    
    // MARK: - Life Cycle Method
    
    override func loadView() {
        super.loadView()
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEvent()
    }
    
    // MARK: - Setup Method
    
    private func setupEvent() {
        viewManager.backToHomeButton.addTarget(self, action: #selector(backToHomeButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Event Method
    
    @objc func backToHomeButtonTapped() {
        
        // 1. Tracking 모드 해제 및 fillLayer 히든 해제
        delegate?.endTrackingMode()
        
        // 2. dismiss
        dismiss(animated: true)
    }
}
