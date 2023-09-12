//
//  BlockPreview.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/01.
//

import UIKit

final class BlockPreview: UIView {
    
    // MARK: - Blocks
    
    let block00 = PaintBlock(frame: .zero, paint: .none)
    let block01 = PaintBlock(frame: .zero, paint: .none)
    let block02 = PaintBlock(frame: .zero, paint: .none)
    let block03 = PaintBlock(frame: .zero, paint: .none)
    let block04 = PaintBlock(frame: .zero, paint: .none)
    let block05 = PaintBlock(frame: .zero, paint: .none)
    let block06 = PaintBlock(frame: .zero, paint: .none)
    let block07 = PaintBlock(frame: .zero, paint: .none)
    let block08 = PaintBlock(frame: .zero, paint: .none)
    let block09 = PaintBlock(frame: .zero, paint: .none)
    let block10 = PaintBlock(frame: .zero, paint: .none)
    let block11 = PaintBlock(frame: .zero, paint: .none)
    let block12 = PaintBlock(frame: .zero, paint: .none)
    let block13 = PaintBlock(frame: .zero, paint: .none)
    let block14 = PaintBlock(frame: .zero, paint: .none)
    let block15 = PaintBlock(frame: .zero, paint: .none)
    let block16 = PaintBlock(frame: .zero, paint: .none)
    let block17 = PaintBlock(frame: .zero, paint: .none)
    let block18 = PaintBlock(frame: .zero, paint: .none)
    let block19 = PaintBlock(frame: .zero, paint: .none)
    let block20 = PaintBlock(frame: .zero, paint: .none)
    let block21 = PaintBlock(frame: .zero, paint: .none)
    let block22 = PaintBlock(frame: .zero, paint: .none)
    let block23 = PaintBlock(frame: .zero, paint: .none)
    
    /// 현재 활성화 중인 블럭
    var currentBlocks: [PaintBlock] = []
    
    
    // MARK: - Constatns
    
    private let spacing: CGFloat = 4
    
    
    
    // MARK: - Method
    
    enum Time {
        case onTime
        case halfTime
    }
    
    func animationCondition(_ time: Time, paintBlock: PaintBlock, color: UIColor) {
        
        /// 현재 애니메이션 블럭에 추가(중복 추가 방지)
        if !currentBlocks.contains(paintBlock) {
            currentBlocks.append(paintBlock)
        }
        
        switch time {
        case .onTime: paintBlock.configureAnimation(.firstHalf, color: color, isPaused: false)
            
        case .halfTime:
            
            // 첫번째 반쪽 차있을 때, 두번째 반쪽만 차있을 때
            if paintBlock.state == .firstHalf {
                paintBlock.configureAnimation(.fullTime, color: color, isPaused: false)
                return
            }
            
            if paintBlock.state == .fullTime { return }
            
            else { paintBlock.configureAnimation(.secondHalf, color: color, isPaused: false) }
        }
    }
    
