//
//  EditGroupDetailViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/17.
//

import UIKit

protocol EditGroupDetailViewControllerDelegate: AnyObject {
    func reloadData()
}

final class EditGroupDetailViewController: UIViewController {
    
    weak var delegate: EditGroupDetailViewControllerDelegate?
    
    private let viewManager = EditGroupDetailView()
    private let blockManager = BlockManager.shared
    private let colorManager = ColorManager.shared
    private let customBottomModalDelegate = CustomBottomModalDelegate()
    
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
        hideKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remote 그룹 초기화
        blockManager.resetRemoteGroup()
    }
    
    // MARK: - SETUP METHOD
    
    private func setupUI() {
        let group = blockManager.getGroupList()
        let currentIndex = blockManager.getCurrentEditGroupIndex()
        
        viewManager.groupLabelTextField.textField.text = "\(group[currentIndex].name)"
        viewManager.groupLabelTextField.countLabel.text = "\(group[currentIndex].name.count)/8"
        viewManager.colorSelect.selectColor.backgroundColor = UIColor(rgb: group[currentIndex].color)
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
        viewManager.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    private func setupRemoteGroup() {
        let group = blockManager.getGroupList()
        let currentIndex = blockManager.getCurrentEditGroupIndex()
        blockManager.updateRemoteGroup(name: "\(group[currentIndex].name)")
        blockManager.updateRemoteGroup(color: group[currentIndex].color)
    }
    
    
    // MARK: - Event Method
    
    @objc func deleteButtonTapped() {
        let deletePopup = DeletePopupViewController()
        deletePopup.delegate = self
        deletePopup.deletePopupView.mainLabel.text = "그룹을 삭제할까요?"
        deletePopup.deletePopupView.subLabel.text = "그룹과 관련된 블럭과 정보가 모두 삭제돼요"
        deletePopup.modalPresentationStyle = .overCurrentContext
        deletePopup.modalTransitionStyle = .crossDissolve
        self.present(deletePopup, animated: true)
    }
}

// MARK: - EditGroupDetailViewDelegate

extension EditGroupDetailViewController: EditGroupDetailViewDelegate {
    func editGroup() {
        
        // 텍스트필드 변경사항 확인
        if let name = viewManager.groupLabelTextField.textField.text {
            
            // 코어데이터에서 그룹 업데이트
            blockManager.updateGroup(name: name)
        }
        
        // Delegate를 이용한 EditGroupViewController의 TableView Reload
        delegate?.reloadData()
        
        // Pop
        navigationController?.popViewController(animated: true)
    }
}


// MARK: - DeletePopupViewControllerDelegate

extension EditGroupDetailViewController: DeletePopupViewControllerDelegate {
    func deleteObject() {
        
        // 코어데이터에서 그룹 삭제
        blockManager.deleteGroup()
        
        // Delegate를 이용한 EditGroupViewController의 TableView Reload
        delegate?.reloadData()
        
        // 어떤 방식을 통해서 HomeViewController의 BlockCollectionView를 0번(그룹없음) 으로 Switch 해줘야함.
        NotificationCenter.default.post(name: NSNotification.Name("reloadData"), object: self, userInfo: nil)
        
        navigationController?.popViewController(animated: true)
    }
}


// MARK: - SelectFormDelegate

extension EditGroupDetailViewController: SelectFormDelegate {
    
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
        let remoteGroup = blockManager.getRemoteGroup()
        colorManager.updateCurrentColor(remoteGroup.color)
        
        present(selectColorVC, animated: true)
    }
}


// MARK: - SelectColorViewControllerDelegate

extension EditGroupDetailViewController: SelectColorViewControllerDelegate {
    func updateColor() {
        let selectedColor = blockManager.getRemoteGroup().color
        viewManager.colorSelect.selectColor.backgroundColor = UIColor(rgb: selectedColor)
    }
}


// MARK: - UITextFieldDelegate

extension EditGroupDetailViewController: UITextFieldDelegate {
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
