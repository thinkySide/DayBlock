//
//  BoardBlock.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/05.
//

import UIKit

final class TrackingBoardBlock: UIView {
    
    /// 블럭 색칠 상태
    enum Paint {
        case firstHalf
        case secondHalf
        case fullTime
        case none
    }
    
    /// 전체 색칠 상태
    private let full: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    /// 00~29 까지의 첫번째 반쪽 색칠 상태
    private let firstHalf: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    /// 30~59 까지의 두번째 반쪽 색칠 상태
    private let secondHalf: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    /// 현재 블럭 색칠 상태
    var state: Paint?
    
    // MARK: - Method
    
    /// 블럭 색칠 메서드
    func painting(_ area: Paint, color: UIColor = Color.entireBlock) {
        
        // 상태 변경
        state = area
    
        // 블럭 초기화
        backgroundColor = Color.entireBlock
        firstHalf.backgroundColor = .clear
        secondHalf.backgroundColor = .clear
        
        // 색상 변경
        switch area {
        case .firstHalf: firstHalf.backgroundColor = color
        case .secondHalf: secondHalf.backgroundColor = color
        case .fullTime: backgroundColor = color
        case .none: backgroundColor = Color.entireBlock
        }
    }
    
    /// 블럭 애니메이션 설정 메서드
    func configureAnimation(_ area: Paint, color: UIColor = Color.entireBlock, isPaused: Bool) {
        
        // 상태 변경
        state = area
        
        // 블럭 초기화
        backgroundColor = Color.entireBlock
        full.backgroundColor = .clear
        firstHalf.backgroundColor = .clear
        secondHalf.backgroundColor = .clear
        
        // 깜빡이 애니메이션
        switch state {
        case .firstHalf: animate(firstHalf, color: color, isPaused: isPaused)
        case .secondHalf: animate(secondHalf, color: color, isPaused: isPaused)
        case .fullTime: animate(full, color: color, isPaused: isPaused)
        case .none?: backgroundColor = Color.entireBlock
        case nil:
            break
        }
    }
    
    /// 실제 블럭 애니메이션 동작 메서드
    private func animate(_ area: UIView, color: UIColor, isPaused: Bool) {
        
        // 애니메이션 활성화 상태
        if !isPaused {
            area.backgroundColor = color
            UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse, .curveEaseInOut]) {
                area.alpha = 0
            }
        }
        
        // 애니메이션 중지 상태
        if isPaused {
            area.backgroundColor = UIColor(rgb: 0xB0B3BB)
            area.layer.removeAllAnimations()
            area.alpha = 1
        }
    }
    
    // MARK: - Initial Method
    
    init(frame: CGRect, size: CGFloat) {
        // self.state = paint
        super.init(frame: frame)
        
        /// Blcok Color
        self.backgroundColor = Color.entireBlock
        
        /// AddSubView & resizingMask
        [full, firstHalf, secondHalf]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        /// Constraints
        NSLayoutConstraint.activate([
            
            // self(paintBlock)
            self.widthAnchor.constraint(equalToConstant: size),
            self.heightAnchor.constraint(equalToConstant: size),
            
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
            secondHalf.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5)
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
