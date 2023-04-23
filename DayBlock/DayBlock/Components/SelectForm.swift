//
//  SelectForm.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/08.
//

import UIKit

protocol SelectFormDelegate: AnyObject {
    func groupFormTapped()
    func iconFormTapped()
    func colorFormTapped()
}

final class SelectForm: UIView {
    
    enum SelectType {
        case group
        case icon
        case color
    }
    
    var selectType: SelectType?
    weak var delegate: SelectFormDelegate?
    
    
    
    // MARK: - Component
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.addSubview(contentStackView)
        view.addSubview(seperator)
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [selectTitle, selectStackView])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 4
        return stack
    }()
    
    private let selectTitle: UILabel = {
        let label = UILabel()
        label.text = "그룹"
        label.font = UIFont(name: Pretendard.semiBold, size: 16)
        label.textColor = GrayScale.subText
        label.textAlignment = .left
        return label
    }()
    
    private lazy var selectStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()
    
    let selectLabel: UILabel = {
        let label = UILabel()
        label.text = "자기계발" // ⛳️
        label.font = UIFont(name: Pretendard.semiBold, size: 17)
        label.textColor = GrayScale.mainText
        label.textAlignment = .right
        return label
    }()
    
    let selectIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.tintColor = GrayScale.mainText
        image.image = UIImage(systemName: "batteryblock.fill")
        return image
    }()
    
    let selectColor: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue // ⛳️
        view.clipsToBounds = true
        return view
    }()
    
    private let polygon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.tintColor = UIColor(rgb: 0x676767)
        image.image = UIImage(named: Icon.menuIcon)
        return image
    }()
    
    private let seperator: UIView = {
        let line = UIView()
        line.backgroundColor = GrayScale.seperator
        return line
    }()
    
    
    
    
    // MARK: - Custom Method
    
    func ofType(_ label: String, _ type: SelectType) {
        
        /// SelectForm 제목 라벨
        selectTitle.text = label
        
        /// SelectForm 스타일 설정
        switch type {
        case .group:
            selectType = .group
            [selectColor, selectLabel, polygon].forEach {
                selectStackView.addArrangedSubview($0)}
            
        case .icon:
            selectType = .icon
            [selectIcon, polygon].forEach {
                selectStackView.addArrangedSubview($0)}
            
        case .color:
            selectType = .color
            [selectColor, polygon].forEach {
                selectStackView.addArrangedSubview($0)}
        }
    }
    
    @objc func selectFormTapped() {
        switch selectType! {
        case .group:
            delegate?.groupFormTapped()
        case .icon:
            delegate?.iconFormTapped()
        case .color:
            delegate?.colorFormTapped()
        }
    }
    
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        /// CornerRadius
        selectColor.layer.cornerRadius = selectColor.frame.height / 4
    }
    
    func setupInitial() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectFormTapped))
        self.addGestureRecognizer(gesture)
    }
    
    func setupAddSubView() {
        /// 1. addSubView(component)
        [contentView]
            .forEach { addSubview($0) }
        
        /// 2. translatesAutoresizingMaskIntoConstraints = false
        [
            contentView, contentStackView, selectTitle, selectStackView,
            selectLabel ,polygon,
            seperator
        ]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
    
    func setupConstraints() {
        /// 3. NSLayoutConstraint.activate
        NSLayoutConstraint.activate([
            
            /// SelectForm(self)
            self.bottomAnchor.constraint(equalTo: seperator.bottomAnchor),
            
            /// contentView
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            /// contentStackView
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentStackView.heightAnchor.constraint(equalToConstant: 40),
            
            
            /// selectIcon
            selectIcon.widthAnchor.constraint(equalToConstant: 24),
            selectIcon.heightAnchor.constraint(equalTo: selectIcon.widthAnchor),
            
            /// selectColor
            selectColor.widthAnchor.constraint(equalToConstant: 24),
            selectColor.heightAnchor.constraint(equalTo: selectColor.widthAnchor),
            
            /// seperator
            seperator.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 8),
            seperator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            seperator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            seperator.heightAnchor.constraint(equalToConstant: Size.seperator),
        ])
    }
}
