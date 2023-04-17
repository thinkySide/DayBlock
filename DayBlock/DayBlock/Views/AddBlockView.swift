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
        image.tintColor = GrayScale.mainText
        return image
    }()
    
    private let blockTaskLabel: UILabel = {
        let label = UILabel()
        label.text = "블럭 쌓기" // ⛳️
        label.font = UIFont(name: Pretendard.bold, size: 17)
        label.textColor = GrayScale.mainText
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    lazy var taskLabelTextField: FieldForm = {
        let field = FieldForm()
        field.textField.addTarget(self, action: #selector(taskLabelTextFieldChanged), for: .editingChanged)
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
    
    let groupSelect: SelectForm = {
        let select = SelectForm()
        select.ofType("그룹", .group)
        return select
    }()
    
    let colorSelect: SelectForm = {
        let select = SelectForm()
        select.ofType("색상", .color)
        return select
    }()
    
    let iconSelect: SelectForm = {
        let select = SelectForm()
        select.ofType("아이콘", .icon)
        return select
    }()
    
    
    
    // MARK: - Variable
    
    
    
    // MARK: - Method
    
    @objc func taskLabelTextFieldChanged() {
        guard let text = taskLabelTextField.textField.text else { return }
        taskLabelTextField.countLabel.text = "\(text.count)/18"
    }
    
    /// Block 정보 업데이트
    func updateBlockInfo(_ group: Group) {
        let block = group.list[0]
        groupSelect.selectLabel.text = group.name
        blockTaskLabel.text = block.taskLabel
        colorSelect.selectColor.backgroundColor = block.color
        iconSelect.selectIcon.image = block.icon
    }
    
    func updateTaskLabel(_ text: String) {
        blockTaskLabel.text = text == "" ? "블럭 쌓기" : text
    }

//    func updateBlockInfo(for select: Select, _ value: Any?) {
//        switch select {
//        case .taskLabel:
//            let text = value as? String
//            blockTaskLabel.text = text == "" ? "블럭 쌓기" : value as? String
//
//        case .group:
//            break
//
//        case .color:
//            break
//
//        case .icon:
//            break
//        }
//    }
    
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
            blockPreview, taskLabelTextField, selectFormStackView,
        ]
            .forEach { addSubview($0) }
        
        /// 2. translatesAutoresizingMaskIntoConstraints = false
        [
            blockPreview, blockPreviewColorTag, blockPreviewIcon,
            blockTaskLabel, taskLabelTextField, selectFormStackView,
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
            blockTaskLabel.topAnchor.constraint(equalTo: blockPreviewIcon.bottomAnchor, constant: 12),
            blockTaskLabel.leadingAnchor.constraint(equalTo: blockPreview.leadingAnchor, constant: 20),
            blockTaskLabel.trailingAnchor.constraint(equalTo: blockPreview.trailingAnchor, constant: -20),
            
            /// nameTextField
            taskLabelTextField.topAnchor.constraint(equalTo: blockPreview.bottomAnchor, constant: 32),
            taskLabelTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            taskLabelTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.margin),
            
            /// selectFormStackView
            selectFormStackView.topAnchor.constraint(equalTo: taskLabelTextField.bottomAnchor, constant: 24),
            selectFormStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            selectFormStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
