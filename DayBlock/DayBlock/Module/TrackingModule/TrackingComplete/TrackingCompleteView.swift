//
//  TrackingCompleteView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/23.
//

import UIKit

final class TrackingCompleteView: UIView {
    
    // MARK: - Properties
    
    let backToHomeButton: ActionButton = {
        let button = ActionButton(frame: .zero, mode: .confirm)
        button.setTitle("홈 화면으로 돌아가기", for: .normal)
        return button
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            iconBlock, taskLabel])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 16
        return stack
    }()
    
    let iconBlock: SimpleIconBlock = {
        let icon = SimpleIconBlock()
        return icon
    }()
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.text = "Swift 공부"
        label.font = UIFont(name: Pretendard.bold, size: 20)
        label.textColor = Color.mainText
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private let dashedSeparator = DashedSeparator(frame: .zero)
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "2023년 09월 12일 화요일"
        label.font = UIFont(name: Pretendard.semiBold, size: 16)
        label.textColor = UIColor(rgb: 0x8E8E8E)
        label.textAlignment = .center
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "14:05 ~ 15:35"
        label.font = UIFont(name: Poppins.bold, size: 30)
        label.textColor = Color.mainText
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Summary Label
    
    lazy var summaryLabel: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            leftSummaryLabel, plusSummaryLabel, mainSummaryLabel, rightSummaryLabel])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 0
        return stack
    }()
    
    let leftSummaryLabel: UILabel = {
        let label = UILabel()
        label.text = "블럭"
        label.font = UIFont(name: Pretendard.bold, size: 18)
        label.textColor = Color.mainText
        label.textAlignment = .left
        return label
    }()
    
    let plusSummaryLabel: UILabel = {
        let label = UILabel()
        label.text = "+"
        label.font = UIFont(name: Poppins.bold, size: 24)
        label.textColor = Color.testBlue
        label.textAlignment = .left
        return label
    }()
    
    let mainSummaryLabel: UILabel = {
        let label = UILabel()
        label.text = "2.5"
        label.font = UIFont(name: Poppins.bold, size: 24)
        label.textColor = Color.mainText
        label.textAlignment = .left
        return label
    }()
    
    let rightSummaryLabel: UILabel = {
        let label = UILabel()
        label.text = "개를 생산했어요!"
        label.font = UIFont(name: Pretendard.bold, size: 18)
        label.textColor = Color.mainText
        label.textAlignment = .left
        return label
    }()
    
    let trackingBoard: TrackingBoard = {
        let preview = TrackingBoard(frame: .zero, blockSize: 32, spacing: 8)
        return preview
    }()
    
    // MARK: - bottom Component
    
    let totalValue: UILabel = {
        let label = UILabel()
        label.text = "0.0" // ⛳️
        label.font = UIFont(name: Poppins.bold, size: 20)
        label.textColor = Color.mainText
        label.textAlignment = .center
        return label
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "total"
        label.font = UIFont(name: Poppins.bold, size: 14)
        label.textColor = Color.subText2
        label.textAlignment = .center
        return label
    }()
    
    let bottomSeparator: UIView = {
        let line = UIView()
        line.backgroundColor = Color.seperator2
        return line
    }()
    
    let todayValue: UILabel = {
        let label = UILabel()
        label.text = "0.0" // ⛳️
        label.font = UIFont(name: Poppins.bold, size: 20)
        label.textColor = Color.mainText
        label.textAlignment = .center
        return label
    }()
    
    let todayLabel: UILabel = {
        let label = UILabel()
        label.text = "today"
        label.font = UIFont(name: Poppins.bold, size: 14)
        label.textColor = Color.subText2
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initial Method
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupAddView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Auto Layout Method
    
    private func setupAddView() {
        [titleStackView,
         dashedSeparator,
         dateLabel, timeLabel,
         summaryLabel,
         trackingBoard,
         totalValue, totalLabel, bottomSeparator, todayValue, todayLabel,
         backToHomeButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            // titleStackView
            titleStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 56),
            titleStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // dashedSeparator
            dashedSeparator.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 32),
            dashedSeparator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 86),
            dashedSeparator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -86),
            
            // dateLabel
            dateLabel.topAnchor.constraint(equalTo: dashedSeparator.bottomAnchor, constant: 32),
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // timeLabel
            timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 0),
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // summaryLabel
            summaryLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 44),
            summaryLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // blockPreview
            trackingBoard.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 8),
            trackingBoard.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // totalValue
            totalValue.topAnchor.constraint(equalTo: trackingBoard.bottomAnchor, constant: 44),
            totalValue.trailingAnchor.constraint(equalTo: bottomSeparator.leadingAnchor, constant: -18),
            
            // totalLabel
            totalLabel.topAnchor.constraint(equalTo: totalValue.bottomAnchor),
            totalLabel.centerXAnchor.constraint(equalTo: totalValue.centerXAnchor),
            
            // bottomSeparator
            bottomSeparator.topAnchor.constraint(equalTo: trackingBoard.bottomAnchor, constant: 60),
            bottomSeparator.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomSeparator.widthAnchor.constraint(equalToConstant: 2),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 20),
            
            // todayValue
            todayValue.topAnchor.constraint(equalTo: trackingBoard.bottomAnchor, constant: 44),
            todayValue.leadingAnchor.constraint(equalTo: bottomSeparator.leadingAnchor, constant: 18),
            
            // todayLabel
            todayLabel.topAnchor.constraint(equalTo: todayValue.bottomAnchor),
            todayLabel.centerXAnchor.constraint(equalTo: todayValue.centerXAnchor),

            // backToHomeButton
            backToHomeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.margin),
            backToHomeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.margin),
            backToHomeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -56)
        ])
    }
}
