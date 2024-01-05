//
//  FirstOnboardingView.swift
//  DayBlock
//
//  Created by 김민준 on 12/15/23.
//

import UIKit

final class FirstOnboardingView: UIView {
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        let text = """
        데이블럭의 하루에는
        24개의 빈 블럭이 있어요
        """
        label.font = UIFont(name: Pretendard.medium, size: 20)
        label.textColor = Color.mainText
        label.numberOfLines = 2
        label.text = text
        label.asFontColor(targetString: "24개의 빈 블럭이 있어요",
                          font: UIFont(name: Pretendard.bold, size: 20),
                          color: Color.mainText, lineSpacing: 4, alignment: .center)
        return label
    }()
    
    private let image: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: OnboardingImage.first)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        let text = "“00:00분부터 23:59분까지가 하루에요”"
        label.font = UIFont(name: Pretendard.medium, size: 15)
        label.textColor = UIColor(rgb: 0x828282)
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
        [mainLabel, image, subLabel].forEach {
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
                
                image.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 0),
                image.leadingAnchor.constraint(equalTo: leadingAnchor),
                image.trailingAnchor.constraint(equalTo: trailingAnchor),
                
                subLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 0),
                subLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        }
        
        // large 사이즈
        else if deviceHeight == .large {
            NSLayoutConstraint.activate([
                mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
                mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                
                image.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 16),
                image.leadingAnchor.constraint(equalTo: leadingAnchor),
                image.trailingAnchor.constraint(equalTo: trailingAnchor),
                
                subLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 16),
                subLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        }
    }
}
