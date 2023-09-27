//
//  TrackingBoard.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/01.
//

import UIKit

final class TrackingBoard: UIView {
    
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
    
    // MARK: - Method
    
    enum Time {
        case onTime
        case halfTime
    }
    
    private func startAnimation(_ time: Time, paintBlock: TrackingBoardBlock, isPaused: Bool, color: UIColor) {
        
        switch time {
        case .onTime: paintBlock.configureAnimation(.firstHalf, color: color, isPaused: isPaused)
            
        case .halfTime:
            
            // 첫번째 반쪽 차있을 때, 두번째 반쪽만 차있을 때
            if paintBlock.state == .firstHalf {
                paintBlock.configureAnimation(.fullTime, color: color, isPaused: isPaused)
                return
            }
            
            if paintBlock.state == .fullTime { return }
            else { paintBlock.configureAnimation(.secondHalf, color: color, isPaused: isPaused) }
        }
    }
    
    /// 트래킹 애니메이션을 활성화합니다.
    func updateTrackingAnimation(_ blocks: [String], isPaused: Bool, color: UIColor) {
        for index in blocks {
            switch index {
                
            case "0:00": startAnimation(.onTime, paintBlock: block00, isPaused: isPaused, color: color)
            case "0:30": startAnimation(.halfTime, paintBlock: block00, isPaused: isPaused, color: color)
                 
            case "1:00": startAnimation(.onTime, paintBlock: block01, isPaused: isPaused, color: color)
            case "1:30": startAnimation(.halfTime, paintBlock: block01, isPaused: isPaused, color: color)
                
            case "2:00": startAnimation(.onTime, paintBlock: block02, isPaused: isPaused, color: color)
            case "2:30": startAnimation(.halfTime, paintBlock: block02, isPaused: isPaused, color: color)
                
            case "3:00": startAnimation(.onTime, paintBlock: block03, isPaused: isPaused, color: color)
            case "3:30": startAnimation(.halfTime, paintBlock: block03, isPaused: isPaused, color: color)
                
            case "4:00": startAnimation(.onTime, paintBlock: block04, isPaused: isPaused, color: color)
            case "4:30": startAnimation(.halfTime, paintBlock: block04, isPaused: isPaused, color: color)
                
            case "5:00": startAnimation(.onTime, paintBlock: block05, isPaused: isPaused, color: color)
            case "5:30": startAnimation(.halfTime, paintBlock: block05, isPaused: isPaused, color: color)
                
            case "6:00": startAnimation(.onTime, paintBlock: block06, isPaused: isPaused, color: color)
            case "6:30": startAnimation(.halfTime, paintBlock: block06, isPaused: isPaused, color: color)
                
            case "7:00": startAnimation(.onTime, paintBlock: block07, isPaused: isPaused, color: color)
            case "7:30": startAnimation(.halfTime, paintBlock: block07, isPaused: isPaused, color: color)
                
            case "8:00": startAnimation(.onTime, paintBlock: block08, isPaused: isPaused, color: color)
            case "8:30": startAnimation(.halfTime, paintBlock: block08, isPaused: isPaused, color: color)
                
            case "9:00": startAnimation(.onTime, paintBlock: block09, isPaused: isPaused, color: color)
            case "9:30": startAnimation(.halfTime, paintBlock: block09, isPaused: isPaused, color: color)
                
            case "10:00": startAnimation(.onTime, paintBlock: block10, isPaused: isPaused, color: color)
            case "10:30": startAnimation(.halfTime, paintBlock: block10, isPaused: isPaused, color: color)
                 
            case "11:00": startAnimation(.onTime, paintBlock: block11, isPaused: isPaused, color: color)
            case "11:30": startAnimation(.halfTime, paintBlock: block11, isPaused: isPaused, color: color)
                
            case "12:00": startAnimation(.onTime, paintBlock: block12, isPaused: isPaused, color: color)
            case "12:30": startAnimation(.halfTime, paintBlock: block12, isPaused: isPaused, color: color)
                
            case "13:00": startAnimation(.onTime, paintBlock: block13, isPaused: isPaused, color: color)
            case "13:30": startAnimation(.halfTime, paintBlock: block13, isPaused: isPaused, color: color)
                
            case "14:00": startAnimation(.onTime, paintBlock: block14, isPaused: isPaused, color: color)
            case "14:30": startAnimation(.halfTime, paintBlock: block14, isPaused: isPaused, color: color)
                
            case "15:00": startAnimation(.onTime, paintBlock: block15, isPaused: isPaused, color: color)
            case "15:30": startAnimation(.halfTime, paintBlock: block15, isPaused: isPaused, color: color)
                
            case "16:00": startAnimation(.onTime, paintBlock: block16, isPaused: isPaused, color: color)
            case "16:30": startAnimation(.halfTime, paintBlock: block16, isPaused: isPaused, color: color)
                
            case "17:00": startAnimation(.onTime, paintBlock: block17, isPaused: isPaused, color: color)
            case "17:30": startAnimation(.halfTime, paintBlock: block17, isPaused: isPaused, color: color)
                
            case "18:00": startAnimation(.onTime, paintBlock: block18, isPaused: isPaused, color: color)
            case "18:30": startAnimation(.halfTime, paintBlock: block18, isPaused: isPaused, color: color)
                
            case "19:00": startAnimation(.onTime, paintBlock: block19, isPaused: isPaused, color: color)
            case "19:30": startAnimation(.halfTime, paintBlock: block19, isPaused: isPaused, color: color)
                
            case "20:00": startAnimation(.onTime, paintBlock: block20, isPaused: isPaused, color: color)
            case "20:30": startAnimation(.halfTime, paintBlock: block20, isPaused: isPaused, color: color)
            
            case "21:00": startAnimation(.onTime, paintBlock: block21, isPaused: isPaused, color: color)
            case "21:30": startAnimation(.halfTime, paintBlock: block21, isPaused: isPaused, color: color)
                
            case "22:00": startAnimation(.onTime, paintBlock: block22, isPaused: isPaused, color: color)
            case "22:30": startAnimation(.halfTime, paintBlock: block22, isPaused: isPaused, color: color)
                
            case "23:00": startAnimation(.onTime, paintBlock: block23, isPaused: isPaused, color: color)
            case "23:30": startAnimation(.halfTime, paintBlock: block23, isPaused: isPaused, color: color)
                
            default:
                break
            }
        }
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
