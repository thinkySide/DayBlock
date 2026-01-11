//
//  TrackingBoard.swift
//  Storybook
//
//  Created by 김민준 on 12/14/25.
//

import SwiftUI

public struct TrackingBoard: View {

    let activeBlocks: [Int: TrackingBoardBlock.Variation]
    let blockSize: CGFloat
    let blockCornerRadius: CGFloat
    let spacing: CGFloat

    @State private var isTracking = false

    public init(
        activeBlocks: [Int: TrackingBoardBlock.Variation],
        blockSize: CGFloat,
        blockCornerRadius: CGFloat,
        spacing: CGFloat
    ) {
        self.activeBlocks = activeBlocks
        self.blockSize = blockSize
        self.blockCornerRadius = blockCornerRadius
        self.spacing = spacing
    }

    public var body: some View {
        VStack(spacing: spacing) {
            BlocksRow(0...5)
            BlocksRow(6...11)
            BlocksRow(12...17)
            BlocksRow(18...23)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                isTracking = true
            }
        }
    }

    @ViewBuilder
    private func BlocksRow(_ range: ClosedRange<Int>) -> some View {
        HStack(spacing: spacing) {
            ForEach(range, id: \.self) { hour in
                let variation = activeBlocks[hour] ?? .none
                TrackingBoardBlock(
                    hour: hour,
                    variation: variation,
                    size: blockSize,
                    cornerRadius: blockCornerRadius,
                    isTracking: isTracking
                )
            }
        }
    }
}

