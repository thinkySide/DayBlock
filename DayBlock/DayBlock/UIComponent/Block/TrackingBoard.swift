//
//  TrackingBoard.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/01.
//

import UIKit

protocol TrackingBoardDelegate: AnyObject {
    func trackingBoard(animationWillRefresh trackingBoard: TrackingBoard)
}

final class TrackingBoard: UIView {
    
    weak var delegate: TrackingBoardDelegate?
    
    /// 블럭 사이즈
    var blockSize: CGFloat
    
    /// 블럭 간 간격
    private let spacing: CGFloat
    
    // MARK: - Blocks
    
    lazy var block00 = TrackingBoardBlock(frame: .zero, size: blockSize)
    lazy var block01 = TrackingBoardBlock(frame: .zero, size: blockSize)
    lazy var block02 = TrackingBoardBlock(frame: .zero, size: blockSize)
    lazy var block03 = TrackingBoardBlock(frame: .zero, size: blockSize)
    lazy var block04 = TrackingBoardBlock(frame: .zero, size: blockSize)
    lazy var block05 = TrackingBoardBlock(frame: .zero, size: blockSize)
    lazy var block06 = TrackingBoardBlock(frame: .zero, size: blockSize)
    lazy var block07 = TrackingBoardBlock(frame: .zero, size: blockSize)
    lazy var block08 = TrackingBoardBlock(frame: .zero, size: blockSize)
    lazy var block09 = TrackingBoardBlock(frame: .zero, size: blockSize)
    lazy var block10 = TrackingBoardBlock(frame: .zero, size: blockSize)
    lazy var block11 = TrackingBoardBlock(frame: .zero, size: blockSize)
    lazy var block12 = TrackingBoardBlock(frame: .zero, size: blockSize)
    lazy var block13 = TrackingBoardBlock(frame: .zero, size: blockSize)
    lazy var block14 = TrackingBoardBlock(frame: .zero, size: blockSize)
    lazy var block15 = TrackingBoardBlock(frame: .zero, size: blockSize)
    lazy var block16 = TrackingBoardBlock(frame: .zero, size: blockSize)
    lazy var block17 = TrackingBoardBlock(frame: .zero, size: blockSize)
    lazy var block18 = TrackingBoardBlock(frame: .zero, size: blockSize)
    lazy var block19 = TrackingBoardBlock(frame: .zero, size: blockSize)
    lazy var block20 = TrackingBoardBlock(frame: .zero, size: blockSize)
    lazy var block21 = TrackingBoardBlock(frame: .zero, size: blockSize)
    lazy var block22 = TrackingBoardBlock(frame: .zero, size: blockSize)
    lazy var block23 = TrackingBoardBlock(frame: .zero, size: blockSize)
    
    lazy var blocks: [TrackingBoardBlock] = [
        block00, block01, block02, block03, block04, block05, block06, block07, block08,
        block09, block10, block11, block12, block13, block14, block15, block16, block17,
        block18, block19, block20, block21, block22, block23
    ]
    
    // MARK: - Method
    
    enum Time {
        case onTime
        case halfTime
    }
    
    /// 트래킹 완료 후 보드 표시 메서드입니다.
    func fillBlocks(_ trackingBlocks: [String], color: UIColor) {
        print(trackingBlocks)
        
        for trackingBlock in trackingBlocks {
            let split = trackingBlock.split(separator: ":").map { String($0) }
            let hour = split[0]
            let minute = split[1]
            
            // 트래킹 블럭 지정
            let paintBlock = blocks[Int(hour)!]
            let state = minute == "00" ? TrackingBoardBlock.Paint.firstHalf : TrackingBoardBlock.Paint.secondHalf
            
            if state == .firstHalf {
                // print("\(hour):\(minute) 블럭 firstHalf")
                paintBlock.painting(.firstHalf, color: color)
            }
            
            // 첫번째 반쪽이 이미 차있다면, full로 변경
            else if paintBlock.state == .firstHalf && state == .secondHalf {
                // print("\(hour):\(minute) 블럭 fullTime")
                paintBlock.painting(.fullTime, color: color)
            } 
            
            else {
                // print("\(hour):\(minute) 블럭 secondHalf")
                paintBlock.painting(.secondHalf, color: color)
            }
        }
    }
    
    /// 애니메이션을 시작합니다.
    private func startAnimation(_ time: Time, paintBlock: TrackingBoardBlock, color: UIColor, isPaused: Bool) {
        
        switch time {
        case .onTime:
            // print("firstHalf")
            paintBlock.configureAnimation(.firstHalf, color: color, isPaused: isPaused)
            
        case .halfTime:
            
            if paintBlock.state == .secondHalf {
                // print("secondHalf")
                paintBlock.configureAnimation(.secondHalf, color: color, isPaused: isPaused)
                return
            }
            
            if paintBlock.state == .fullTime {
                // print("fullTime")
                paintBlock.configureAnimation(.fullTime, color: color, isPaused: isPaused)
                return
            }
        }
    }
    
