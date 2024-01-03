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
    
    lazy var block00 = TrackingBoardBlock(size: blockSize)
    lazy var block01 = TrackingBoardBlock(size: blockSize)
    lazy var block02 = TrackingBoardBlock(size: blockSize)
    lazy var block03 = TrackingBoardBlock(size: blockSize)
    lazy var block04 = TrackingBoardBlock(size: blockSize)
    lazy var block05 = TrackingBoardBlock(size: blockSize)
    lazy var block06 = TrackingBoardBlock(size: blockSize)
    lazy var block07 = TrackingBoardBlock(size: blockSize)
    lazy var block08 = TrackingBoardBlock(size: blockSize)
    lazy var block09 = TrackingBoardBlock(size: blockSize)
    lazy var block10 = TrackingBoardBlock(size: blockSize)
    lazy var block11 = TrackingBoardBlock(size: blockSize)
    lazy var block12 = TrackingBoardBlock(size: blockSize)
    lazy var block13 = TrackingBoardBlock(size: blockSize)
    lazy var block14 = TrackingBoardBlock(size: blockSize)
    lazy var block15 = TrackingBoardBlock(size: blockSize)
    lazy var block16 = TrackingBoardBlock(size: blockSize)
    lazy var block17 = TrackingBoardBlock(size: blockSize)
    lazy var block18 = TrackingBoardBlock(size: blockSize)
    lazy var block19 = TrackingBoardBlock(size: blockSize)
    lazy var block20 = TrackingBoardBlock(size: blockSize)
    lazy var block21 = TrackingBoardBlock(size: blockSize)
    lazy var block22 = TrackingBoardBlock(size: blockSize)
    lazy var block23 = TrackingBoardBlock(size: blockSize)
    
    lazy var blocks: [TrackingBoardBlock] = [
        block00, block01, block02, block03, block04, block05,
        block06, block07, block08, block09, block10, block11,
        block12, block13, block14, block15, block16, block17,
        block18, block19, block20, block21, block22, block23
    ]
    
    // MARK: - Method
    
    /// 트래킹 보드를 현재 데이터로 업데이트합니다.
    ///
    /// 이미 칠해져야 할 데이터 + 애니메이션 중인 데이터
    func updateBoard() {
        
        resetBoard()
        
        // 48개의 블럭 순회
        for (index, item) in TrackingBoardService.shared.infoItems.enumerated() {
            
            // 블럭 지정
            let block = blocks[index / 2]
            
            // 첫번째 반쪽
            if index % 2 == 0 {
                block.updateFirstBlock(color: item.color, isAnimated: item.isAnimated, isPaused: false)
            }
            
            // 두번째 반쪽
            else if index % 2 == 1 {
                block.updateSecondBlock(color: item.color, isAnimated: item.isAnimated, isPaused: false)
            }
        }
    }
    
    /// 트래킹 보드를 일시정지 합니다.
    func pauseBoard() {
        
        // 48개의 블럭 순회
        for (index, item) in TrackingBoardService.shared.infoItems.enumerated() {
            
            // 애니메이션 아닌 블럭은 일시정지 X
            if !item.isAnimated { continue }
            
            // 블럭 지정
            let block = blocks[index / 2]
            
            // 첫번째 반쪽
            if index % 2 == 0 {
                block.updateFirstBlock(color: item.color, isAnimated: item.isAnimated, isPaused: true)
            }
            
            // 두번째 반쪽
            else if index % 2 == 1 {
                block.updateSecondBlock(color: item.color, isAnimated: item.isAnimated, isPaused: true)
            }
        }
    }
    
    /// 트래킹 보드를 초기 상태로 리셋합니다.
    func resetBoard() {
        for block in blocks {
            block.reset()
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
