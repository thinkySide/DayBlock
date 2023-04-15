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
        hideKeyboard()
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
        
        /// 최대 글자수
        let maxString = 18
        
        /// 작성한 글자
        guard let text = textField.text else { return false }
        
        /// Backspace 감지
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 { return true }
        }
        
        /// 최대 글자수 제한
        if (text.count+1) > maxString { return false }
        else { return true }
    }
}



// MARK: - SelectFormDelegate

extension AddBlockViewController: SelectFormDelegate {
    
    func groupFormTapped() {
        let selectGroupVC = SelectGroupViewController()
        let navController = UINavigationController(rootViewController: selectGroupVC)
        present(navController, animated: true)
    }
    
    func iconFormTapped() {
        let selectIconVC = SelectIconViewController()
        let navController = UINavigationController(rootViewController: selectIconVC)
        present(navController, animated: true)
    }
    
    func colorFormTapped() {
        let selectColorVC = SelectColorViewController()
        let navController = UINavigationController(rootViewController: selectColorVC)
        present(navController, animated: true)
    }
}