    /// 트래킹 애니메이션을 활성화합니다.
    func activateTrackingAnimation(_ indexs: [String], color: UIColor) {
        for index in indexs {
            switch index {
                
            case "0000": animationCondition(.onTime ,paintBlock: block00, color: color)
            case "0030": animationCondition(.halfTime ,paintBlock: block00, color: color)
                 
            case "0100": animationCondition(.onTime ,paintBlock: block01, color: color)
            case "0130": animationCondition(.halfTime ,paintBlock: block01, color: color)
                
            case "0200": animationCondition(.onTime ,paintBlock: block02, color: color)
            case "0230": animationCondition(.halfTime ,paintBlock: block02, color: color)
                
            case "0300": animationCondition(.onTime ,paintBlock: block03, color: color)
            case "0330": animationCondition(.halfTime ,paintBlock: block03, color: color)
                
            case "0400": animationCondition(.onTime ,paintBlock: block04, color: color)
            case "0430": animationCondition(.halfTime ,paintBlock: block04, color: color)
                
            case "0500": animationCondition(.onTime ,paintBlock: block05, color: color)
            case "0530": animationCondition(.halfTime ,paintBlock: block05, color: color)
                
            case "0600": animationCondition(.onTime ,paintBlock: block06, color: color)
            case "0630": animationCondition(.halfTime ,paintBlock: block06, color: color)
                
            case "0700": animationCondition(.onTime ,paintBlock: block07, color: color)
            case "0730": animationCondition(.halfTime ,paintBlock: block07, color: color)
                
            case "0800": animationCondition(.onTime ,paintBlock: block08, color: color)
            case "0830": animationCondition(.halfTime ,paintBlock: block08, color: color)
                
            case "0900": animationCondition(.onTime ,paintBlock: block09, color: color)
            case "0930": animationCondition(.halfTime ,paintBlock: block09, color: color)
                
            case "1000": animationCondition(.onTime ,paintBlock: block10, color: color)
            case "1030": animationCondition(.halfTime ,paintBlock: block10, color: color)
                 
            case "1100": animationCondition(.onTime ,paintBlock: block11, color: color)
            case "1130": animationCondition(.halfTime ,paintBlock: block11, color: color)
                
            case "1200": animationCondition(.onTime ,paintBlock: block12, color: color)
            case "1230": animationCondition(.halfTime ,paintBlock: block12, color: color)
                
            case "1300": animationCondition(.onTime ,paintBlock: block13, color: color)
            case "1330": animationCondition(.halfTime ,paintBlock: block13, color: color)
                
            case "1400": animationCondition(.onTime ,paintBlock: block14, color: color)
            case "1430": animationCondition(.halfTime ,paintBlock: block14, color: color)
                
            case "1500": animationCondition(.onTime ,paintBlock: block15, color: color)
            case "1530": animationCondition(.halfTime ,paintBlock: block15, color: color)
                
            case "1600": animationCondition(.onTime ,paintBlock: block16, color: color)
            case "1630": animationCondition(.halfTime ,paintBlock: block16, color: color)
                
            case "1700": animationCondition(.onTime ,paintBlock: block17, color: color)
            case "1730": animationCondition(.halfTime ,paintBlock: block17, color: color)
                
            case "1800": animationCondition(.onTime ,paintBlock: block18, color: color)
            case "1830": animationCondition(.halfTime ,paintBlock: block18, color: color)
                
            case "1900": animationCondition(.onTime ,paintBlock: block19, color: color)
            case "1930": animationCondition(.halfTime ,paintBlock: block19, color: color)
                
            case "2000": animationCondition(.onTime ,paintBlock: block20, color: color)
            case "2030": animationCondition(.halfTime ,paintBlock: block20, color: color)
                
            case "2100": animationCondition(.onTime ,paintBlock: block21, color: color)
            case "2130": animationCondition(.halfTime ,paintBlock: block21, color: color)
                
            case "2200": animationCondition(.onTime ,paintBlock: block22, color: color)
            case "2230": animationCondition(.halfTime ,paintBlock: block22, color: color)
                
            case "2300": animationCondition(.onTime ,paintBlock: block23, color: color)
            case "2330": animationCondition(.halfTime ,paintBlock: block23, color: color)
                
            default:
                break
            }
        }
    }
    
    /// 트래킹 애니메이션을 일시정지 합니다.
    func pausedTrackingAnimation() {
        for block in currentBlocks {
            block.configureAnimation(block.state, isPaused: true)
        }
    }
    
    /// 트래킹 애니메이션을 종료합니다.
    func stopTrackingAnimation() {
        for block in currentBlocks {
            block.painting(.none)
        }
    }
    
