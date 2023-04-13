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
        setupNavigion()
        setupDelegate()
    }
    
    
    
    // MARK: - Method
    
    func setupNavigion() {
        title = "블럭 생성"
    }
    
    func setupDelegate() {
        viewManager.taskLabelTextField.textField.delegate = self
        viewManager.groupSelect.delegate = self
        viewManager.colorSelect.delegate = self
        viewManager.iconSelect.delegate = self
    }
}



// MARK: - UITextFieldDelegate

extension AddBlockViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 붙여넣기도 막아야함! ⭐️⭐️⭐️
        
        let maxString = 18
        guard let count = textField.text?.count else { return false }
        
        /// Backspace 감지
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 { return true }
        }
        
        /// 최대 글자수 제한
        if (count+1) > maxString { return false }
        else { return true }
    }
}



// MARK: - SelectFormDelegate

extension AddBlockViewController: SelectFormDelegate {
    
    func groupFormTapped() {
        let selectGroupVC = SelectGroupViewController()
        present(selectGroupVC, animated: true)
    }
    
    func iconFormTapped() {
        print(#function)
    }
    
    func colorFormTapped() {
        print(#function)
    }
}
