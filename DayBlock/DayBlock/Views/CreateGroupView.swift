//
//  CreateGroupView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/17.
//

import UIKit

protocol CreateGroupViewDelegate: AnyObject {
    func dismissVC()
    func createGroup()
}

final class CreateGroupView: UIView {
    
    weak var delegate: CreateGroupViewDelegate?
    
    // MARK: - Component
    
    lazy var backBarButtonItem: UIBarButtonItem = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        let item = UIBarButtonItem(image: UIImage(systemName: "xmark")?.withConfiguration(configuration), style: .plain, target: self, action: #selector(backBarButtonItemTapped))
        item.tintColor = GrayScale.mainText
        return item
    }()
    
    lazy var groupLabel: FieldForm = {
        let form = FieldForm()
        form.textFieldLabel.text = "그룹명"
        form.textField.placeholder = "자기계발"
        form.countLabel.text = "0/8"
        form.textField.addTarget(self, action: #selector(groupLabelTextFieldChanged), for: .editingChanged)
        return form
    }()
    
    lazy var createBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(createBarButtonItemTapped))
        let font = UIFont(name: Pretendard.semiBold, size: 18)
        let attributes = [NSAttributedString.Key.font: font]
        item.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
        item.tintColor = GrayScale.mainText
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
    
    @objc func groupLabelTextFieldChanged() {
        guard let text = groupLabel.textField.text else { return }
        groupLabel.countLabel.text = "\(text.count)/8"
    }
    
    func setupInitial() {
        backgroundColor = .white
    }
    
    func setupAddSubView() {
        [groupLabel]
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
            groupLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            groupLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            groupLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.margin),
        ])
    }
}
