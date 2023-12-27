//
//  BoardBlock.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/05.
//

import UIKit

protocol TrackingBoardBlockDelegate: AnyObject {
    func trackingBoardBlock(animateWillRefresh isRefresh: Bool)
}

final class TrackingBoardBlock: UIView {
    
    weak var delegate: TrackingBoardBlockDelegate?
    
    /// 애니메이션 확인용 변수
    var isAnimate = false
    
    /// 다음 블럭 애니메이션을 대기하고 있는 상태 확인용 변수
    var isRefresh = false
    
    /// 블럭 색칠 상태
    enum Paint {
        case none
        case firstHalf
        case secondHalf
        case fullTime
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
    
    
    
    // MARK: - New Method
    
    /// 첫번째 반쪽 블럭을 업데이트합니다.
    func updateFirstBlock(color: UIColor, isAnimated: Bool, isPaused: Bool) {
        
        // 비워져있는 블럭으로 설정
        if color == Color.entireBlock {
            paint = .none
            firstHalf.backgroundColor = color
            return
        }
        
        // 상태 업데이트
        paint = .firstHalf
        
        // 만약 일시정지 상태라면, 색 전환
        if isPaused {
            let pausedColor = UIColor(rgb: 0xB0B3BB)
            firstHalf.layer.removeAllAnimations()
            firstHalf.backgroundColor = pausedColor
            firstHalf.alpha = 1
            return
        }
        
        // 색상 업데이트
        firstHalf.backgroundColor = color
        
        // 애니메이션 업데이트
        startAlphaAnimation(to: firstHalf)
    }
    
    /// 두번째 반쪽 블럭을 업데이트합니다.
    func updateSecondBlock(color: UIColor, isAnimated: Bool, isPaused: Bool) {
        
        // 비워져있는 블럭으로 설정
        if color == Color.entireBlock {
            secondHalf.backgroundColor = color
            paint = .none
            return
        }
        
        // 이미 첫번째 반쪽이 채워져있다면, mixed로 전환
        if paint == .firstHalf {
            
            // 상태 업데이트
            paint = .mixed
            
            // 만약 일시정지 상태라면, 색 전환
            if isPaused {
                let pausedColor = UIColor(rgb: 0xB0B3BB)
                mixedFirstHalf.layer.removeAllAnimations()
                mixedFirstHalf.backgroundColor = pausedColor
                mixedFirstHalf.alpha = 1
                
                mixedSecondHalf.layer.removeAllAnimations()
                mixedSecondHalf.backgroundColor = pausedColor
                mixedSecondHalf.alpha = 1
                return
            }
            
            // 색상 업데이트
            let firstColor = firstHalf.backgroundColor
            mixedFirstHalf.backgroundColor = firstColor
            mixedSecondHalf.backgroundColor = color
            firstHalf.backgroundColor = .none
            
            // 애니메이션 업데이트
            startAlphaAnimation(to: mixedFirstHalf)
            startAlphaAnimation(to: mixedSecondHalf)
        }
        
        // 첫번째 반쪽이 비워져있다면, secondHalf로 전환
        else {
            
            // 상태 업데이트
            paint = .secondHalf
            
            // 만약 일시정지 상태라면, 색 전환
            if isPaused {
                let pausedColor = UIColor(rgb: 0xB0B3BB)
                secondHalf.layer.removeAllAnimations()
                secondHalf.backgroundColor = pausedColor
                secondHalf.alpha = 1
                return
            }
            
            // 색상 업데이트
            secondHalf.backgroundColor = color
            
            // 애니메이션 업데이트
            startAlphaAnimation(to: secondHalf)
        }
    }
    
    /// Alpha 애니메이션을 시작합니다.
    private func startAlphaAnimation(to view: UIView) {
        let options = UIView.AnimationOptions(arrayLiteral: [.autoreverse, .repeat])
        UIView.animate(withDuration: 1.0, delay: 0, options: options, animations: {
            view.alpha = 0.0
        }, completion: nil)
    }
    
    
    
    
    // MARK: - Method
    
