//
//  AddBlockViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/07.
//

import UIKit

final class CreateBlockViewController: UIViewController {
    
    /// 블럭 편집 모드
    enum Mode {
        case create
        case edit
        case manageCreate
        case manageEdit
    }
    
    // MARK: - Variable
    
    private let viewManager = CreateBlockView()
    private let customBottomModalDelegate = BottomModalDelegate()
    weak var delegate: CreateBlockViewControllerDelegate?
    
    private let groupData = GroupDataStore.shared
    private let blockData = BlockDataStore.shared
    
    /// 블럭 편집 모드
    private var mode: Mode = .create {
        didSet {
            if mode == .create || mode == .manageCreate {
                title = "블럭 생성"
            }
            
            if mode == .edit || mode == .manageEdit {
                title = "블럭 편집"
            }
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
        setupNavigation()
        setupDelegate()
        setupAddTarget()
        setupNotification()
        addHideKeyboardGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        view.endEditing(true)
    }
    
    deinit {
        blockData.resetRemote()
    }
    
    // MARK: - Initial Method
    
    /// 블럭 생성 모드로 기본 설정 진행
    func setupCreateMode() {
        mode = .create
        viewManager.deleteButton.alpha = 0
    }
    
    /// 블럭 편집 모드로 기본 설정 진행
    func configureEditMode() {
        mode = .edit
        
        // UI 업데이트
        let taskLabel = blockData.remote().list[0].taskLabel
        viewManager.taskLabelTextField.textField.text = taskLabel
        viewManager.taskLabelTextField.countLabel.text = "\(taskLabel.count)/18"
        viewManager.createBarButtonItem.isEnabled = true
        
        // 편집 중인 블럭명 저장
        originalBlockName = taskLabel
    }
    
    /// 블럭 관리 생성 모드로 기본 설정 진행
    func configureManageCreateMode() {
        mode = .manageCreate
        viewManager.deleteButton.alpha = 0
    }
    
    /// 블럭 관리 생성 모드로 기본 설정 진행
    func configureManageEditMode() {
        mode = .manageEdit
        
        // UI 업데이트
        let taskLabel = blockData.remote().list[0].taskLabel
        viewManager.taskLabelTextField.textField.text = taskLabel
        viewManager.taskLabelTextField.countLabel.text = "\(taskLabel.count)/18"
        viewManager.createBarButtonItem.isEnabled = true
        
        // 편집 중인 블럭명 저장
        originalBlockName = taskLabel
    }
    
    func setupInitial() {
        
        // 매니지모드에서 실행되는 것이라면 섹션값을 기준으로 실행
        if mode == .manageCreate || mode == .manageEdit {
            let sectionIndex = groupData.manageIndex()
            blockData.updateRemote(group: groupData.list()[sectionIndex])
            viewManager.updateBlockInfo(blockData.remote())
            blockData.remoteIndex = sectionIndex
            return
        }
        
        // 1. 현재 그룹을 기준으로 리모트 블럭 업데이트
        blockData.updateRemote(group: groupData.focusEntity())
        
        // 2. 리모트 블럭을 기준으로 블럭 UI 업데이트
        viewManager.updateBlockInfo(blockData.remote())
        
        // 3. 리모트 그룹 인덱스 업데이트
        blockData.remoteIndex = groupData.focusIndex()
    }
    
    func setupNavigation() {
        
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
        
        // taskLabelTextField - Tap Event
        let taskLabelTap = UITapGestureRecognizer(target: self, action: #selector(taskLabelTapped))
        viewManager.taskLabelTextField.addGestureRecognizer(taskLabelTap)
        
        // taskLabelTextField - EditingChanged Event
        viewManager.taskLabelTextField.textField
            .addTarget(self, action: #selector(taskLabelTextFieldChanged), for: .editingChanged)
        
        // deleteButton
        viewManager.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        // createBarButtonItem
        viewManager.createBarButtonItem.target = self
        viewManager.createBarButtonItem.action = #selector(createBarButtonItemTapped)
    }
    
    /// Notification 등록
    private func setupNotification() {
        
        // 블럭 삭제 observer
        NotificationCenter.default.addObserver(self, selector: #selector(updateForGroupChanged), name: .updateCreateBlockUI, object: nil)
    }
    
    // MARK: - Custom Method
    
    @objc func createBarButtonItemTapped() {
        
        // 블럭 생성 모드
        if mode == .create {
            blockData.create()
            navigationController?.popViewController(animated: true)
            delegate?.createBlockViewController(self, blockDidCreate: .create)
        }
        
        // 블럭 편집 모드
        if mode == .edit {
            blockData.update()
            navigationController?.popViewController(animated: true)
            delegate?.createBlockViewController(self, blockDidEdit: .edit)
        }
        
        // 블럭 관리 생성 모드
        if mode == .manageCreate {
            blockData.createForManageMode()
            navigationController?.popViewController(animated: true)
        }
        
        // 블럭 관리 편집 모드
        if mode == .manageEdit {
            blockData.updateForManageMode()
            navigationController?.popViewController(animated: true)
        }
    }
    
    /// 그룹 업데이트 시 실행되는 Notification
    @objc func updateForGroupChanged(_ notification: Notification) {
        
        // 편집된 그룹이 현재 선택되어있는 그룹일 경우에만 UI 업데이트 할 것.
        let editGroup = groupData.editIndex()
        let selectGroup = groupData.focusIndex()
        if editGroup == selectGroup { setupInitial() }
    }
    
    /// 삭제 버튼 탭 시 실행되는 메서드
    @objc func deleteButtonTapped() {
        let deletePopup = PopupViewController()
        deletePopup.delegate = self
        deletePopup.deletePopupView.mainLabel.text = "블럭을 삭제할까요?"
        deletePopup.deletePopupView.subLabel.text = "블럭의 정보가 모두 삭제돼요"
        deletePopup.modalPresentationStyle = .overCurrentContext
        deletePopup.modalTransitionStyle = .crossDissolve
        view.endEditing(true)
        self.present(deletePopup, animated: true)
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
        
        DispatchQueue.main.async {
            
            // 리모트 블럭 업데이트
            self.blockData.updateRemoteBlock(label: text)
            
            // 라벨 실시간 업데이트
            self.viewManager.updateTaskLabel(text)
            
            // 글자수 현황 업데이트
            self.viewManager.taskLabelTextField.countLabel.text = "\(text.count)/18"
            
            // 동일한 작업명의 블럭 생성 막기
            self.checkSameBlock()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /// FieldForm 전체 영역 선택 가능
    @objc func taskLabelTapped() {
        DispatchQueue.main.async {
            self.viewManager.taskLabelTextField.textField.becomeFirstResponder()
        }
    }
    
    /// 그룹 내 동일한 작업명의 블럭 확인
    private func checkSameBlock() {
        
        // 그룹 내 동일 작업명 블럭 확인
        if let groupName = viewManager.groupSelect.selectLabel.text {
            for block in blockData.listInSelectedGroup(with: groupName) {
                
                // 일반 편집 & 관리 편집 모드 구분
                let currentGroupIndex = mode == .edit ? groupData.focusIndex() : groupData.manageIndex()
                let remoteBlockGroupIndex = blockData.remoteIndex
                let remoteBlockLabel = blockData.remote().list[0].taskLabel
                
                // 1. 최상위 그룹과 현재 그룹이 다를 때
                if currentGroupIndex != remoteBlockGroupIndex {
                    
                    // 2. 현재 그룹 블럭 작업명과 동일한 작업명 있는지 확인
                    if block.taskLabel == remoteBlockLabel {
                        viewManager.createBarButtonItem.isEnabled = false
                        viewManager.taskLabelTextField.isWarningLabelEnabled(true)
                        return
                    }
                }
                
                // 1. 최상위 그룹과 현재 그룹이 같을 때
                else {
                    
                    // 2. 현재 그룹 블럭 작업명이 오리지날 작업명과 다른지 확인
                    if remoteBlockLabel != originalBlockName {
                        
                        // 3. 현재 그룹 블럭 작업명과 동일한 작업명 있는지 확인
                        if block.taskLabel == remoteBlockLabel {
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

extension CreateBlockViewController: FormSelectButtonDelegate {
    
    func groupFormTapped() {
        
        /// 키보드 해제
        viewManager.taskLabelTextField.endEditing(true)
        
        /// present
        let selectGroupVC = SelectGroupViewController()
        selectGroupVC.delegate = self
        let navigationController = UINavigationController(rootViewController: selectGroupVC)
        
        // 그룹 선택 모드 변경
        selectGroupVC.mode = .create
        
        if #available(iOS 15.0, *) {
            if let sheet = navigationController.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.preferredCornerRadius = 30
            }
        } else {
            navigationController.modalPresentationStyle = .custom
            navigationController.transitioningDelegate = customBottomModalDelegate
        }
        
        present(navigationController, animated: true)
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
        
        IconManager.shared.updateSelectedIndex(as: blockData.remote().list[0].icon)
        
        present(selectIconVC, animated: true)
    }
}

// MARK: - Update Block Info

extension CreateBlockViewController: SelectGroupViewControllerDelegate, SelectIconViewControllerDelegate {
    
    /// SelectGroupViewControllerDelegate
    func updateGroup() {
        
        // 그룹명 업데이트
        viewManager.groupSelect.selectLabel.text = blockData.remote().name
        
        // 그룹 컬러 업데이트
        let color = blockData.remoteColor()
        viewManager.groupSelect.selectColor.backgroundColor = color
        viewManager.updateColorTag(color)
        
        // 그룹 내 동일 작업명 블럭 확인
        checkSameBlock()
    }
    
    /// SelectIconViewControllerDelegate
    func updateIcon() {
        
        // 아이콘 업데이트
        let icon = blockData.remoteBlockIcon()
        viewManager.iconSelect.selectIcon.image = icon
        viewManager.updateIcon(icon)
    }
}

// MARK: - PopupViewControllerDelegate
extension CreateBlockViewController: PopupViewControllerDelegate {
    func confirmButtonTapped() {
        
        // 일반 편집 모드 일 때
        if mode == .edit {
            
            // 실제 블럭 데이터 삭제 메서드(코어데이터)
            let deleteBlock = blockData.focusEntity()
            blockData.delete(deleteBlock)
            
            // Order 값 업데이트
            blockData.updateOrder()
            
            // 델리게이트로 HomeViewController의 컬렉션 뷰 리로드
            delegate?.createBlockViewController(self, blockDidDelete: mode)
        }
        
        // 관리 모드 편집 모드 일 때
        else if mode == .manageEdit {
            
            // 블럭 데이터 삭제(코어데이터)
            let deleteBlock = blockData.manageEntity()
            blockData.delete(deleteBlock)
            
            // Order 값 업데이트aΩ
            blockData.updateOrderForManageMode()
            
            // 만약 포커스 그룹의 마지막 인덱스를 삭제한다면
            // 포커스 인덱스 값 업데이트(블럭 리스트의 count를 기준으로)
            let lastIndex = blockData.listInSelectedGroup(at: groupData.focusIndex()).count
            
            print("마지막 인덱스: \(lastIndex)")
            
            if groupData.manageIndex() == groupData.focusIndex() &&
                blockData.focusIndex() - 1 == lastIndex {
                
                print("인덱스 업데이트")
                blockData.updateFocusIndex(to: lastIndex)
            }
        }
        
        // 이전 화면으로 돌아가기
        navigationController?.popViewController(animated: true)
    }
}
