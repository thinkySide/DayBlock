//
//  CreateGroupViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/17.
//

import UIKit

final class CreateGroupViewController: UIViewController {
    
    // MARK: - Variable
    
    private let viewManager = CreateGroupView()
    private let blockManager = BlockManager.shared
    weak var delegate: CreateGroupViewControllerDelegate?
    
    
    // MARK: - ViewController LifeCycle
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupDelegate()
        hideKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewManager.groupLabel.textField.becomeFirstResponder()
    }
    
    
    // MARK: - Initial Method
    
    func setupNavigation() {
        
        /// Custom
        title = "새 그룹 생성"
        navigationController?.navigationBar
            .titleTextAttributes = [.font: UIFont(name: Pretendard.semiBold, size: 16)!]
        
        /// 뒤로가기 버튼
        navigationItem.leftBarButtonItem = viewManager.backBarButtonItem
        
        /// 생성 버튼
        navigationItem.rightBarButtonItem = viewManager.createBarButtonItem
    }
    
    func setupDelegate() {
        viewManager.delegate = self
        viewManager.groupLabel.textField.delegate = self
    }
    
    
    
    // MARK: - Custom Method

    
}



// MARK: - UITextFieldDelegate

extension CreateGroupViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        /// 최대 글자수
        let maxString = 8
        
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



// MARK: - CreateGroupViewDelegate

extension CreateGroupViewController: CreateGroupViewDelegate {
    func dismissVC() {
        dismiss(animated: true)
    }
    
    func createGroup() {
        guard let groupName = viewManager.groupLabel.textField.text else { return }
        
        /// 그룹 생성
        // blockManager.createGroup(name: groupName)
        
        /// selectView의 그룹 리스트 업데이트
        delegate?.updateGroupList()
        dismiss(animated: true)
    }
}
