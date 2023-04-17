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
    private let blockManager = BlockManager()
    private let customBottomModalDelegate = CustomBottomModalDelegate()
    
    
    // MARK: - ViewController LifeCycle
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitial()
        setupNavigion()
        setupDelegate()
        setupAddTarget()
        hideKeyboard()
    }
    
    
    
    // MARK: - Method
    
    func setupInitial() {
        
        /// 기본 블럭 설정
        viewManager.updateBlockInfo(blockManager.creation)
    }
    
    func setupNavigion() {
        title = "블럭 생성"
        navigationController?.navigationBar
            .titleTextAttributes = [.font: UIFont(name: Pretendard.semiBold, size: 16)!]
    }
    
    func setupDelegate() {
        viewManager.taskLabelTextField.textField.delegate = self
        viewManager.groupSelect.delegate = self
        viewManager.colorSelect.delegate = self
        viewManager.iconSelect.delegate = self
    }
    
    func setupAddTarget() {
        let taskLabelTap = UITapGestureRecognizer(target: self, action: #selector(taskLabelTapped))
        viewManager.taskLabelTextField.addGestureRecognizer(taskLabelTap)
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text { viewManager.updateTaskLabel(text) }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text { viewManager.updateTaskLabel(text) }
        textField.resignFirstResponder()
        return true
    }
    
    /// FieldForm 전체 영역 선택 가능
    @objc func taskLabelTapped() {
        viewManager.taskLabelTextField.textField.becomeFirstResponder()
    }
}



// MARK: - SelectFormDelegate

extension AddBlockViewController: SelectFormDelegate {
    
    func groupFormTapped() {
        
        /// 키보드 해제
        viewManager.taskLabelTextField.endEditing(true)
        
        /// present
        let selectGroupVC = SelectGroupViewController()
        selectGroupVC.modalPresentationStyle = .custom
        selectGroupVC.transitioningDelegate = customBottomModalDelegate
        present(selectGroupVC, animated: true)
    }
    
    func iconFormTapped() {
        
        /// 키보드 해제
        viewManager.taskLabelTextField.endEditing(true)
        
        /// present
        let selectIconVC = SelectIconViewController()
        selectIconVC.modalPresentationStyle = .custom
        selectIconVC.transitioningDelegate = customBottomModalDelegate
        present(selectIconVC, animated: true)
    }
    
    func colorFormTapped() {
        
        /// 키보드 해제
        viewManager.taskLabelTextField.endEditing(true)
        
        /// present
        let selectColorVC = SelectColorViewController()
        selectColorVC.modalPresentationStyle = .custom
        selectColorVC.transitioningDelegate = customBottomModalDelegate
        present(selectColorVC, animated: true)
    }
}
