//
//  AddBlockViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/07.
//

import UIKit

final class CreateBlockViewController: UIViewController {
    
    // MARK: - Variable
    
    private let viewManager = CreateBlockView()
    private let blockManager = BlockManager.shared
    private let customBottomModalDelegate = CustomBottomModalDelegate()
    weak var delegate: CreateBlockViewControllerDelegate?
    
    
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

    deinit {
        blockManager.resetRemoteBlock()
    }
    
    
    
    // MARK: - Initial Method
    
    func setupInitial() {
        
        /// 기본 블럭 설정
        blockManager.updateRemoteBlock(group: blockManager.getCurrentGroup())
        viewManager.updateBlockInfo(blockManager.getRemoteBlock())
    }
    
    func setupNavigion() {
        
        /// Custom
        title = "블럭 생성"
        navigationController?.navigationBar
            .titleTextAttributes = [.font: UIFont(name: Pretendard.semiBold, size: 16)!]
        
        /// 생성 버튼
        navigationItem.rightBarButtonItem = viewManager.createBarButtonItem
    }
    
    func setupDelegate() {
        viewManager.taskLabelTextField.textField.delegate = self
        viewManager.groupSelect.delegate = self
        viewManager.iconSelect.delegate = self
    }
    
    func setupAddTarget() {
        
        /// taskLabelTextField - Tap Event
        let taskLabelTap = UITapGestureRecognizer(target: self, action: #selector(taskLabelTapped))
        viewManager.taskLabelTextField.addGestureRecognizer(taskLabelTap)
        
        /// taskLabelTextField - EditingChanged Event
        viewManager.taskLabelTextField.textField.addTarget(self, action: #selector(taskLabelTextFieldChanged), for: .editingChanged)
        
        /// createBarButtonItem
        viewManager.createBarButtonItem.target = self
        viewManager.createBarButtonItem.action = #selector(createBarButtonItemTapped)
    }
    
    
    
    // MARK: - Custom Method
    
    @objc func createBarButtonItemTapped() {
        
        /// 새 블럭 생성
        blockManager.createNewBlock()
        navigationController?.popViewController(animated: true)
        delegate?.updateCollectionView()
    }
}



// MARK: - UITextFieldDelegate

extension CreateBlockViewController: UITextFieldDelegate {
    
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
    
    @objc func taskLabelTextFieldChanged() {
        guard let text = viewManager.taskLabelTextField.textField.text else { return }
        
        /// text 있을 때만 완료 버튼 활성화
        viewManager.createBarButtonItem.isEnabled = text.isEmpty ? false : true
        
        /// 리모트 블럭 업데이트
        blockManager.updateRemoteBlock(label: text)
        
        /// 라벨 실시간 업데이트
        viewManager.updateTaskLabel(text)
        
        /// 글자수 현황 업데이트
        viewManager.taskLabelTextField.countLabel.text = "\(text.count)/18"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /// FieldForm 전체 영역 선택 가능
    @objc func taskLabelTapped() {
        viewManager.taskLabelTextField.textField.becomeFirstResponder()
    }
}



// MARK: - SelectFormDelegate

extension CreateBlockViewController: SelectFormDelegate {
    
    func groupFormTapped() {
        
        /// 키보드 해제
        viewManager.taskLabelTextField.endEditing(true)
        
        /// present
        let selectGroupVC = SelectGroupViewController()
        selectGroupVC.delegate = self
        selectGroupVC.modalPresentationStyle = .custom
        selectGroupVC.transitioningDelegate = customBottomModalDelegate
        present(selectGroupVC, animated: true)
    }
    
    func iconFormTapped() {
        
        /// 키보드 해제
        viewManager.taskLabelTextField.endEditing(true)
        
        /// present
        let selectIconVC = SelectIconViewController()
        selectIconVC.delegate = self
        selectIconVC.modalPresentationStyle = .custom
        selectIconVC.transitioningDelegate = customBottomModalDelegate
        present(selectIconVC, animated: true)
    }
}



// MARK: - Update Block Info

extension CreateBlockViewController: SelectGroupViewControllerDelegate, SelectIconViewControllerDelegate {
    
    /// SelectGroupViewControllerDelegate
    func updateGroup() {
        
        /// 그룹명 업데이트
        viewManager.groupSelect.selectLabel.text = blockManager.getRemoteBlockGroupName()
        
        /// 그룹 컬러 업데이트
        let color = blockManager.getRemoteBlockGroupColor()
        viewManager.groupSelect.selectColor.backgroundColor = color
        viewManager.updateColorTag(color)
    }
    
    /// SelectIconViewControllerDelegate
    func updateIcon() {
        
        /// 아이콘 업데이트
        let icon = blockManager.getRemoteBlockIcon()
        viewManager.iconSelect.selectIcon.image = icon
        viewManager.updateIcon(icon)
    }
}
