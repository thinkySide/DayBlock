//
//  BoardBlock.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/05.
//

import UIKit

final class TrackingBoardBlock: UIView {
    
    /// 첫번째 반쪽 애니메이션 확인용 변수
    var isFirstHalfAnimate = false
    
    /// 블럭 색칠 상태
    enum Paint {
        case none
        case firstHalf
        case secondHalf
        case mixed
    }
    
    /// 전체 색칠 상태
    let full: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.alpha = 0
        return view
    }()
    
    /// 00~29 까지의 첫번째 반쪽 색칠 상태
    let firstHalf: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    /// 30~59 까지의 두번째 반쪽 색칠 상태
    let secondHalf: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    /// mixed 상태의 첫번째 반쪽 색칠 상태
    let mixedFirstHalf: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    /// mixed 상태의 두번째 반쪽 색칠 상태
    let mixedSecondHalf: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    /// 현재 블럭 색칠 상태
    var paint: Paint
    
    
    
    // MARK: - Paint & Animation
    
    /// 첫번째 반쪽 블럭을 업데이트합니다.
    func updateFirstBlock(color: UIColor, isAnimated: Bool, isPaused: Bool) {
        
        // 1. 기존 애니메이션 삭제
        firstHalf.layer.removeAllAnimations()
        firstHalf.alpha = 1
        
        // 2. 빈 블럭일 경우 설정
        if color == Color.entireBlock {
            paint = .none
            firstHalf.backgroundColor = color
            return
        }
        
        // 3. 상태값 업데이트
        paint = .firstHalf
        
        // 4. 만약 일시정지 상태라면, 색 전환
        if isPaused {
            let pausedColor = UIColor(rgb: 0xB0B3BB)
            firstHalf.layer.removeAllAnimations()
            firstHalf.backgroundColor = pausedColor
            firstHalf.alpha = 1
            return
        }
        
        // 5. 색상 업데이트
        firstHalf.backgroundColor = color
        
        // 6. 애니메이션 업데이트
        if isAnimated {
            isFirstHalfAnimate = true
            startAlphaAnimation(to: firstHalf)
        } else {
            isFirstHalfAnimate = false
        }
    }
    
    /// 두번째 반쪽 블럭을 업데이트합니다.
    func updateSecondBlock(color: UIColor, isAnimated: Bool, isPaused: Bool) {
        
        // 1. 기존 애니메이션 삭제
        [secondHalf, mixedFirstHalf, mixedSecondHalf].forEach {
            $0.layer.removeAllAnimations()
            $0.alpha = 1
        }
        
        // 3. 이미 첫번째 반쪽이 채워져있다면, mixed로 전환
        if paint == .firstHalf {
            
            // 3-1. 빈 블럭일 경우 설정
            if color == Color.entireBlock {
                mixedFirstHalf.alpha = 0
                mixedSecondHalf.backgroundColor = color
                paint = .none
                return
            }
            
            // 3-2. 상태 업데이트
            paint = .mixed
            
            // 3-3. 만약 일시정지 상태라면, 색 전환
            if isPaused {
                let pausedColor = UIColor(rgb: 0xB0B3BB)
                [mixedFirstHalf, mixedSecondHalf].forEach {
                    $0.layer.removeAllAnimations()
                    $0.backgroundColor = pausedColor
                    $0.alpha = 1
                }
                return
            }
            
            // 3-4. 색상 업데이트
            let firstColor = firstHalf.backgroundColor
            mixedFirstHalf.backgroundColor = firstColor
            mixedSecondHalf.backgroundColor = color
            firstHalf.backgroundColor = .none
            
            // 3-5. 애니메이션 업데이트
            if isAnimated {
                startAlphaAnimation(to: mixedSecondHalf)
                
                // 첫번째 애니메이션도 실행되고 있을 때만 업데이트
                if isFirstHalfAnimate {
                    startAlphaAnimation(to: mixedFirstHalf)
                }
            }
        }
        
        // 4. 첫번째 반쪽이 비워져있다면, secondHalf로 전환
        else {
            
            // 4-1. 빈 블럭일 경우 설정
            if color == Color.entireBlock {
                secondHalf.backgroundColor = color
                paint = .none
                return
            }
            
            // 4-2. 상태값 업데이트
            paint = .secondHalf
            
            // 4-3. 만약 일시정지 상태라면, 색 전환
            if isPaused {
                let pausedColor = UIColor(rgb: 0xB0B3BB)
                secondHalf.layer.removeAllAnimations()
                secondHalf.backgroundColor = pausedColor
                secondHalf.alpha = 1
                return
            }
            
            // 4-4. 색상 업데이트
            secondHalf.backgroundColor = color
            
            // 4-5. 애니메이션 업데이트
            if isAnimated { startAlphaAnimation(to: secondHalf) }
        }
    }
    
    /// Alpha 애니메이션을 시작합니다.
    private func startAlphaAnimation(to view: UIView) {
        
        // 무한반복 애니메이션
        view.alpha = 0.0
        let options = UIView.AnimationOptions(arrayLiteral: [.autoreverse, .repeat])
        UIView.animate(withDuration: 1.0, delay: 0, options: options, animations: {
            view.alpha = 1.0
        }, completion: nil)
    }
    
    
    // MARK: - Initial Method
    
    init(frame: CGRect = .zero, size: CGFloat, paint: Paint = .none) {
        self.paint = paint
        super.init(frame: frame)
        
        /// Blcok Color
        self.backgroundColor = Color.entireBlock
        
        /// AddSubView & resizingMask
        [full, firstHalf, secondHalf, mixedFirstHalf, mixedSecondHalf]
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
            secondHalf.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            // mixedFirstHalf
            mixedFirstHalf.topAnchor.constraint(equalTo: topAnchor),
            mixedFirstHalf.bottomAnchor.constraint(equalTo: bottomAnchor),
            mixedFirstHalf.leadingAnchor.constraint(equalTo: leadingAnchor),
            mixedFirstHalf.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            // mixedSecondHalf
            mixedSecondHalf.topAnchor.constraint(equalTo: topAnchor),
            mixedSecondHalf.bottomAnchor.constraint(equalTo: bottomAnchor),
            mixedSecondHalf.trailingAnchor.constraint(equalTo: trailingAnchor),
            mixedSecondHalf.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // ConrerRadius
        let cornerRadius = self.frame.height / 4
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        full.layer.cornerRadius = cornerRadius
        firstHalf.layer.cornerRadius = cornerRadius
        secondHalf.layer.cornerRadius = cornerRadius
        mixedFirstHalf.layer.cornerRadius = cornerRadius
        mixedSecondHalf.layer.cornerRadius = cornerRadius
        
        // CornerRadius 부분 적용
        mixedFirstHalf.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        mixedFirstHalf.layer.masksToBounds = true
        mixedSecondHalf.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        mixedSecondHalf.layer.masksToBounds = true
    }
}
