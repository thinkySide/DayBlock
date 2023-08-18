//
//  EditGroupView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/17.
//

import UIKit

final class EditGroupView: UIView {
    
    weak var delegate: EditGroupViewDelegate?
    
    // MARK: - Component
    
    lazy var backBarButtonItem: UIBarButtonItem = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        let item = UIBarButtonItem(image: UIImage(systemName: "xmark")?.withConfiguration(configuration), style: .plain, target: self, action: #selector(backBarButtonItemTapped))
        item.tintColor = GrayScale.mainText
        return item
    }()
    
    let groupTableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = true
        return table
    }()
    
    
    // MARK: - Event Method
    
    @objc func backBarButtonItemTapped() {
        delegate?.dismissVC()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        [groupTableView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            // groupTableView
            groupTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            groupTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            groupTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            groupTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