    func pauseTrackingAnimation(_ trackingBlocks: [String], isPaused: Bool) {
        for index in trackingBlocks {
            let split = index.split(separator: ":").map { String($0) }
            let hour = split[0]
            let minute = split[1]
            
            let blockIndex = Int(hour)!
            
            // 트래킹 블럭 지정
            let paintBlock = blocks[blockIndex]
            
            let time = minute == "00" ? Time.onTime : Time.halfTime
            
            // 만약 앞에가 채워져있으면 이번 블럭은 건너뛰고 대신 이전 블럭의 애니메이션 삭제 후 full로 실행하기
            if time == .halfTime && paintBlock.state == .firstHalf {
                // print("\(hour):\(minute) 블럭을 통해 fullTime이 되었기에 기존 애니메이션 삭제")
                paintBlock.state = .fullTime
            }
            
            // print("\(hour):\(minute) 블럭 채우기")
            startAnimation(time, paintBlock: paintBlock, color: Color.entireBlock, isPaused: isPaused)
        }
    }
    
    /// 트래킹 애니메이션을 활성화합니다.
    func updateTrackingAnimation(_ trackingBlocks: [String], color: UIColor, isPaused: Bool) {
        
        // print("애니메이션에 돌아갈 블럭 목록: \(trackingBlocks)\n")
        
        for index in trackingBlocks {
            let split = index.split(separator: ":").map { String($0) }
            let hour = split[0]
            let minute = split[1]
            
            let blockIndex = Int(hour)!
            
            // 트래킹 블럭 지정
            let paintBlock = blocks[blockIndex]
            let time = minute == "00" ? Time.onTime : Time.halfTime
            
            if time == .onTime {
                paintBlock.state = .firstHalf
            }
            
            // 만약 앞에가 채워져있으면 이번 블럭은 건너뛰고 대신 이전 블럭의 애니메이션 삭제 후 full로 실행하기
            else if time == .halfTime && paintBlock.state == .firstHalf {
                // print("\(hour):\(minute) 블럭을 통해 fullTime이 되었기에 기존 애니메이션 삭제")
                paintBlock.state = .fullTime
            }
            
            else {
                paintBlock.state = .secondHalf
            }
            
            // print("\(hour):\(minute) 블럭 채우기")
            startAnimation(time, paintBlock: paintBlock, color: color, isPaused: isPaused)
        }
    }
    
    /// 트래킹 애니메이션을 중지합니다.
    func stopTrackingAnimation(_ trackingBlocks: [String]) {
        for index in trackingBlocks {
            let split = index.split(separator: ":").map { String($0) }
            let hour = split[0]
            
            // 트래킹 블럭 지정
            let paintBlocks = blocks[Int(hour)!]
            // print("\(Int(hour)!)번째 블럭 애니메이션 중지")
            
            // 색칠 초기화
            paintBlocks.full.backgroundColor = Color.entireBlock
            paintBlocks.firstHalf.backgroundColor = Color.entireBlock
            paintBlocks.secondHalf.backgroundColor = Color.entireBlock
            
            // 애니메이션 해제
            paintBlocks.isAnimate = false
            paintBlocks.layer.removeAllAnimations()
        }
    }
    
    /// 애니메이션 리프레시를 위한 트래킹 블럭 목록을 업데이트합니다.
    func refreshAnimation(_ trackingBlocks: [String], color: UIColor) {
        
        if trackingBlocks.isEmpty { return }
        
        // 첫번째 블럭을 기준으로 모든 블럭 리프레시
        let block = trackingBlocks[0].split(separator: ":").map { String($0) }
        let hour = block[0]
        
        // 트래킹 블럭 지정
        let paintBlock = blocks[Int(hour)!]
        paintBlock.delegate = self
        paintBlock.isRefresh = true
        
        // print("\(Int(hour)!)번 블럭 기준 모든 블럭 리프레시")
    }
    
    // MARK: - Initial Method
    
