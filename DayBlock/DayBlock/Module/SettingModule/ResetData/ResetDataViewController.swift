//
//  ResetDataViewController.swift
//  DayBlock
//
//  Created by 김민준 on 12/14/23.
//

import UIKit

protocol ResetDataViewControllerDelegate: AnyObject {
    func resetDataViewController(didFinishResetData: ResetDataViewController)
}

final class ResetDataViewController: UIViewController {
    
    private let viewManager = ResetDataView()
    weak var delegate: ResetDataViewControllerDelegate?
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupEvent()
    }
    
    // MARK: - Setup Method
    private func setupNavigation() {
        title = "초기화"
    }
    
    private func setupEvent() {
        viewManager.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Event Method
    
    /// 초기화 버튼 탭 시 실행되는 메서드입니다.
    @objc func deleteButtonTapped() {
        let deletePopup = PopupViewController()
        deletePopup.delegate = self
        deletePopup.modalPresentationStyle = .overCurrentContext
        deletePopup.modalTransitionStyle = .crossDissolve
        
        let popupView = deletePopup.deletePopupView
        popupView.mainLabel.text = "모든 데이터를 초기화할까요?"
        popupView.subLabel.text = "그동안 생성된 데이터가 모두 삭제돼요"
        popupView.actionStackView.confirmButton.setTitle("초기화할래요", for: .normal)
        
        self.present(deletePopup, animated: true)
    }
}

extension ResetDataViewController: PopupViewControllerDelegate {
    
    /// 초기화 팝업 - 확인 버튼 탭 시 실행되는 메서드입니다.
    func confirmButtonTapped() {
        
        // 모든 데이터 초기화
        GroupDataStore.shared.resetAllData()
        
        // 현재 인덱스 0번으로 초기화
        GroupDataStore.shared.updateFocusIndex(to: 0)
        
        // NotificationCenter로 HomeViewController 초기화
        NotificationCenter.default.post(name: .resetAllData, object: self, userInfo: nil)
        
        // 이전 화면으로 이동
        navigationController?.popViewController(animated: true)
        
        // 초기화 완료 토스트 출력
        delegate?.resetDataViewController(didFinishResetData: self)
    }
}
