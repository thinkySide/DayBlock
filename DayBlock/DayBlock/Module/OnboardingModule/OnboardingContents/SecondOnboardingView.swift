//
//  SecondOnboardingView.swift
//  DayBlock
//
//  Created by 김민준 on 12/15/23.
//

import UIKit

final class SecondOnboardingView: UIView {
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        let text = """
        블럭은 30분에 반 개
        60분에 한 개씩 생산할 수 있어요
        """
        label.font = UIFont(name: Pretendard.medium, size: 20)
        label.textColor = Color.mainText
        label.numberOfLines = 2
        label.text = text
        label.asFontColor(targetString: "30분에 반 개\n60분에 한 개",
                          font: UIFont(name: Pretendard.bold, size: 20),
                          color: Color.mainText, lineSpacing: 4, alignment: .center)
        return label
    }()
    
    private let image: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: OnboardingImage.second)
        return imageView
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        let text = "“최소 30분 이상 생산해야 블럭이 생겨요“"
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
        
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            image.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 32),
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 226),
            subLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
