//
//  SectionBar.swift
//  DayBlock
//
//  Created by 김민준 on 10/19/23.
//

import UIKit

final class SectionBar: UIView {
    
    let section1: Section = {
        let section = Section(state: .active)
        return section
    }()
    
    let section2: Section = {
        let section = Section(state: .inActive)
        return section
    }()
    
    lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [section1, section2])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    private let separator = Separator()
    
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
            hStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            hStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
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
final class Section: UIView {
    
    enum State {
        case active
        case inActive
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.semiBold, size: 16)
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
            activeLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        } else {
            label.textColor = Color.disabledText
            activeLine.backgroundColor = UIColor(rgb: 0xF7F7F7)
            activeLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
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
            self.heightAnchor.constraint(equalToConstant: 48),
            
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
