//
//  FourthOnboardingView.swift
//  DayBlock
//
//  Created by 김민준 on 12/15/23.
//

import UIKit

final class FourthOnboardingView: UIView {
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        let text = """
        하루하루 데이블럭과 함께
        블럭을 채워나가볼까요?
        """
        label.font = UIFont(name: Pretendard.medium, size: 20)
        label.textColor = Color.mainText
        label.numberOfLines = 2
        label.text = text
        label.asFontColor(targetString: "하루하루 데이블럭과 함께",
                          font: UIFont(name: Pretendard.bold, size: 20),
                          color: Color.mainText, lineSpacing: 4, alignment: .center)
        return label
    }()
    
    let trackingBlock: DayBlock = {
        let block = DayBlock(frame: .zero, blockSize: .middle)
        block.colorTag.backgroundColor = Color.mainText
        block.plus.textColor = Color.mainText
        block.outputLabel.text = "0.5"
        block.taskLabel.text = "첫번째 블럭 만들기"
        block.icon.image = UIImage(systemName: "party.popper.fill")
        block.backgroundColor = Color.mainText.withAlphaComponent(0.2)
        return block
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        let text = "“블럭을 길게 눌러 첫 생산을 완료해요”"
        label.font = UIFont(name: Pretendard.medium, size: 15)
        label.textColor = UIColor(rgb: 0x828282)
        label.textAlignment = .center
        label.text = text
        
        label.asFontColor(targetString: "블럭을 길게 눌러",
                          font: UIFont(name: Pretendard.bold, size: 15),
                          color: UIColor(rgb: 0x323232), lineSpacing: 0, alignment: .center)
        return label
    }()
    
    // MARK: - Initial Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAutoLayout()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAutoLayout() {
        [mainLabel, trackingBlock, subLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            trackingBlock.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 20),
            trackingBlock.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 226),
            subLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
