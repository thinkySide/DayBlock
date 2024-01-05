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
    private let customBottomModalDelegate = BottomModalDelegate()
    weak var delegate: CreateGroupViewControllerDelegate?
    
    private let groupData = GroupDataStore.shared
    private let blockData = BlockDataStore.shared
    
    // 저장할 컬러인덱스
    private var colorIndex = 22
    
    /// Present화면인지, Navigation인지 확인
    
    enum ScreenMode {
        case present
        case navigation
    }
    
    var screenMode: ScreenMode = .navigation
    
    var initialX: CGFloat = 0
    
    // MARK: - ViewController LifeCycle
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupDelegate()
        setupAddTarget()
        addHideKeyboardGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // 전체 화면 모드로 변경
        if #available(iOS 15.0, *) {
            guard let sheet = navigationController?.sheetPresentationController else {
                return
            }
            
            sheet.animateChanges {
                sheet.detents = [.large()]
                sheet.selectedDetentIdentifier = .large
            }
        }
    }
    
    // MARK: - Initial Method
    
    func setupNavigation() {
        
        // Custom
        title = "새 그룹 생성"
        navigationController?.navigationBar
            .titleTextAttributes = [.font: UIFont(name: Pretendard.semiBold, size: 16)!]
        
        // 생성 버튼
        navigationItem.rightBarButtonItem = viewManager.createBarButtonItem
    }
    
    func setupDelegate() {
        viewManager.delegate = self
        viewManager.groupLabelTextField.textField.delegate = self
        viewManager.colorSelect.delegate = self
    }
    
    private func setupAddTarget() {
        viewManager.groupLabelTextField.textField.addTarget(self, action: #selector(groupLabelTextFieldChanged), for: .editingChanged)
    }
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
    
    /// 그룹명 텍스트필드 텍스트 변화 감지 메서드
    @objc func groupLabelTextFieldChanged() {
        guard let text = viewManager.groupLabelTextField.textField.text else { return }
        viewManager.groupLabelTextField.countLabel.text = "\(text.count)/8"
        
        // 텍스트가 비어있을 경우 그룹 생성 비활성화
        if text.isEmpty { viewManager.createBarButtonItem.isEnabled = false }
        else { viewManager.createBarButtonItem.isEnabled = true }
        
        guard let groupName = viewManager.groupLabelTextField.textField.text else { return }
        
        // 만약 그룹명이 존재하면 경고 메시지 출력 및 확인 버튼 비활성화
        for group in groupData.list() {
            if group.name == groupName {
                viewManager.createBarButtonItem.isEnabled = false
                viewManager.groupLabelTextField.warningLabel.alpha = 1
                return
            }
            viewManager.groupLabelTextField.warningLabel.alpha = 0
        }
    }
}

// MARK: - CreateGroupViewDelegate

extension CreateGroupViewController: CreateGroupViewDelegate {
    func dismissVC() {
        dismiss(animated: true)
    }
    
    func createGroup() {
        
        guard let groupName = viewManager.groupLabelTextField.textField.text else { return }
        
        // 키보드 내리기
        view.endEditing(true)
        
        // 리모트 그룹 업데이트
        groupData.updateRemote(name: groupName)
        
        // 그룹 생성
        groupData.create()
        
        // selectView의 그룹 리스트 업데이트
        delegate?.updateGroupList()
        
        // 스크린 모드가 Present라면
        if screenMode == .present {
            dismiss(animated: true)
            return
        }
        
        // 스크린 모드가 Navigation이라면
        if screenMode == .navigation {
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - SelectFormDelegate

extension CreateGroupViewController: FormSelectButtonDelegate {
    
    func colorFormTapped() {
        
        // 키보드 해제
        viewManager.groupLabelTextField.endEditing(true)
        
        // present
        let selectColorVC = SelectColorViewController()
        selectColorVC.delegate = self
        
        // Half-Modal 설정
        if #available(iOS 15.0, *) {
            if let sheet = selectColorVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            }
        } else {
            selectColorVC.modalPresentationStyle = .custom
            selectColorVC.transitioningDelegate = customBottomModalDelegate
        }
        
        ColorManager.shared.updateCurrentIndex(to: colorIndex)
        
        present(selectColorVC, animated: true)
    }
}

// MARK: - SelectColorViewControllerDelegate

extension CreateGroupViewController: SelectColorViewControllerDelegate {
    func updateColor(index: Int) {
        let selectedColor = groupData.remote().color
        viewManager.colorSelect.selectColor.backgroundColor = UIColor(rgb: selectedColor)
        self.colorIndex = index
    }
}
