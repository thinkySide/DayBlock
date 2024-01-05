//
//  ThirdOnboardingView.swift
//  DayBlock
//
//  Created by 김민준 on 12/15/23.
//

import UIKit

final class ThirdOnboardingView: UIView {
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        let text = """
        직접 만든 블럭으로 생산성을
        얼마나 발휘 했는지 트래킹해요
        """
        label.font = UIFont(name: Pretendard.medium, size: 20)
        label.textColor = Color.mainText
        label.numberOfLines = 2
        label.text = text
        label.asFontColor(targetString: "생산성을\n얼마나 발휘 했는지 트래킹",
                          font: UIFont(name: Pretendard.bold, size: 20),
                          color: Color.mainText, lineSpacing: 4, alignment: .center)
        return label
    }()
    
    private let image: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: OnboardingImage.third)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        let text = "“공부, 운동, 독서 어떤 작업이든 트래킹해요”"
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
            
            image.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 0),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            subLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 0),
            subLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
