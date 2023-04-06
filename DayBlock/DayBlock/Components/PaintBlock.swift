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
    
    
    
    // MARK: - Method
    
    func painting(_ area: Paint) {
    
        /// 블럭 초기화
        backgroundColor = GrayScale.entireBlock
        firstHalf.backgroundColor = .clear
        secondHalf.backgroundColor = .clear
        
        /// 색상 변경
        switch area {
        case .firstHalf:
            firstHalf.backgroundColor = .systemBlue
        case .secondHalf:
            secondHalf.backgroundColor = .systemBlue
        case .fullTime:
            backgroundColor = .systemBlue
        case .none:
            backgroundColor = GrayScale.entireBlock
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /// Blcok Color
        self.backgroundColor = GrayScale.entireBlock
        
        /// AddSubView & resizingMask
        [firstHalf, secondHalf]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        /// Constraints
        NSLayoutConstraint.activate([
            /// self(paintBlock)
            self.widthAnchor.constraint(equalToConstant: 18),
            self.heightAnchor.constraint(equalToConstant: 18),
            
            /// firstHalf
            firstHalf.topAnchor.constraint(equalTo: topAnchor),
            firstHalf.bottomAnchor.constraint(equalTo: bottomAnchor),
            firstHalf.leadingAnchor.constraint(equalTo: leadingAnchor),
            firstHalf.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            /// secondHalf
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
        firstHalf.layer.cornerRadius = cornerRadius
        secondHalf.layer.cornerRadius = cornerRadius
    }
    
}
