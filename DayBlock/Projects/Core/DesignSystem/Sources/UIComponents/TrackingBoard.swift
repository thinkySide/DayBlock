//
//  TrackingBoard.swift
//  Storybook
//
//  Created by 김민준 on 12/14/25.
//

import SwiftUI

public struct TrackingBoard: View {

    let activeBlocks: [Int: TrackingBoardBlock.Area]
    let blockSize: CGFloat
    let blockCornerRadius: CGFloat
    let spacing: CGFloat
    let isPaused: Bool

    @State private var isTracking = false

    @Environment(\.scenePhase) private var scenePhase

    public init(
        activeBlocks: [Int: TrackingBoardBlock.Area],
        blockSize: CGFloat,
        blockCornerRadius: CGFloat,
        spacing: CGFloat,
        isPaused: Bool
    ) {
        self.activeBlocks = activeBlocks
        self.blockSize = blockSize
        self.blockCornerRadius = blockCornerRadius
        self.spacing = spacing
        self.isPaused = isPaused
    }

    public var body: some View {
        VStack(spacing: spacing) {
            BlocksRow(0...5)
            BlocksRow(6...11)
            BlocksRow(12...17)
            BlocksRow(18...23)
        }
        .id(isPaused)
        .onAppear {
            if !isPaused {
                startAnimation()
            }
        }
        .onChange(of: isPaused) { _, newValue in
            withAnimation(.none) {
                isTracking = false
            }

            if !newValue {
                startAnimation()
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            guard newPhase == .active, !isPaused else { return }
            withAnimation(.none) {
                isTracking = false
            }
            startAnimation()
        }
    }

    @ViewBuilder
    private func BlocksRow(_ range: ClosedRange<Int>) -> some View {
        HStack(spacing: spacing) {
            ForEach(range, id: \.self) { hour in
                let area = activeBlocks[hour] ?? .none
                TrackingBoardBlock(
                    hour: hour,
                    area: area,
                    size: blockSize,
                    cornerRadius: blockCornerRadius,
                    isAnimating: isTracking && !isPaused
                )
            }
        }
    }
}

// MARK: - Helper
extension TrackingBoard {
    
    /// 무한 깜빡임 애니메이션을 시작합니다.
    private func startAnimation() {
        withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
            isTracking = true
        }
    }
}
