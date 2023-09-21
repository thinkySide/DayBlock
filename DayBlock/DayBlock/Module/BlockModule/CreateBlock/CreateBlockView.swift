//
//  CreateBlockView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/07.
//

import UIKit

final class CreateBlockView: UIView {
    
    // MARK: - Component
    
    private lazy var blockPreview: UIView = {
        let view = UIView()
        view.backgroundColor = Color.contentsBlock
        view.clipsToBounds = true
        [blockPreviewColorTag, blockPreviewIcon, blockTaskLabel]
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
        image.tintColor = Color.mainText
        return image
    }()
    
    private let blockTaskLabel: UILabel = {
        let label = UILabel()
        label.text = "블럭 쌓기" // ⛳️
        label.font = UIFont(name: Pretendard.bold, size: 17)
        label.textColor = Color.mainText
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    lazy var taskLabelTextField: FormTextField = {
        let form = FormTextField()
        return form
    }()
    
    private lazy var selectFormStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            groupSelect, iconSelect])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = Size.selectFormSpacing
        return stack
    }()
    
    let groupSelect: FormSelectButton = {
        let select = FormSelectButton()
        select.ofType("그룹", .group)
        return select
    }()
    
    let iconSelect: FormSelectButton = {
        let select = FormSelectButton()
        select.ofType("아이콘", .icon)
        return select
    }()
    
    lazy var createBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem()
        item.title = "확인"
        item.style = .plain
        let font = UIFont(name: Pretendard.semiBold, size: 17)
        let attributes = [NSAttributedString.Key.font: font]
        item.setTitleTextAttributes(attributes as [NSAttributedString.Key: Any], for: .normal)
        item.setTitleTextAttributes(attributes as [NSAttributedString.Key: Any], for: .disabled)
        item.tintColor = Color.mainText
        item.isEnabled = false
        return item
    }()

    // MARK: - Method
    
    /// Block 정보 업데이트
    func updateBlockInfo(_ group: RemoteGroup) {
        let block = group.list[0]
        groupSelect.selectLabel.text = group.name
        groupSelect.selectColor.backgroundColor = UIColor(rgb: group.color)
        blockTaskLabel.text = block.taskLabel
        blockPreviewColorTag.backgroundColor = UIColor(rgb: group.color)
        blockPreviewIcon.image = UIImage(systemName: block.icon)!
        iconSelect.selectIcon.image = UIImage(systemName: block.icon)!
    }
    
    func updateTaskLabel(_ text: String) {
        blockTaskLabel.text = text == "" ? "블럭 쌓기" : text
    }
    
    func updateColorTag(_ color: UIColor) {
        blockPreviewColorTag.backgroundColor = color
    }
    
    func updateIcon(_ image: UIImage) {
        blockPreviewIcon.image = image
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
        [blockPreview, taskLabelTextField, selectFormStackView]
            .forEach { addSubview($0) }
        
        /// 2. translatesAutoresizingMaskIntoConstraints = false
        [
            blockPreview, blockPreviewColorTag, blockPreviewIcon,
            blockTaskLabel, taskLabelTextField, selectFormStackView,
            groupSelect, iconSelect
        ]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }

    func setupConstraints() {
        
        /// 3. NSLayoutConstraint.activate
        NSLayoutConstraint.activate([
            
            // blockPreview
            blockPreview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            blockPreview.centerXAnchor.constraint(equalTo: centerXAnchor),
            blockPreview.widthAnchor.constraint(equalToConstant: Size.blockSize.width),
            blockPreview.heightAnchor.constraint(equalTo: blockPreview.widthAnchor),
            
            // blockColorTag
            blockPreviewColorTag.topAnchor.constraint(equalTo: blockPreview.topAnchor),
            blockPreviewColorTag.trailingAnchor.constraint(equalTo: blockPreview.trailingAnchor, constant: -32),
            blockPreviewColorTag.widthAnchor.constraint(equalToConstant: 20),
            blockPreviewColorTag.heightAnchor.constraint(equalToConstant: 30),
            
            // blockIcon
            blockPreviewIcon.topAnchor.constraint(equalTo: blockPreview.topAnchor, constant: 54),
            blockPreviewIcon.centerXAnchor.constraint(equalTo: blockPreview.centerXAnchor),
            blockPreviewIcon.widthAnchor.constraint(equalToConstant: 56),
            blockPreviewIcon.heightAnchor.constraint(equalToConstant: 56),

            // blockLabel
            blockTaskLabel.topAnchor.constraint(equalTo: blockPreviewIcon.bottomAnchor, constant: 12),
            blockTaskLabel.leadingAnchor.constraint(equalTo: blockPreview.leadingAnchor, constant: 20),
            blockTaskLabel.trailingAnchor.constraint(equalTo: blockPreview.trailingAnchor, constant: -20),
            
            // taskLabelTextField
            taskLabelTextField.topAnchor.constraint(equalTo: blockPreview.bottomAnchor, constant: 32),
            taskLabelTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            taskLabelTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.margin),
            
            // selectFormStackView
            selectFormStackView.topAnchor.constraint(equalTo: taskLabelTextField.bottomAnchor, constant: 8),
            selectFormStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            selectFormStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
