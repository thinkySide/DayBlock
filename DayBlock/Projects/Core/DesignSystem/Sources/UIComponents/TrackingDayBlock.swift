//
//  TrackingDayBlock.swift
//  DesignSystem
//
//  Created by 김민준 on 1/10/26.
//

import SwiftUI
import UIKit

public struct TrackingDayBlock: View {

    let title: String
    let todayAmount: Double
    let symbol: String
    let color: Color
    let size: CGFloat
    let isPaused: Bool
    let onLongPressComplete: () -> Void

    @GestureState private var isPressing = false
    @State private var fillWidth: CGFloat = 0
    @State private var scale: CGFloat = 1.0
    @State private var pressTask: Task<Void, Never>?

    private let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    private let notificationFeedback = UINotificationFeedbackGenerator()

    public init(
        title: String,
        todayAmount: Double,
        symbol: String,
        color: Color,
        size: CGFloat = 250,
        isPaused: Bool,
        onLongPressComplete: @escaping () -> Void = {}
    ) {
        self.title = title
        self.todayAmount = todayAmount
        self.symbol = symbol
        self.color = color
        self.size = size
        self.isPaused = isPaused
        self.onLongPressComplete = onLongPressComplete
    }
    
    public var body: some View {
        let ratio = size / 250
        let cornerRadius: CGFloat = 36 * ratio
        let labelPadding: CGFloat = 24 * ratio
        let tagTrailing: CGFloat = 40 * ratio
        let symbolSize: CGFloat = 68 * ratio
        let symbolTopPadding: CGFloat = 72 * ratio
        let titleFontSize: CGFloat = 22 * ratio

        ZStack(alignment: .leading) {
            DesignSystem.Colors.gray100.swiftUIColor
                .frame(width: size, height: size)

            color.opacity(0.2)
                .frame(width: fillWidth, height: size)
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .overlay(alignment: .topLeading) {
            AmountLabel(ratio: ratio)
                .padding(.top, labelPadding)
                .padding(.leading, labelPadding)
        }
        .overlay(alignment: .topTrailing) {
            Tag(ratio: ratio)
                .padding(.trailing, tagTrailing)
        }
        .overlay(alignment: .top) {
            SFSymbol(
                symbol: symbol,
                size: symbolSize,
                color: DesignSystem.Colors.gray900.swiftUIColor,
                isAnimating: !isPaused,
                animationType: .bounce
            )
            .padding(.top, symbolTopPadding)
        }
        .overlay(alignment: .top) {
            Text(title)
                .brandFont(.pretendard(.bold), titleFontSize)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                .frame(maxWidth: size - (16 * 2))
                .padding(.top, symbolTopPadding + symbolTopPadding + 16 * ratio)
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .updating($isPressing) { _, state, _ in
                    state = true
                }
                .onChanged { _ in
                    if fillWidth < size {
                        impactFeedback.impactOccurred()

                        withAnimation(.easeInOut(duration: 0.9)) {
                            fillWidth = size
                        }
                        withAnimation(.bouncy(duration: 0.5)) {
                            scale = 0.95
                        }
                        pressTask?.cancel()
                        pressTask = Task {
                            try? await Task.sleep(for: .seconds(0.9))
                            if !Task.isCancelled {
                                onLongPressComplete()
                            }
                        }
                    }
                }
                .onEnded { _ in
                    pressTask?.cancel()
                    pressTask = nil
                    withAnimation(.easeInOut(duration: 0.3)) {
                        fillWidth = 0
                        scale = 1.0
                    }
                }
        )
        .scaleEffect(scale)
    }
}

// MARK: - SubViews
extension TrackingDayBlock {

    @ViewBuilder
    private func AmountLabel(ratio: CGFloat) -> some View {
        HStack(spacing: 0) {
            Text("+")
                .foregroundStyle(color)

            Text(toLabelString(todayAmount))
                .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
        }
        .brandFont(.poppins(.bold), 24 * ratio)
    }

    @ViewBuilder
    private func Tag(ratio: CGFloat) -> some View {
        UnevenRoundedRectangle(
            topLeadingRadius: 0,
            bottomLeadingRadius: 12 * ratio,
            bottomTrailingRadius: 12 * ratio,
            topTrailingRadius: 0
        )
        .frame(width: 26 * ratio, height: 38 * ratio)
        .foregroundStyle(color)
    }
}

// MARK: - Helper
extension TrackingDayBlock {
    
    /// 생산량 Double 타입을 문자열로 변환합니다.
    private func toLabelString(_ amount: Double) -> String {
        String(format: "%.1f", amount)
    }
}