    /// 블럭 색칠 메서드
    func painting(_ area: Paint, color: [UIColor] = [Color.entireBlock]) {
//        
//        // 상태 변경
//        paint = area
//    
//        // 블럭 초기화
//        backgroundColor = Color.entireBlock
//        firstHalf.backgroundColor = .clear
//        firstHalf.alpha = 1
//        secondHalf.backgroundColor = .clear
//        secondHalf.alpha = 1
//        mixedFirstHalf.backgroundColor = .clear
//        mixedFirstHalf.alpha = 1
//        mixedSecondHalf.backgroundColor = .clear
//        mixedSecondHalf.alpha = 1
//        
//        // 색상 변경
//        switch paint {
//        case .none?:
//            // print("state == none")
//            backgroundColor = Color.entireBlock
//            
//        case .firstHalf:
//            // print("state == firstHalf")
//            firstHalf.backgroundColor = color[0]
//            
//        case .secondHalf:
//            // print("state == secondHalf")
//            secondHalf.backgroundColor = color[0]
//            
//        case .fullTime:
//            // print("state == fullTime")
//            backgroundColor = color[0]
//            
//        case .mixed:
//            // print("state == mixed")
//            mixedFirstHalf.backgroundColor = color[0]
//            mixedSecondHalf.backgroundColor = color[1]
//
//        case nil: print("state == nil")
//        }
    }
    
    /// 블럭 애니메이션 설정 메서드
    func configureAnimation(_ area: Paint, color: UIColor = Color.entireBlock, isPaused: Bool) {
//        
//        // 상태 변경
//        paint = area
//        
//        // 블럭 초기화
//        backgroundColor = Color.entireBlock
//        full.backgroundColor = .clear
//        firstHalf.backgroundColor = .clear
//        secondHalf.backgroundColor = .clear
//        
//        // 깜빡이 애니메이션
//        switch paint {
//        case .none: backgroundColor = Color.entireBlock
//        case .firstHalf: animate(firstHalf, color: color, isPaused: isPaused)
//        case .secondHalf: animate(secondHalf, color: color, isPaused: isPaused)
//        case .fullTime: animate(full, color: color, isPaused: isPaused)
//        case.mixed: break
//        }
    }
    
    /// 실제 블럭 애니메이션 동작 메서드
    func animate(_ area: UIView, color: UIColor, isPaused: Bool) {
        
        // 기존 애니메이션 초기화
        area.layer.removeAllAnimations()
        
        // 애니메이션 활성화 상태
        if !isPaused {
            area.backgroundColor = color
            isAnimate = true
            animateAlpha(area, toAlpha: 1)
        }
        
        // 애니메이션 중지 상태
        if isPaused {
            
            if color == Color.entireBlock {
                area.backgroundColor = Color.entireBlock
                area.alpha = 0
            } else {
                area.backgroundColor = UIColor(rgb: 0xB0B3BB)
                area.alpha = 1
            }
            
            area.layer.removeAllAnimations()
            isAnimate = false
        }
    }
    
    /// Alpha값을 조정하는 재귀함수
    private func animateAlpha(_ view: UIView, toAlpha: CGFloat) {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseInOut]) {
            view.alpha = toAlpha
        } completion: { [weak self] _ in
            
            guard let self = self else { return }
            
            // 애니메이션 중이 아니라면, 재귀함수 종료
            // 다음 블럭이 기다리고 있는 상태라면 종료(다음 애니메이션 주기로 넘어가기 위함)
            if view.alpha == 0 && isRefresh {
                // print("어머 리프레쉬 됐구나!")
                delegate?.trackingBoardBlock(animateWillRefresh: isRefresh)
                isRefresh = false
                return
            }
            
            // 재귀함수 호출
            if isAnimate {
                animateAlpha(view, toAlpha: toAlpha == 0 ? 1 : 0)
            }
        }
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