    /// currentBlocks를 초기화합니다.
    func resetCurrentBlocks() {
        currentBlocks.removeAll()
    }
    
    
    // MARK: - Initial Method
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAddSubView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAddSubView() {
        
        [
            block00, block01, block02, block03, block04, block05,
            block06, block07, block08, block09, block10, block11,
            block12, block13, block14, block15, block16, block17,
            block18, block19, block20, block21, block22, block23,
        ]
            .forEach {
                
                /// 1. addSubView(component)
                addSubview($0)
                
                /// 2. translatesAutoresizingMaskIntoConstraints = false
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
    }
    
    func setupConstraints() {
        
        /// 3. isActive = true
        NSLayoutConstraint.activate([

            /// block00
            block00.topAnchor.constraint(equalTo: topAnchor),
            block00.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            /// block01
            block01.topAnchor.constraint(equalTo: topAnchor),
            block01.leadingAnchor.constraint(equalTo: block00.trailingAnchor, constant: spacing),
            
            /// block02
            block02.topAnchor.constraint(equalTo: topAnchor),
            block02.leadingAnchor.constraint(equalTo: block01.trailingAnchor, constant: spacing),
            
            /// block03
            block03.topAnchor.constraint(equalTo: topAnchor),
            block03.leadingAnchor.constraint(equalTo: block02.trailingAnchor, constant: spacing),
            
            /// block04
            block04.topAnchor.constraint(equalTo: topAnchor),
            block04.leadingAnchor.constraint(equalTo: block03.trailingAnchor, constant: spacing),
            
            /// block05
            block05.topAnchor.constraint(equalTo: topAnchor),
            block05.leadingAnchor.constraint(equalTo: block04.trailingAnchor, constant: spacing),
            
            /// block06
            block06.topAnchor.constraint(equalTo: block00.bottomAnchor, constant: spacing),
            block06.leadingAnchor.constraint(equalTo: leadingAnchor),

            /// block07
            block07.topAnchor.constraint(equalTo: block00.bottomAnchor, constant: spacing),
            block07.leadingAnchor.constraint(equalTo: block06.trailingAnchor, constant: spacing),

            /// block08
            block08.topAnchor.constraint(equalTo: block00.bottomAnchor, constant: spacing),
            block08.leadingAnchor.constraint(equalTo: block07.trailingAnchor, constant: spacing),

            /// block09
            block09.topAnchor.constraint(equalTo: block00.bottomAnchor, constant: spacing),
            block09.leadingAnchor.constraint(equalTo: block08.trailingAnchor, constant: spacing),

            /// block10
            block10.topAnchor.constraint(equalTo: block00.bottomAnchor, constant: spacing),
            block10.leadingAnchor.constraint(equalTo: block09.trailingAnchor, constant: spacing),

            /// block11
            block11.topAnchor.constraint(equalTo: block00.bottomAnchor, constant: spacing),
            block11.leadingAnchor.constraint(equalTo: block10.trailingAnchor, constant: spacing),

            /// block12
            block12.topAnchor.constraint(equalTo: block06.bottomAnchor, constant: spacing),
            block12.leadingAnchor.constraint(equalTo: leadingAnchor),

            /// block13
            block13.topAnchor.constraint(equalTo: block06.bottomAnchor, constant: spacing),
            block13.leadingAnchor.constraint(equalTo: block12.trailingAnchor, constant: spacing),

            /// block14
            block14.topAnchor.constraint(equalTo: block06.bottomAnchor, constant: spacing),
            block14.leadingAnchor.constraint(equalTo: block13.trailingAnchor, constant: spacing),

            /// block15
            block15.topAnchor.constraint(equalTo: block06.bottomAnchor, constant: spacing),
            block15.leadingAnchor.constraint(equalTo: block14.trailingAnchor, constant: spacing),

            /// block16
            block16.topAnchor.constraint(equalTo: block06.bottomAnchor, constant: spacing),
            block16.leadingAnchor.constraint(equalTo: block15.trailingAnchor, constant: spacing),

            /// block17
            block17.topAnchor.constraint(equalTo: block06.bottomAnchor, constant: spacing),
            block17.leadingAnchor.constraint(equalTo: block16.trailingAnchor, constant: spacing),

            /// block18
            block18.topAnchor.constraint(equalTo: block12.bottomAnchor, constant: spacing),
            block18.leadingAnchor.constraint(equalTo: leadingAnchor),

            /// block19
            block19.topAnchor.constraint(equalTo: block12.bottomAnchor, constant: spacing),
            block19.leadingAnchor.constraint(equalTo: block18.trailingAnchor, constant: spacing),

            /// block20
            block20.topAnchor.constraint(equalTo: block12.bottomAnchor, constant: spacing),
            block20.leadingAnchor.constraint(equalTo: block19.trailingAnchor, constant: spacing),

            /// block21
            block21.topAnchor.constraint(equalTo: block12.bottomAnchor, constant: spacing),
            block21.leadingAnchor.constraint(equalTo: block20.trailingAnchor, constant: spacing),

            /// block22
            block22.topAnchor.constraint(equalTo: block12.bottomAnchor, constant: spacing),
            block22.leadingAnchor.constraint(equalTo: block21.trailingAnchor, constant: spacing),

            /// block23
            block23.topAnchor.constraint(equalTo: block12.bottomAnchor, constant: spacing),
            block23.leadingAnchor.constraint(equalTo: block22.trailingAnchor, constant: spacing),
        ])
    }
}
