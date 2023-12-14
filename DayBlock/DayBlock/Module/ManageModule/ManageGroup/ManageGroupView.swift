//
//  ManageGroupView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/17.
//

import UIKit

final class ManageGroupView: UIView {
    
    weak var delegate: ManageGroupViewDelegate?
    
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
    
    let sectionBar: SectionBar = {
        let sectionBar = SectionBar()
        sectionBar.firstSection.label.text = "블럭 관리"
        sectionBar.secondSection.label.text = "그룹 관리"
        sectionBar.active(.second)
        return sectionBar
    }()
    
    let groupTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = true
        table.backgroundColor = .white
        return table
    }()
    
    let toastView: ToastMessage = {
        let view = ToastMessage(state: .warning)
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
        
        [sectionBar, groupTableView, toastView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            // sectionBar
            sectionBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            sectionBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            sectionBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // groupTableView
            groupTableView.topAnchor.constraint(equalTo: sectionBar.bottomAnchor, constant: 8),
            groupTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            groupTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            groupTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // toastView
            toastView.centerXAnchor.constraint(equalTo: centerXAnchor),
            toastView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
