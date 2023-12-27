//
//  ResetDataView.swift
//  DayBlock
//
//  Created by 김민준 on 12/14/23.
//

import UIKit

final class ResetDataView: UIView {
    
    private let explanationLabel: UILabel = {
        let label = UILabel()
        let text = """
        초기화 작업 실행 시 그룹 및 블럭 정보와 저장된
        모든 트래킹 데이터가 삭제됩니다.
        """
        label.font = UIFont(name: Pretendard.medium, size: 14)
        label.textColor = Color.subText2
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = text
        label.asFontColor(targetString: "모든 트래킹 데이터가 삭제",
                          font: UIFont(name: Pretendard.semiBold, size: 14),
                          color: UIColor(rgb: 0xD23939), lineSpacing: 4, alignment: .left)
        return label
    }()
    
    let deleteButton: ActionButton = {
        let button = ActionButton(frame: .zero, mode: .delete)
        button.setTitle("초기화하기", for: .normal)
        return button
    }()
    
    // MARK: - Initial Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAutoLayout() {
        [explanationLabel, deleteButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            explanationLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            explanationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            explanationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            deleteButton.topAnchor.constraint(equalTo: explanationLabel.bottomAnchor, constant: 32),
            deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.margin)
        ])
    }
}
