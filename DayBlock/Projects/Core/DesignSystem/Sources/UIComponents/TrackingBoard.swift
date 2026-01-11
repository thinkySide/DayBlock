//
//  TrackingBoard.swift
//  Storybook
//
//  Created by 김민준 on 12/14/25.
//

import SwiftUI

public struct TrackingBoard: View {

    let blocks: [TrackingBoardBlock]
    let blockSize: CGFloat
    let blockCornerRadius: CGFloat
    let spacing: CGFloat

    public init(
        activeBlocks: [Int: TrackingBoardBlock.State],
        blockSize: CGFloat,
        blockCornerRadius: CGFloat,
        spacing: CGFloat
    ) {
        self.blockSize = blockSize
        self.blockCornerRadius = blockCornerRadius
        self.blocks = Self.generateBlocks(
            from: activeBlocks,
            blockSize: blockSize,
            blockCornerRadius: blockCornerRadius
        )
        self.spacing = spacing
    }
    
    public var body: some View {
        VStack(spacing: spacing) {
            BlocksRow(0...5)
            BlocksRow(6...11)
            BlocksRow(12...17)
            BlocksRow(18...23)
        }
    }

    @ViewBuilder
    private func BlocksRow(_ range: ClosedRange<Int>) -> some View {
        HStack(spacing: spacing) {
            ForEach(blocks[range]) { block in
                block
            }
        }
    }
}

// MARK: - Helper
extension TrackingBoard {

    /// 활성화된 블럭 상태를 기반으로 전체 블럭 View 배열을 반환합니다.
    private static func generateBlocks(
        from activeBlocks: [Int: TrackingBoardBlock.State],
        blockSize: CGFloat,
        blockCornerRadius: CGFloat
    ) -> [TrackingBoardBlock] {
        var blocks = [TrackingBoardBlock]()
        for hour in 0..<24 {
            let state = activeBlocks[hour] ?? .none
            let block = TrackingBoardBlock(
                hour: hour,
                state: state,
                size: blockSize,
                cornerRadius: blockCornerRadius
            )
            blocks.append(block)
        }
        return blocks
    }
}
