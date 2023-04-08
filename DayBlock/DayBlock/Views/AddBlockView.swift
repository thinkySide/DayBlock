//
//  AddBlockView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/07.
//

import UIKit

final class AddBlockView: UIView {
    
    // MARK: - Component
    
    private lazy var blockPreview: UIView = {
        let view = UIView()
        view.backgroundColor = GrayScale.contentsBlock
        view.clipsToBounds = true
        [blockPreviewColorTag, blockPreviewIcon, blockPreviewLabel]
            .forEach { view.addSubview($0) }
        return view
    }()
    
    private let blockPreviewColorTag: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue // ⛳️
        view.clipsToBounds = true
        view.layer.cornerRadius = 9
        
        /// 하단 왼쪽, 하단 오른쪽만 cornerRadius 값 주기
        view.layer.maskedCorners = CACornerMask(
            arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        return view
    }()
    
    private let blockPreviewIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "batteryblock.fill") // ⛳️
        image.contentMode = .scaleAspectFit
        image.tintColor = GrayScale.mainText
        return image
    }()
    
    private let blockPreviewLabel: UILabel = {
        let label = UILabel()
        label.text = "블럭 쌓기" // ⛳️
        label.font = UIFont(name: Pretendard.bold, size: 17)
        label.textColor = GrayScale.mainText
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let nameTextField: FieldForm = {
        let field = FieldForm()
        return field
    }()
    
    private lazy var selectFormStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            groupSelect, colorSelect, iconSelect])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = Size.selectFormSpacing
        return stack
    }()
    
    private let groupSelect: SelectForm = {
        let select = SelectForm()
        select.ofType("그룹", .label)
        return select
    }()
    
    private let colorSelect: SelectForm = {
        let select = SelectForm()
        select.ofType("색상", .color)
        return select
    }()
    
    private let iconSelect: SelectForm = {
        let select = SelectForm()
        select.ofType("아이콘", .icon)
        return select
    }()
    
    
    // MARK: - Variable
    
    
    
    // MARK: - Method
    
    @objc func blockNameTextFieldChanged() {
        print(#function)
    }
    
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
        
        /// cornerRadius
        blockPreview.layer.cornerRadius = blockPreview.frame.height / 7
    }
    
    func setupInitial() {
        backgroundColor = .white
    }
    
    func setupAddSubView() {
        
        /// 1. addSubView(component)
        [
            blockPreview, nameTextField, selectFormStackView,
        ]
            .forEach { addSubview($0) }
        
        /// 2. translatesAutoresizingMaskIntoConstraints = false
        [
            blockPreview, blockPreviewColorTag, blockPreviewIcon,
            blockPreviewLabel, nameTextField, selectFormStackView,
            groupSelect, colorSelect, iconSelect,
        ]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }

    func setupConstraints() {
        
        /// 3. NSLayoutConstraint.activate
        NSLayoutConstraint.activate([
            
            /// blockPreview
            blockPreview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            blockPreview.centerXAnchor.constraint(equalTo: centerXAnchor),
            blockPreview.widthAnchor.constraint(equalToConstant: Size.blockSize.width),
            blockPreview.heightAnchor.constraint(equalTo: blockPreview.widthAnchor),
            
            /// blockColorTag
            blockPreviewColorTag.topAnchor.constraint(equalTo: blockPreview.topAnchor),
            blockPreviewColorTag.trailingAnchor.constraint(equalTo: blockPreview.trailingAnchor, constant: -32),
            blockPreviewColorTag.widthAnchor.constraint(equalToConstant: 20),
            blockPreviewColorTag.heightAnchor.constraint(equalToConstant: 30),
            
            /// blockIcon
            blockPreviewIcon.topAnchor.constraint(equalTo: blockPreview.topAnchor, constant: 54),
            blockPreviewIcon.centerXAnchor.constraint(equalTo: blockPreview.centerXAnchor),
            blockPreviewIcon.widthAnchor.constraint(equalToConstant: 56),
            blockPreviewIcon.heightAnchor.constraint(equalToConstant: 56),

            /// blockLabel
            blockPreviewLabel.topAnchor.constraint(equalTo: blockPreviewIcon.bottomAnchor, constant: 12),
            blockPreviewLabel.leadingAnchor.constraint(equalTo: blockPreview.leadingAnchor, constant: 20),
            blockPreviewLabel.trailingAnchor.constraint(equalTo: blockPreview.trailingAnchor, constant: -20),
            
            /// nameTextField
            nameTextField.topAnchor.constraint(equalTo: blockPreview.bottomAnchor, constant: 32),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.margin),
            
            /// selectFormStackView
            selectFormStackView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            selectFormStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            selectFormStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
