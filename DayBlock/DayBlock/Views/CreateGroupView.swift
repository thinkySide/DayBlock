//
//  CreateGroupView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/17.
//

import UIKit

final class CreateGroupView: UIView {
    
    weak var delegate: CreateGroupViewDelegate?
    
    // MARK: - Component
    
    lazy var backBarButtonItem: UIBarButtonItem = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        let item = UIBarButtonItem(image: UIImage(systemName: "xmark")?.withConfiguration(configuration), style: .plain, target: self, action: #selector(backBarButtonItemTapped))
        item.tintColor = GrayScale.mainText
        return item
    }()
    
    lazy var groupLabelTextField: FieldForm = {
        let form = FieldForm()
        form.textFieldLabel.text = "그룹명"
        form.textField.placeholder = "자기계발"
        form.countLabel.text = "0/8"
        form.warningLabel.text = "중복되는 그룹명은 사용할 수 없어요"
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
        item.isEnabled = false
        return item
    }()
    
    
    
    // MARK: - Initial
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitial()
        setupAddSubView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Method
    
    @objc func backBarButtonItemTapped() {
        delegate?.dismissVC()
    }
    
    @objc func createBarButtonItemTapped() {
        delegate?.createGroup()
    }
    
    func setupInitial() {
        backgroundColor = .white
    }
    
    func setupAddSubView() {
        [groupLabelTextField, selectFormStackView]
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
            
            /// groupLabel
            groupLabelTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            groupLabelTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            groupLabelTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.margin),
            
            /// selectFormStackView
            selectFormStackView.topAnchor.constraint(equalTo: groupLabelTextField.bottomAnchor, constant: 8),
            selectFormStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            selectFormStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
