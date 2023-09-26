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
        setupBackPanGesture()
        setupNavigation()
        setupDelegate()
        setupAddTarget()
        addHideKeyboardGesture()
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
        
        // 리모트 그룹 업데이트
        groupData.updateRemote(groupName: groupName)
        
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
        let selectedColor = groupData.remote().color
        viewManager.colorSelect.selectColor.backgroundColor = UIColor(rgb: selectedColor)
    }
}

// MARK: - Back Gesture(수정 필요!)
extension CreateGroupViewController: UIGestureRecognizerDelegate {
    
    /// 스와이프 제스처를 이용한 Dismiss 기능 구현 메서드
    private func setupBackPanGesture() {
        
        // 화면을 터치하자마자 반응하는 제스처 추가
        let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handlePressGesture(_:)))
        pressGesture.minimumPressDuration = 0
        pressGesture.delegate = self
        view.addGestureRecognizer(pressGesture)

        // 팬 제스처 추가
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePressGesture(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            initialX = gesture.location(in: view).x
            print(initialX)
        }
    }
    
    /// 제스처가 동작할때 실행할 메서드
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        
        // 1. 제스처의 이동 거리
        let translation = gesture.translation(in: nil).x
        
        // 2. 제스처가 종료되었다면
        if gesture.state == .ended {
            
            if initialX > 24 {
                print("종료")
                return
            }
            
            // 3. 제스처가 100보다 크게 스와이프 되었다면
            if translation > 80 {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    /// 제스처가 동시에 실행이 가능하도록 만드는 Delegate 메서드
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
