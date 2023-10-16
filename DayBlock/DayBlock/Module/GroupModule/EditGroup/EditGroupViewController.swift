//
//  EditGroupViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/17.
//

import UIKit

final class EditGroupViewController: UIViewController {
    
    weak var delegate: EditGroupViewControllerDelegate?
    
    private let viewManager = EditGroupDetailView()
    private let colorManager = ColorManager.shared
    private let customBottomModalDelegate = BottomModalDelegate()
    
    private let groupData = GroupDataStore.shared
    private let blockData = BlockDataStore.shared
    
    /// 기존 그룹명 저장용
    private var initialGroupName = ""
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupUI()
        setupDelegate()
        setupEvent()
        setupRemoteGroup()
        addHideKeyboardGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        // Remote 그룹 초기화
        groupData.resetRemote()
    }

    // MARK: - SETUP METHOD
    
    private func setupUI() {
        let group = groupData.list()
        let currentIndex = groupData.editIndex()
        
        viewManager.groupLabelTextField.textField.text = "\(group[currentIndex].name)"
        viewManager.groupLabelTextField.countLabel.text = "\(group[currentIndex].name.count)/8"
        viewManager.colorSelect.selectColor.backgroundColor = UIColor(rgb: group[currentIndex].color)
        
        initialGroupName = "\(group[currentIndex].name)"
    }
    
    private func setupNavigation() {
        
        title = "그룹 편집"
        navigationController?.navigationBar
            .titleTextAttributes = [.font: UIFont(name: Pretendard.semiBold, size: 16)!]
        
        // 생성 버튼
        navigationItem.rightBarButtonItem = viewManager.createBarButtonItem
    }
    
    private func setupDelegate() {
        viewManager.delegate = self
        viewManager.colorSelect.delegate = self
        viewManager.groupLabelTextField.textField.delegate = self
    }
    
    private func setupEvent() {
        viewManager.groupLabelTextField.textField.addTarget(self, action: #selector(groupLabelTextFieldChanged), for: .editingChanged)
        viewManager.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    private func setupRemoteGroup() {
        let group = groupData.list()
        let currentIndex = groupData.editIndex()
        
        groupData.updateRemote(name: "\(group[currentIndex].name)")
        groupData.updateRemote(color: group[currentIndex].color)
    }
    
    // MARK: - Event Method
    
    @objc func groupLabelTextFieldChanged() {
        guard let text = viewManager.groupLabelTextField.textField.text else { return }
        viewManager.groupLabelTextField.countLabel.text = "\(text.count)/8"
        
        // 텍스트가 비어있을 경우 그룹 생성 비활성화
        if text.isEmpty { viewManager.createBarButtonItem.isEnabled = false }
        else { viewManager.createBarButtonItem.isEnabled = true }
        
        guard let groupName = viewManager.groupLabelTextField.textField.text else { return }
        
        // 만약 그룹명이 존재하면 경고 메시지 출력 및 확인 버튼 비활성화
        for group in groupData.list() {
            if group.name == groupName && groupName != initialGroupName {
                viewManager.createBarButtonItem.isEnabled = false
                viewManager.groupLabelTextField.warningLabel.alpha = 1
                return
            }
            viewManager.groupLabelTextField.warningLabel.alpha = 0
        }
    }
    
    @objc func deleteButtonTapped() {
        let deletePopup = PopupViewController()
        deletePopup.delegate = self
        deletePopup.deletePopupView.mainLabel.text = "그룹을 삭제할까요?"
        deletePopup.deletePopupView.subLabel.text = "그룹과 관련된 블럭과 정보가 모두 삭제돼요"
        deletePopup.modalPresentationStyle = .overCurrentContext
        deletePopup.modalTransitionStyle = .crossDissolve
        view.endEditing(true)
        self.present(deletePopup, animated: true)
    }
}

// MARK: - EditGroupDetailViewDelegate

extension EditGroupViewController: EditGroupViewDelegate {
    func editGroup() {
        
        // 텍스트필드 변경사항 확인
        if let name = viewManager.groupLabelTextField.textField.text {
            
            // 코어데이터에서 그룹 업데이트
            groupData.update(name: name)
        }
        
        // Delegate를 이용한 EditGroupViewController의 TableView Reload
        delegate?.reloadData()
        
        // HomeViewController의 BlockCollectionView의 UI 업데이트
        NotificationCenter.default.post(name: NSNotification.Name(Noti.reloadForUpdateBlock), object: self, userInfo: nil)
        
        // CreateBlockViewController의 UI 업데이트
        NotificationCenter.default.post(name: NSNotification.Name(Noti.updateCreateBlockUI), object: self, userInfo: nil)
        
        // Pop
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - PopupViewControllerDelegate

extension EditGroupViewController: PopupViewControllerDelegate {
    func confirmButtonTapped() {
        
        // 코어데이터에서 그룹 삭제
        groupData.delete()
        
        // Delegate를 이용한 EditGroupViewController의 TableView Reload
        delegate?.reloadData()
        
        // HomeViewController의 BlockCollectionView를 0번(그룹없음) 으로 Switch
        NotificationCenter.default.post(name: NSNotification.Name(Noti.reloadForDeleteBlock), object: self, userInfo: nil)
        
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - SelectFormDelegate

extension EditGroupViewController: FormSelectButtonDelegate {
    
    func colorFormTapped() {
        
        // 키보드 해제
        viewManager.groupLabelTextField.endEditing(true)
        
        // present
        let selectColorVC = SelectColorViewController()
        selectColorVC.delegate = self
        
        // Half-Modal 설정
        if #available(iOS 15.0, *) {
            selectColorVC.modalPresentationStyle = .pageSheet
            if let sheet = selectColorVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            }
        } else {
            selectColorVC.modalPresentationStyle = .custom
            selectColorVC.transitioningDelegate = customBottomModalDelegate
        }
        
        // 컬러 업데이트
        let remoteGroup = groupData.remote()
        colorManager.updateCurrentColor(remoteGroup.color)
        
        present(selectColorVC, animated: true)
    }
}

// MARK: - SelectColorViewControllerDelegate

extension EditGroupViewController: SelectColorViewControllerDelegate {
    func updateColor() {
        let selectedColor = groupData.remote().color
        viewManager.colorSelect.selectColor.backgroundColor = UIColor(rgb: selectedColor)
    }
}

// MARK: - UITextFieldDelegate

extension EditGroupViewController: UITextFieldDelegate {
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
