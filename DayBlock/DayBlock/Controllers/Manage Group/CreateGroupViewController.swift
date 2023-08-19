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
    private let customBottomModalDelegate = CustomBottomModalDelegate()
    weak var delegate: CreateGroupViewControllerDelegate?
    
    /// Present화면인지, Navigation인지 확인
    
    enum ScreenMode {
        case present
        case navigation
    }
    
    var screenMode: ScreenMode = .navigation
    
    
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
    }
    
    
    // MARK: - Initial Method
    
    /// 뒤로가기 버튼 설정 메서드
    func setupBackButton() {
        navigationItem.leftBarButtonItem = viewManager.backBarButtonItem
    }
    
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
        
        /// 리모트 그룹 업데이트
        guard let groupName = viewManager.groupLabelTextField.textField.text else { return }
        blockManager.updateRemoteGroup(name: groupName)
        
        /// 그룹 생성
        blockManager.createNewGroup()
        
        /// selectView의 그룹 리스트 업데이트
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

extension CreateGroupViewController: SelectFormDelegate {
    
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
        
        // 컬러 인덱스 초기화(38번 블루)
        ColorManager.shared.updateCurrentIndex(to: 38)
        
        present(selectColorVC, animated: true)
    }
}



// MARK: - SelectColorViewControllerDelegate

extension CreateGroupViewController: SelectColorViewControllerDelegate {
    func updateColor() {
        let selectedColor = blockManager.getRemoteGroup().color
        viewManager.colorSelect.selectColor.backgroundColor = UIColor(rgb: selectedColor)
    }
}
