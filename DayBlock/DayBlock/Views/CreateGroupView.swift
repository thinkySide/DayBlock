//
//  CreateGroupView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/17.
//

import UIKit

protocol CreateGroupViewDelegate: AnyObject {
    func dismissVC()
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
    
    @objc func backBarButtonItemTapped() {
        delegate?.dismissVC()
    }
    
    func setupInitial() {
        backgroundColor = .white
    }
    
    func setupAddSubView() {
//        []
//            .forEach {
//
//                /// 1. addSubView(component)
//                addSubview($0)
//
//                /// 2. translatesAutoresizingMaskIntoConstraints = false
//                $0.translatesAutoresizingMaskIntoConstraints = false
//            }
    }
    
    func setupConstraints() {
        
        /// 3. NSLayoutConstraint.activate
        NSLayoutConstraint.activate([
            
            
        ])
    }
}
