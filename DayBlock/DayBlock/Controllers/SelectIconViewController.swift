//
//  SelectIconViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/13.
//

import UIKit

final class SelectIconViewController: UIViewController {
    
    // MARK: - Variable
    
    private let viewManager = SelectIconView()
    
    
    
    // MARK: - ViewController LifeCycle
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
    }
    
    
    
    // MARK: - Initial Method
    
    func setupDelegate() {
        viewManager.actionStackView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        viewManager.actionStackView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    
    
    // MARK: - Custom Method
    
    @objc func confirmButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
}
