//
//  IconSectionBar.swift
//  DayBlock
//
//  Created by 김민준 on 1/4/24.
//

import UIKit

final class IconSectionBar: UIView {
    
    enum Active {
        case first
        case second
        case third
        case fourth
        case fifth
        case sixth
    }
    
    let firstSection: IconSection = {
        let section = IconSection(state: .active)
        section.label.text = "전체"
        return section
    }()
    
    let secondSection: IconSection = {
        let section = IconSection(state: .inActive)
        section.label.text = "사물"
        return section
    }()
    
    let thirdSection: IconSection = {
        let section = IconSection(state: .inActive)
        section.label.text = "자연"
        return section
    }()
    
    let fourthSection: IconSection = {
        let section = IconSection(state: .inActive)
        section.label.text = "건강"
        return section
    }()
    
    let fifthSection: IconSection = {
        let section = IconSection(state: .inActive)
        section.label.text = "운동"
        return section
    }()
    
    let sixthSection: IconSection = {
        let section = IconSection(state: .inActive)
        section.label.text = "교통"
        return section
    }()
    
    lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            firstSection, secondSection, thirdSection, fourthSection, fifthSection, sixthSection
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    private let separator = Separator()
    
    // MARK: - Event Method
    func active(_ active: Active) {
        Vibration.selection.vibrate()
        switch active {
        case .first:
            firstSection.switchState(isActive: true)
            secondSection.switchState(isActive: false)
            thirdSection.switchState(isActive: false)
            fourthSection.switchState(isActive: false)
            fifthSection.switchState(isActive: false)
            sixthSection.switchState(isActive: false)
        case .second:
            firstSection.switchState(isActive: false)
            secondSection.switchState(isActive: true)
            thirdSection.switchState(isActive: false)
            fourthSection.switchState(isActive: false)
            fifthSection.switchState(isActive: false)
            sixthSection.switchState(isActive: false)
        case .third:
            firstSection.switchState(isActive: false)
            secondSection.switchState(isActive: false)
            thirdSection.switchState(isActive: true)
            fourthSection.switchState(isActive: false)
            fifthSection.switchState(isActive: false)
            sixthSection.switchState(isActive: false)
        case .fourth:
            firstSection.switchState(isActive: false)
            secondSection.switchState(isActive: false)
            thirdSection.switchState(isActive: false)
            fourthSection.switchState(isActive: true)
            fifthSection.switchState(isActive: false)
            sixthSection.switchState(isActive: false)
        case .fifth:
            firstSection.switchState(isActive: false)
            secondSection.switchState(isActive: false)
            thirdSection.switchState(isActive: false)
            fourthSection.switchState(isActive: false)
            fifthSection.switchState(isActive: true)
            sixthSection.switchState(isActive: false)
        case .sixth:
            firstSection.switchState(isActive: false)
            secondSection.switchState(isActive: false)
            thirdSection.switchState(isActive: false)
            fourthSection.switchState(isActive: false)
            fifthSection.switchState(isActive: false)
            sixthSection.switchState(isActive: true)
        }
    }
    
    // MARK: - Initial Method
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        separator.backgroundColor = UIColor(rgb: 0xF7F7F7)
        
        [separator, hStackView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            hStackView.topAnchor.constraint(equalTo: topAnchor),
            hStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            hStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            hStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Section
final class IconSection: UIButton {
    
    enum State {
        case active
        case inActive
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.semiBold, size: 15)
        label.textColor = Color.mainText
        label.textAlignment = .center
        label.text = "섹션"
        return label
    }()
    
    let activeLine: UIView = {
        let line = UIView()
        line.backgroundColor = Color.mainText
        return line
    }()
    
    func switchState(isActive: Bool) {
        if isActive {
            label.textColor = Color.mainText
            activeLine.backgroundColor = Color.mainText
            activeLine.alpha = 1
        } else {
            label.textColor = Color.disabledText
            activeLine.backgroundColor = UIColor(rgb: 0xF7F7F7)
            activeLine.alpha = 0
        }
    }
    
    init(state: State) {
        super.init(frame: .zero)
        
        switch state {
        case .active:
            switchState(isActive: true)
        case .inActive:
            switchState(isActive: false)
        }
        
        [label, activeLine].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 42),
            
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            activeLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            activeLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            activeLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            activeLine.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
