//
//  PaintBlock.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/05.
//

import UIKit

final class PaintBlock: UIView {
    
    enum Paint {
        case firstHalf
        case secondHalf
        case fullTime
        case none
    }
    
    private let full: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    private let firstHalf: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    private let secondHalf: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    var state: Paint = .none
    
    
    // MARK: - Method
    
    func painting(_ area: Paint, color: UIColor) {
        
        // 상태 변경
        state = area
    
        // 블럭 초기화
        backgroundColor = GrayScale.entireBlock
        firstHalf.backgroundColor = .clear
        secondHalf.backgroundColor = .clear
        
        // 색상 변경
        switch area {
        case .firstHalf:
            firstHalf.backgroundColor = color
        case .secondHalf:
            secondHalf.backgroundColor = color
        case .fullTime:
            backgroundColor = color
        case .none:
            backgroundColor = GrayScale.entireBlock
        }
    }
    
    func animation(_ area: Paint, color: UIColor = GrayScale.entireBlock) {
        
        // 상태 변경
        state = area
    
        // 블럭 초기화
        backgroundColor = GrayScale.entireBlock
        full.backgroundColor = .clear
        firstHalf.backgroundColor = .clear
        secondHalf.backgroundColor = .clear
        
        // 깜빡이 애니메이션
        switch area {
        case .firstHalf:
            firstHalf.backgroundColor = color
            UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse, .curveEaseInOut]) {
                self.firstHalf.alpha = 0
            }
            
        case .secondHalf:
            secondHalf.backgroundColor = color
            UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse, .curveEaseInOut]) {
                self.secondHalf.alpha = 0
            }
            
        case .fullTime:
            full.backgroundColor = color
            UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse, .curveEaseInOut]) {
                self.full.alpha = 0
            }
            
        case .none:
            backgroundColor = GrayScale.entireBlock
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /// Blcok Color
        self.backgroundColor = GrayScale.entireBlock
        
        /// AddSubView & resizingMask
        [full, firstHalf, secondHalf]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        /// Constraints
        NSLayoutConstraint.activate([
            
            // self(paintBlock)
            self.widthAnchor.constraint(equalToConstant: 18),
            self.heightAnchor.constraint(equalToConstant: 18),
            
            // full
            full.topAnchor.constraint(equalTo: topAnchor),
            full.bottomAnchor.constraint(equalTo: bottomAnchor),
            full.leadingAnchor.constraint(equalTo: leadingAnchor),
            full.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // firstHalf
            firstHalf.topAnchor.constraint(equalTo: topAnchor),
            firstHalf.bottomAnchor.constraint(equalTo: bottomAnchor),
            firstHalf.leadingAnchor.constraint(equalTo: leadingAnchor),
            firstHalf.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            // secondHalf
            secondHalf.topAnchor.constraint(equalTo: topAnchor),
            secondHalf.bottomAnchor.constraint(equalTo: bottomAnchor),
            secondHalf.trailingAnchor.constraint(equalTo: trailingAnchor),
            secondHalf.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        /// ConrerRadius
        let cornerRadius = self.frame.height / 4
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        full.layer.cornerRadius = cornerRadius
        firstHalf.layer.cornerRadius = cornerRadius
        secondHalf.layer.cornerRadius = cornerRadius
    }
    
}
