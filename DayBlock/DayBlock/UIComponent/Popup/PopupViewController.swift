//
//  PopupViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/08.
//

import UIKit

@objc protocol PopupViewControllerDelegate: AnyObject {
    func confirmButtonTapped()
    @objc optional func cancelButtonTapped()
}

final class PopupViewController: UIViewController {
    
    weak var delegate: PopupViewControllerDelegate?
    
    let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.3
        return view
    }()
    
    let deletePopupView: PopupView = {
        let popup = PopupView()
        return popup
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddView()
        setupAddTarget()
    }
    
    // MARK: - Setup Method
    
    func setupAddView() {
        view.addSubview(bgView)
        view.addSubview(deletePopupView)
        
        bgView.translatesAutoresizingMaskIntoConstraints = false
        deletePopupView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: view.topAnchor),
            bgView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bgView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            deletePopupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            deletePopupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            deletePopupView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    func setupAddTarget() {
        let bgGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        
        // 배경 화면
        bgView.addGestureRecognizer(bgGesture)
        
        // 취소 버튼
        deletePopupView.actionStackView.cancelButton
            .addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        // 삭제 버튼
        deletePopupView.actionStackView.confirmButton
            .addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Event Method
    
    @objc func backgroundTapped() {
        // dismiss(animated: true)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
        delegate?.cancelButtonTapped?()
    }
    
    @objc func deleteButtonTapped() {
        dismiss(animated: true)
        delegate?.confirmButtonTapped()
    }
}
