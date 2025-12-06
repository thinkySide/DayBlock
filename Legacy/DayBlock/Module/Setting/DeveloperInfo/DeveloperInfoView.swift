//
//  DeveloperInfoView.swift
//  DayBlock
//
//  Created by 김민준 on 12/19/23.
//

import UIKit

final class DeveloperInfoView: UIView {
    
    private let appIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: StartImage.appIconSVG)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let thinkySide: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Poppins.bold, size: 26)
        label.textColor = Color.mainText
        label.textAlignment = .center
        label.text = "thinkySide"
        return label
    }()
    
    private let minjoonKim: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Poppins.bold, size: 16)
        label.textColor = UIColor(rgb: 0x777777)
        label.textAlignment = .center
        label.text = "Minjoon Kim"
        return label
    }()
    
    private let dashedSeparatorTop = DashedSeparator(frame: .zero)
    
    private let careerTag: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.semiBold, size: 13)
        label.textColor = UIColor(rgb: 0x676767)
        label.textAlignment = .left
        label.text = "Career"
        return label
    }()
    
    private let careerValue: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.semiBold, size: 14)
        label.textColor = Color.mainText
        label.textAlignment = .right
        label.text = "iOS Developer & UX Researcher"
        return label
    }()
    
    private let contactTag: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.semiBold, size: 13)
        label.textColor = UIColor(rgb: 0x676767)
        label.textAlignment = .left
        label.text = "Contact"
        return label
    }()
    
    private let contactValue: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.semiBold, size: 14)
        label.textColor = Color.mainText
        label.textAlignment = .right
        label.text = "eunlyuing@gmail.com"
        return label
    }()
    
    private let githubTag: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.semiBold, size: 13)
        label.textColor = UIColor(rgb: 0x676767)
        label.textAlignment = .left
        label.text = "Github"
        return label
    }()
    
    let githubValue: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.semiBold, size: 14)
        label.textColor = UIColor(rgb: 0x3589D7)
        label.textAlignment = .right
        label.text = "https://github.com/thinkySide"
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let dashedSeparatorBottom = DashedSeparator(frame: .zero)
    
    private let explanationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.semiBold, size: 14)
        label.textColor = UIColor(rgb: 0x616161)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = """
        우리 모두는 하루를 다양한 시간으로 채워가고 있어요. 그중 기록하고 싶은 시간들을 블럭으로 만들고 쌓아가다 보면 노력과 열정의 흔적을 데이블럭에서 확인할 수 있을 거에요.
        """
        
        label.asFontColor(targetString: "",
                          font: UIFont(name: Pretendard.semiBold, size: 14),
                          color: UIColor(rgb: 0xAAAAAA), lineSpacing: 8, alignment: .left)
        return label
    }()
    
    // MARK: - Initial Method
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAutoLayout() {
        [appIcon, thinkySide, minjoonKim, dashedSeparatorTop,
         careerTag, careerValue,
         contactTag, contactValue,
         githubTag, githubValue,
         dashedSeparatorBottom, explanationLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            appIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            appIcon.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            appIcon.widthAnchor.constraint(equalToConstant: 64),
            appIcon.heightAnchor.constraint(equalToConstant: 64),
            
            thinkySide.centerXAnchor.constraint(equalTo: centerXAnchor),
            thinkySide.topAnchor.constraint(equalTo: appIcon.bottomAnchor, constant: 12),
            
            minjoonKim.centerXAnchor.constraint(equalTo: centerXAnchor),
            minjoonKim.topAnchor.constraint(equalTo: thinkySide.bottomAnchor, constant: 0),
            
            dashedSeparatorTop.topAnchor.constraint(equalTo: minjoonKim.bottomAnchor, constant: 32),
            dashedSeparatorTop.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            dashedSeparatorTop.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            careerTag.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            careerTag.centerYAnchor.constraint(equalTo: careerValue.centerYAnchor),
            
            careerValue.topAnchor.constraint(equalTo: dashedSeparatorTop.bottomAnchor, constant: 32),
            careerValue.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            contactTag.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            contactTag.centerYAnchor.constraint(equalTo: contactValue.centerYAnchor),
            
            contactValue.topAnchor.constraint(equalTo: careerValue.bottomAnchor, constant: 32),
            contactValue.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            githubTag.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            githubTag.centerYAnchor.constraint(equalTo: githubValue.centerYAnchor),
            
            githubValue.topAnchor.constraint(equalTo: contactValue.bottomAnchor, constant: 32),
            githubValue.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            dashedSeparatorBottom.topAnchor.constraint(equalTo: githubValue.bottomAnchor, constant: 32),
            dashedSeparatorBottom.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            dashedSeparatorBottom.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            explanationLabel.topAnchor.constraint(equalTo: dashedSeparatorBottom.bottomAnchor, constant: 32),
            explanationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            explanationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)
        ])
    }
}
