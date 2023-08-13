//
//  SelectGroupView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/13.
//

import UIKit

final class SelectGroupView: UIView {
    
    // MARK: - Component
    
    private let title: UILabel = {
        let label = UILabel()
        label.text = "그룹 선택"
        label.font = UIFont(name: Pretendard.semiBold, size: 16)
        label.textColor = GrayScale.mainText
        label.textAlignment = .center
        return label
    }()
        
    let groupTableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = true
        return table
    }()
    
    let actionStackView: ActionStackView = {
        let stack = ActionStackView()
        return stack
    }()
    
    lazy var menuButton: UIButton = {
        let button = UIButton()
        let icon = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        button.setImage(UIImage(systemName: "ellipsis", withConfiguration: icon), for: .normal)
        button.tintColor = GrayScale.mainText
        return button
    }()
    
    let customUIMenu: CustomUIMenu = {
        let menu = CustomUIMenu(frame: .zero, number: .three)
        menu.firstItem.title.text = "그룹 생성"
        let firstIcon = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        menu.firstItem.icon.image = UIImage(systemName: "plus")
        
        menu.secondItem.title.text = "그룹 편집"
        let secondIcon = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        menu.secondItem.icon.image = UIImage(systemName: "pencil")
        
        menu.thirdItem.title.text = "그룹 삭제"
        let thirdIcon = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        menu.thirdItem.icon.image = UIImage(systemName: "trash.fill")
        
        menu.alpha = 0
        return menu
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
    
    func setupInitial() {
        backgroundColor = .white
        
        /// CornerRadius
        self.clipsToBounds = true
        self.layer.cornerRadius = 30
    }
    
    func setupAddSubView() {
        [title, menuButton, groupTableView, actionStackView, customUIMenu]
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
            
            /// title
            title.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            /// addButton
            menuButton.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            menuButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            menuButton.widthAnchor.constraint(equalToConstant: 40),
            menuButton.heightAnchor.constraint(equalTo: menuButton.widthAnchor),
            
            /// groupTableView
            groupTableView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            groupTableView.bottomAnchor.constraint(equalTo: actionStackView.topAnchor, constant: -16),
            groupTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            groupTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            /// actionStackView
            actionStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            actionStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            actionStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.margin),
            
            // customUIMenu
            customUIMenu.topAnchor.constraint(equalTo: menuButton.bottomAnchor, constant: 0),
            customUIMenu.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])
    }
}
