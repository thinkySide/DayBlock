//
//  TrackingDayBlock.swift
//  DesignSystem
//
//  Created by 김민준 on 1/10/26.
//

import SwiftUI

public struct TrackingDayBlock: View {

    let title: String
    let todayAmount: Double
    let symbol: String
    let color: Color
    let onLongPressComplete: () -> Void

    @GestureState private var isPressing = false
    @State private var fillWidth: CGFloat = 0
    @State private var scale: CGFloat = 1.0
    @State private var pressTask: Task<Void, Never>?

    public init(
        title: String,
        todayAmount: Double,
        symbol: String,
        color: Color,
        onLongPressComplete: @escaping () -> Void = {}
    ) {
        self.title = title
        self.todayAmount = todayAmount
        self.symbol = symbol
        self.color = color
        self.onLongPressComplete = onLongPressComplete
    }
    
    public var body: some View {
        let size: CGFloat = 250
        let symbolTopPadding: CGFloat = 72

        ZStack(alignment: .leading) {
            DesignSystem.Colors.gray100.swiftUIColor
                .frame(width: size, height: size)

            color.opacity(0.2)
                .frame(width: fillWidth, height: size)
        }
        .clipShape(RoundedRectangle(cornerRadius: 36))
        .overlay(alignment: .topLeading) {
            AmountLabel()
                .padding(.top, 24)
                .padding(.leading, 24)
        }
        .overlay(alignment: .topTrailing) {
            Tag()
                .padding(.trailing, 40)
        }
        .overlay(alignment: .top) {
            SFSymbol(
                symbol: symbol,
                size: 68,
                color: DesignSystem.Colors.gray900.swiftUIColor
            )
            .padding(.top, symbolTopPadding)
        }
        .overlay(alignment: .top) {
            Text(title)
                .brandFont(.pretendard(.bold), 22)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                .frame(maxWidth: size - (16 * 2))
                .padding(.top, symbolTopPadding + symbolTopPadding + 16)
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .updating($isPressing) { _, state, _ in
                    state = true
                }
                .onChanged { _ in
                    if fillWidth < size {
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
    private func AmountLabel() -> some View {
        HStack(spacing: 0) {
            Text("+")
                .foregroundStyle(color)
            
            Text(toLabelString(todayAmount))
                .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
        }
        .brandFont(.poppins(.bold), 24)
    }
    
    @ViewBuilder
    private func Tag() -> some View {
        UnevenRoundedRectangle(
            topLeadingRadius: 0,
            bottomLeadingRadius: 12,
            bottomTrailingRadius: 12,
            topTrailingRadius: 0
        )
        .frame(width: 26, height: 38)
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
