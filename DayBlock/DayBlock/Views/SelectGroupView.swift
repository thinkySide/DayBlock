//
//  SelectGroupView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/13.
//

import UIKit

protocol SelectGroupViewDelegate: AnyObject {
    func addButtonTapped()
}

final class SelectGroupView: UIView {
    
    weak var delegate: SelectGroupViewDelegate?
    
    // MARK: - Component
    
    lazy var addBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonItemTapped))
        item.tintColor = GrayScale.mainText
        return item
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = true
        return table
    }()
    
    let confirmButton: ConfirmButton = {
        let button = ConfirmButton()
        button.setTitle("확인", for: .normal)
        return button
    }()
    
    
    // MARK: - Variable
    
    
    
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
    
    @objc func addBarButtonItemTapped() {
        delegate?.addButtonTapped()
    }
    
    func setupInitial() {
        backgroundColor = .white
        
        /// CornerRadius
        self.clipsToBounds = true
        self.layer.cornerRadius = 30
    }
    
    func setupAddSubView() {
        [tableView, confirmButton]
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
            
            /// tableView
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            tableView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -24),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            /// confirmButton
            confirmButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            confirmButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.margin),
        ])
    }
}
