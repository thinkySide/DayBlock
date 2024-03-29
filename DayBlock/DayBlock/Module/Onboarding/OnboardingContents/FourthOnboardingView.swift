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
        block.taskLabel.text = "튜토리얼 블럭"
        block.icon.image = UIImage(systemName: "party.popper.fill")
        block.backgroundColor = Color.mainText.withAlphaComponent(0.2)
        return block
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        let text = "“블럭을 길-게 눌러 첫 생산을 완료해요”"
        label.font = UIFont(name: Pretendard.medium, size: 15)
        label.textColor = UIColor(rgb: 0x828282)
        label.textAlignment = .center
        label.text = text
        
        label.asFontColor(targetString: "블럭을 길-게 눌러",
                          font: UIFont(name: Pretendard.bold, size: 15),
                          color: UIColor(rgb: 0x323232), lineSpacing: 0, alignment: .center)
        return label
    }()
    
    let tutorialLabel: UILabel = {
        let label = UILabel()
        let text = "* 튜토리얼을 위해 30분짜리 블럭을 미리 생산해뒀어요!"
        label.font = UIFont(name: Pretendard.medium, size: 13)
        label.textColor = UIColor(rgb: 0xAAAAAA)
        label.textAlignment = .center
        label.text = text
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
        [mainLabel, trackingBlock, subLabel, tutorialLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // 기기별 사이즈 대응을 위한 분기
        let deviceHeight = UIScreen.main.deviceHeight
        
        // middle 사이즈
        if deviceHeight == .middle || deviceHeight == .small {
            NSLayoutConstraint.activate([
                mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
                mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                
                trackingBlock.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 38),
                trackingBlock.centerXAnchor.constraint(equalTo: centerXAnchor),
                
                subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 256),
                subLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                
                tutorialLabel.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 12),
                tutorialLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        }
        
        // large 사이즈
        else if deviceHeight == .large {
            NSLayoutConstraint.activate([
                mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
                mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                
                trackingBlock.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 52),
                trackingBlock.centerXAnchor.constraint(equalTo: centerXAnchor),
                
                subLabel.topAnchor.constraint(equalTo: trackingBlock.bottomAnchor, constant: 52),
                subLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                
                tutorialLabel.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 12),
                tutorialLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        }
    }
}
