//
//  ListGroupView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/17.
//

import UIKit

final class ListGroupView: UIView {
    
    weak var delegate: ListGroupViewDelegate?
    
    // MARK: - Component
    
    lazy var backBarButtonItem: UIBarButtonItem = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        let item = UIBarButtonItem(image: UIImage(systemName: "xmark")?.withConfiguration(configuration), style: .plain, target: self, action: #selector(backBarButtonItemTapped))
        item.tintColor = Color.mainText
        return item
    }()
    
    lazy var addBarButtonItem: UIBarButtonItem = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        let item = UIBarButtonItem(image: UIImage(systemName: "plus")?.withConfiguration(configuration), style: .plain, target: self, action: #selector(addBarButtonItemTapped))
        item.tintColor = Color.mainText
        return item
    }()
    
    let groupTableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = true
        return table
    }()
    
    let toastView: ToastMessage = {
        let view = ToastMessage()
        view.messageLabel.text = "기본 그룹은 수정할 수 없어요"
        view.alpha = 0
        return view
    }()
    
    
    // MARK: - Event Method
    
    @objc func backBarButtonItemTapped() {
        delegate?.dismissVC()
    }
    
    @objc func addBarButtonItemTapped() {
        delegate?.addGroup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        [groupTableView, toastView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            // groupTableView
            groupTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            groupTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            groupTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            groupTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // toastView
            toastView.centerXAnchor.constraint(equalTo: centerXAnchor),
            toastView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -48),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
