//
//  PageNumbers.swift
//  DayBlock
//
//  Created by 김민준 on 12/15/23.
//

import UIKit

final class PageNumbers: UIStackView {
    
    enum PageCount: Int {
        case three = 3
        case four = 4
        case five = 5
    }
    
    let first: UIView = {
        let circle = UIView()
        circle.clipsToBounds = true
        circle.layer.cornerRadius = 4
        circle.backgroundColor = Color.mainText
        return circle
    }()
    
    let second: UIView = {
        let circle = UIView()
        circle.clipsToBounds = true
        circle.layer.cornerRadius = 4
        circle.backgroundColor = Color.entireBlock
        return circle
    }()
    
    let third: UIView = {
        let circle = UIView()
        circle.clipsToBounds = true
        circle.layer.cornerRadius = 4
        circle.backgroundColor = Color.entireBlock
        return circle
    }()
    
    let fourth: UIView = {
        let circle = UIView()
        circle.clipsToBounds = true
        circle.layer.cornerRadius = 4
        circle.backgroundColor = Color.entireBlock
        return circle
    }()
    
    let fifth: UIView = {
        let circle = UIView()
        circle.clipsToBounds = true
        circle.layer.cornerRadius = 4
        circle.backgroundColor = Color.entireBlock
        return circle
    }()
    
    // MARK: - Event Method
    func switchPage(to number: Int) {
        
        UIView.animate(withDuration: 0.3, delay: 0) { [weak self] in
            guard let self else { return }
            
            if number == 0 {
                first.backgroundColor = Color.mainText
                second.backgroundColor = Color.entireBlock
                third.backgroundColor = Color.entireBlock
                fourth.backgroundColor = Color.entireBlock
                fifth.backgroundColor = Color.entireBlock
                return
            }
            
            if number == 1 {
                first.backgroundColor = Color.entireBlock
                second.backgroundColor = Color.mainText
                third.backgroundColor = Color.entireBlock
                fourth.backgroundColor = Color.entireBlock
                fifth.backgroundColor = Color.entireBlock
                return
            }
            
            if number == 2 {
                first.backgroundColor = Color.entireBlock
                second.backgroundColor = Color.entireBlock
                third.backgroundColor = Color.mainText
                fourth.backgroundColor = Color.entireBlock
                fifth.backgroundColor = Color.entireBlock
                return
            }
            
            if number == 3 {
                first.backgroundColor = Color.entireBlock
                second.backgroundColor = Color.entireBlock
                third.backgroundColor = Color.entireBlock
                fourth.backgroundColor = Color.mainText
                fifth.backgroundColor = Color.entireBlock
                return
            }
            
            if number == 4 {
                first.backgroundColor = Color.entireBlock
                second.backgroundColor = Color.entireBlock
                third.backgroundColor = Color.entireBlock
                fourth.backgroundColor = Color.entireBlock
                fifth.backgroundColor = Color.mainText
                return
            }
        }
    }
    
    // MARK: - Initial Method
    init(pageCount: PageCount) {
        super.init(frame: .zero)
        setupStackView()
        switch pageCount {
        case .three:
            [first, second, third].forEach { addArrangedSubview($0) }
            
        case .four:
            [first, second, third, fourth].forEach { addArrangedSubview($0) }
            
        case .five:
            [first, second, third, fourth, fifth].forEach { addArrangedSubview($0) }
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStackView() {
        self.spacing = 12
        self.axis = .horizontal
        self.alignment = .center
        self.distribution = .fill
        
        // Circle 크기
        NSLayoutConstraint.activate([
            first.widthAnchor.constraint(equalToConstant: 8),
            first.heightAnchor.constraint(equalToConstant: 8),
            
            second.widthAnchor.constraint(equalToConstant: 8),
            second.heightAnchor.constraint(equalToConstant: 8),
            
            third.widthAnchor.constraint(equalToConstant: 8),
            third.heightAnchor.constraint(equalToConstant: 8),
            
            fourth.widthAnchor.constraint(equalToConstant: 8),
            fourth.heightAnchor.constraint(equalToConstant: 8),
            
            fifth.widthAnchor.constraint(equalToConstant: 8),
            fifth.heightAnchor.constraint(equalToConstant: 8)
        ])
    }
}
