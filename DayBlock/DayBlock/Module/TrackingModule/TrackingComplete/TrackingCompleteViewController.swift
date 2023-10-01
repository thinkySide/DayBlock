//
//  TrackingCompleteViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/23.
//

import UIKit

final class TrackingCompleteViewController: UIViewController {
    
    // MARK: - Manager
    
    private let viewManager = TrackingCompleteView()
    weak var delegate: TrackingCompleteViewControllerDelegate?
    
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
        delegate?.trackingCompleteVC(backToHomeButtonTapped: self)
        dismiss(animated: true)
    }
}