    init(frame: CGRect, blockSize: CGFloat, spacing: CGFloat) {
        self.blockSize = blockSize
        self.spacing = spacing
        super.init(frame: frame)
        setupAddSubView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAddSubView() {
        
        [
            block00, block01, block02, block03, block04, block05,
            block06, block07, block08, block09, block10, block11,
            block12, block13, block14, block15, block16, block17,
            block18, block19, block20, block21, block22, block23
        ]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: block00.topAnchor),
            self.bottomAnchor.constraint(equalTo: block18.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: block00.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: block23.trailingAnchor),

            block00.topAnchor.constraint(equalTo: topAnchor),
            block00.leadingAnchor.constraint(equalTo: leadingAnchor),

            block01.topAnchor.constraint(equalTo: topAnchor),
            block01.leadingAnchor.constraint(equalTo: block00.trailingAnchor, constant: spacing),
  
            block02.topAnchor.constraint(equalTo: topAnchor),
            block02.leadingAnchor.constraint(equalTo: block01.trailingAnchor, constant: spacing),

            block03.topAnchor.constraint(equalTo: topAnchor),
            block03.leadingAnchor.constraint(equalTo: block02.trailingAnchor, constant: spacing),

            block04.topAnchor.constraint(equalTo: topAnchor),
            block04.leadingAnchor.constraint(equalTo: block03.trailingAnchor, constant: spacing),
            
            block05.topAnchor.constraint(equalTo: topAnchor),
            block05.leadingAnchor.constraint(equalTo: block04.trailingAnchor, constant: spacing),
        
            block06.topAnchor.constraint(equalTo: block00.bottomAnchor, constant: spacing),
            block06.leadingAnchor.constraint(equalTo: leadingAnchor),

            block07.topAnchor.constraint(equalTo: block00.bottomAnchor, constant: spacing),
            block07.leadingAnchor.constraint(equalTo: block06.trailingAnchor, constant: spacing),

            block08.topAnchor.constraint(equalTo: block00.bottomAnchor, constant: spacing),
            block08.leadingAnchor.constraint(equalTo: block07.trailingAnchor, constant: spacing),

            block09.topAnchor.constraint(equalTo: block00.bottomAnchor, constant: spacing),
            block09.leadingAnchor.constraint(equalTo: block08.trailingAnchor, constant: spacing),

            block10.topAnchor.constraint(equalTo: block00.bottomAnchor, constant: spacing),
            block10.leadingAnchor.constraint(equalTo: block09.trailingAnchor, constant: spacing),

            block11.topAnchor.constraint(equalTo: block00.bottomAnchor, constant: spacing),
            block11.leadingAnchor.constraint(equalTo: block10.trailingAnchor, constant: spacing),

            block12.topAnchor.constraint(equalTo: block06.bottomAnchor, constant: spacing),
            block12.leadingAnchor.constraint(equalTo: leadingAnchor),

            block13.topAnchor.constraint(equalTo: block06.bottomAnchor, constant: spacing),
            block13.leadingAnchor.constraint(equalTo: block12.trailingAnchor, constant: spacing),

            block14.topAnchor.constraint(equalTo: block06.bottomAnchor, constant: spacing),
            block14.leadingAnchor.constraint(equalTo: block13.trailingAnchor, constant: spacing),

            block15.topAnchor.constraint(equalTo: block06.bottomAnchor, constant: spacing),
            block15.leadingAnchor.constraint(equalTo: block14.trailingAnchor, constant: spacing),

            block16.topAnchor.constraint(equalTo: block06.bottomAnchor, constant: spacing),
            block16.leadingAnchor.constraint(equalTo: block15.trailingAnchor, constant: spacing),

            block17.topAnchor.constraint(equalTo: block06.bottomAnchor, constant: spacing),
            block17.leadingAnchor.constraint(equalTo: block16.trailingAnchor, constant: spacing),

            block18.topAnchor.constraint(equalTo: block12.bottomAnchor, constant: spacing),
            block18.leadingAnchor.constraint(equalTo: leadingAnchor),

            block19.topAnchor.constraint(equalTo: block12.bottomAnchor, constant: spacing),
            block19.leadingAnchor.constraint(equalTo: block18.trailingAnchor, constant: spacing),

            block20.topAnchor.constraint(equalTo: block12.bottomAnchor, constant: spacing),
            block20.leadingAnchor.constraint(equalTo: block19.trailingAnchor, constant: spacing),

            block21.topAnchor.constraint(equalTo: block12.bottomAnchor, constant: spacing),
            block21.leadingAnchor.constraint(equalTo: block20.trailingAnchor, constant: spacing),
            
            block22.topAnchor.constraint(equalTo: block12.bottomAnchor, constant: spacing),
            block22.leadingAnchor.constraint(equalTo: block21.trailingAnchor, constant: spacing),

            block23.topAnchor.constraint(equalTo: block12.bottomAnchor, constant: spacing),
            block23.leadingAnchor.constraint(equalTo: block22.trailingAnchor, constant: spacing)
        ])
    }
}

extension TrackingBoard: TrackingBoardBlockDelegate {
    func trackingBoardBlock(animateWillRefresh isRefresh: Bool) {
        delegate?.trackingBoard(animationWillRefresh: self)
    }
}
