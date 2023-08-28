//
//  EditGroupDetailView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/17.
//

import UIKit

protocol EditGroupDetailViewDelegate: AnyObject {
    func editGroup()
}

final class EditGroupDetailView: UIView {
    
    weak var delegate: EditGroupDetailViewDelegate?
    
    // MARK: - Component
    
    lazy var groupLabelTextField: FieldForm = {
        let form = FieldForm()
        form.textFieldLabel.text = "그룹명"
        form.textField.placeholder = "자기계발"
        form.countLabel.text = "0/8"
        form.textField.addTarget(self, action: #selector(groupLabelTextFieldChanged), for: .editingChanged)
        return form
    }()
    
    private lazy var selectFormStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [colorSelect])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = Size.selectFormSpacing
        return stack
    }()
    
    let colorSelect: SelectForm = {
        let select = SelectForm()
        select.ofType("색상", .color)
        return select
    }()
    
    lazy var createBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(createBarButtonItemTapped))
        let font = UIFont(name: Pretendard.semiBold, size: 17)
        let attributes = [NSAttributedString.Key.font: font]
        item.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
        item.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .disabled)
        item.tintColor = GrayScale.mainText
        item.isEnabled = true
        return item
    }()
    
    let deleteButton: ActionButton = {
        let button = ActionButton(frame: .zero, mode: .delete)
        return button
    }()
    
    
    // MARK: - Event Method
    
    @objc func groupLabelTextFieldChanged() {
        guard let text = groupLabelTextField.textField.text else { return }
        groupLabelTextField.countLabel.text = "\(text.count)/8"
        
        /// 텍스트가 비어있을 경우 그룹 생성 비활성화
        if text.isEmpty { createBarButtonItem.isEnabled = false }
        else { createBarButtonItem.isEnabled = true }
    }
    
    @objc func createBarButtonItemTapped() {
        print(#function)
        delegate?.editGroup()
    }
    
    
    // MARK: - Initial Method
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupAddSubView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAddSubView() {
        [groupLabelTextField, selectFormStackView, deleteButton]
            .forEach {
                
                /// 1. addSubView(component)
                addSubview($0)
                
                /// 2. translatesAutoresizingMaskIntoConstraints = false
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
    }
    
    func setupConstraints() {
        
        /// 3. NSLayoutConstraint.activate
        NSLayoutConstraint.activate([
            
            // groupLabel
            groupLabelTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            groupLabelTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            groupLabelTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.margin),
            
            // selectFormStackView
            selectFormStackView.topAnchor.constraint(equalTo: groupLabelTextField.bottomAnchor, constant: 24),
            selectFormStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            selectFormStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // deleteButton
            deleteButton.topAnchor.constraint(equalTo: selectFormStackView.bottomAnchor, constant: 32),
            deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.margin),
        ])
    }
}