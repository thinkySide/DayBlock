//
//  AddBlockViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/07.
//

import UIKit

final class CreateBlockViewController: UIViewController {
    
    /// 블럭 편집 모드
    enum BlockEditMode {
        case create
        case update
    }
    
    // MARK: - Variable
    
    private let viewManager = CreateBlockView()
    private let blockManager = BlockManager.shared
    private let customBottomModalDelegate = CustomBottomModalDelegate()
    weak var delegate: CreateBlockViewControllerDelegate?
    
    /// 블럭 편집 모드
    private var blockEditMode: BlockEditMode = .create {
        didSet {
            if blockEditMode == .create { title = "블럭 생성" }
            if blockEditMode == .update { title = "블럭 편집" }
        }
    }
    
    /// 편집하기 전 처음 블럭명
    private var originalBlockName = ""
    
    
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
        setupNotification()
        hideKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.reloadCollectionView()
    }
    
    deinit {
        blockManager.resetRemoteBlock()
    }
    
    
    
    // MARK: - Initial Method
    
    /// 블럭 생성 모드로 기본 설정 진행
    func setupCreateMode() {
        blockEditMode = .create
    }
    
    /// 블럭 편집 모드로 기본 설정 진행
    func setupEditMode() {
        blockEditMode = .update
        
        // UI 업데이트
        let taskLabel = blockManager.getRemoteBlock().list[0].taskLabel
        viewManager.taskLabelTextField.textField.text = taskLabel
        viewManager.taskLabelTextField.countLabel.text = "\(taskLabel.count)/18"
        viewManager.createBarButtonItem.isEnabled = true
        
        // 편집 중인 블럭명 저장
        originalBlockName = taskLabel
    }
    
    func setupInitial() {
        
        // 1. 현재 그룹을 기준으로 리모트 블럭 업데이트
        blockManager.updateRemoteBlock(group: blockManager.getCurrentGroup())
        
        // 2. 리모트 블럭을 기준으로 블럭 UI 업데이트
        viewManager.updateBlockInfo(blockManager.getRemoteBlock())
        
        // 리모트 그룹 인덱스 업데이트
        blockManager.remoteBlockGroupIndex = blockManager.getCurrentGroupIndex()
    }
    
    func setupNavigion() {
        
        // Custom
        navigationController?.navigationBar
            .titleTextAttributes = [.font: UIFont(name: Pretendard.semiBold, size: 16)!]
        
        // 생성 버튼
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
    
    /// Notification 등록
    private func setupNotification() {
        
        // 블럭 삭제 observer
        NotificationCenter.default.addObserver(self, selector: #selector(updateForGroupChanged), name: NSNotification.Name(Noti.updateCreateBlockUI), object: nil)
    }
    
    
    
    // MARK: - Custom Method
    
    @objc func createBarButtonItemTapped() {
        
        // 블럭 생성 모드
        if blockEditMode == .create {
            blockManager.createNewBlock()
            navigationController?.popViewController(animated: true)
            delegate?.updateCollectionView(false)
        }
        
        // 블럭 편집 모드
        if blockEditMode == .update {
            blockManager.updateBlock()
            navigationController?.popViewController(animated: true)
            delegate?.updateCollectionView(true)
        }
    }
    
    /// 그룹 업데이트 시 실행되는 Notification
    @objc func updateForGroupChanged(_ notification: Notification) {
        
        // 편집된 그룹이 현재 선택되어있는 그룹일 경우에만 UI 업데이트 할 것.
        let editGroup = blockManager.getCurrentEditGroupIndex()
        let selectGroup = blockManager.getCurrentGroupIndex()
        if editGroup == selectGroup { setupInitial() }
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
        
        // 리모트 블럭 업데이트
        blockManager.updateRemoteBlock(label: text)
        
        // 라벨 실시간 업데이트
        viewManager.updateTaskLabel(text)
        
        // 글자수 현황 업데이트
        viewManager.taskLabelTextField.countLabel.text = "\(text.count)/18"
        
        // 동일한 작업명의 블럭 생성 막기
        checkSameBlock()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /// FieldForm 전체 영역 선택 가능
    @objc func taskLabelTapped() {
        viewManager.taskLabelTextField.textField.becomeFirstResponder()
    }
    
    /// 그룹 내 동일한 작업명의 블럭 확인
    private func checkSameBlock() {
        
        // 그룹 내 동일 작업명 블럭 확인
        if let groupName = viewManager.groupSelect.selectLabel.text {
            for block in blockManager.getBlockList(groupName) {
                
                let currentGroupIndex = blockManager.getCurrentGroupIndex()
                let remoteBlockGroupIndex = blockManager.remoteBlockGroupIndex
                let remoteBlockLabel = blockManager.getRemoteBlock().list[0].taskLabel
                
                // 1. 최상위 그룹과 현재 그룹이 다를 때
                if currentGroupIndex != remoteBlockGroupIndex {
                    //print("최상위 그룹과 현재 그룹이 다르군")
                    
                    // 2. 현재 그룹 블럭 작업명과 동일한 작업명 있는지 확인
                    if block.taskLabel == remoteBlockLabel {
                        //print("동일한 블럭 찾았음!")
                        viewManager.createBarButtonItem.isEnabled = false
                        viewManager.taskLabelTextField.isWarningLabelEnabled(true)
                        return
                    }
                }
                
                // 1. 최상위 그룹과 현재 그룹이 같을 때
                else {
                    //print("최상위 그룹과 현재 그룹이 같군")
                    
                    // 2. 현재 그룹 블럭 작업명이 오리지날 작업명과 다른지 확인
                    if remoteBlockLabel != originalBlockName {
                        //print("원래 작업명과 달라졌네? 다른 블럭 중에 같은 블럭이 있나?")
                        
                        // 3. 현재 그룹 블럭 작업명과 동일한 작업명 있는지 확인
                        if block.taskLabel == remoteBlockLabel {
                            //print("다른 블럭 중에도 같은 녀석이 있군")
                            viewManager.createBarButtonItem.isEnabled = false
                            viewManager.taskLabelTextField.isWarningLabelEnabled(true)
                            return
                        }
                    }
                }
            }
            
            // 동일 블럭 없을 시 정상 진행
            if let text = viewManager.taskLabelTextField.textField.text {
                viewManager.createBarButtonItem.isEnabled = text.isEmpty ? false : true
                viewManager.taskLabelTextField.isWarningLabelEnabled(false)
            }
        }
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
        
        // 그룹 선택 모드 변경
        selectGroupVC.mode = .create
        
        if #available(iOS 15.0, *) {
            selectGroupVC.modalPresentationStyle = .pageSheet
            if let sheet = selectGroupVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            }
        } else {
            selectGroupVC.modalPresentationStyle = .custom
            selectGroupVC.transitioningDelegate = customBottomModalDelegate
        }
        
        present(selectGroupVC, animated: true)
    }
    
    func iconFormTapped() {
        
        /// 키보드 해제
        viewManager.taskLabelTextField.endEditing(true)
        
        /// present
        let selectIconVC = SelectIconViewController()
        selectIconVC.delegate = self
        
        // Half-Modal 설정
        if #available(iOS 15.0, *) {
            selectIconVC.modalPresentationStyle = .pageSheet
            if let sheet = selectIconVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            }
        } else {
            selectIconVC.modalPresentationStyle = .custom
            selectIconVC.transitioningDelegate = customBottomModalDelegate
        }
        
        SymbolManager.shared.updateCurrentIndex(currentIcon: blockManager.getRemoteBlock().list[0].icon)
        
        present(selectIconVC, animated: true)
    }
}



// MARK: - Update Block Info

extension CreateBlockViewController: SelectGroupViewControllerDelegate, SelectIconViewControllerDelegate {
    
    /// SelectGroupViewControllerDelegate
    func updateGroup() {
        
        // 그룹명 업데이트
        viewManager.groupSelect.selectLabel.text = blockManager.getRemoteBlockGroupName()
        
        // 그룹 컬러 업데이트
        let color = blockManager.getRemoteBlockGroupColor()
        viewManager.groupSelect.selectColor.backgroundColor = color
        viewManager.updateColorTag(color)
        
        // 그룹 내 동일 작업명 블럭 확인
        checkSameBlock()
    }
    
    /// SelectIconViewControllerDelegate
    func updateIcon() {
        
        // 아이콘 업데이트
        let icon = blockManager.getRemoteBlockIcon()
        viewManager.iconSelect.selectIcon.image = icon
        viewManager.updateIcon(icon)
    }
}
