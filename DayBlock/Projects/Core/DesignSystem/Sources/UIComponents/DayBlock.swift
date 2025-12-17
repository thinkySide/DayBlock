//
//  DayBlock.swift
//  DesignSystem
//
//  Created by 김민준 on 12/17/25.
//

import SwiftUI

public struct DayBlock: View {
    
    let title: String
    let amount: Double
    let symbol: Symbol
    let color: Color
    let state: State
    
    public init(
        title: String,
        amount: Double,
        symbol: Symbol,
        color: Color,
        state: State
    ) {
        self.title = title
        self.amount = amount
        self.symbol = symbol
        self.color = color
        self.state = state
    }
    
    public var body: some View {
        DesignSystem.Colors.grayF4F5F7.swiftUIColor
            .frame(width: state.size, height: state.size)
            .clipShape(RoundedRectangle(cornerRadius: state.cornerRadius))
            .overlay(alignment: .topLeading) {
                AmountLabel()
                    .padding(.top, state.amountLabelPadding)
                    .padding(.leading, state.amountLabelPadding)
            }
            .overlay(alignment: .topTrailing) {
                Tag()
                    .padding(.trailing, state.tagTrailingPadding)
            }
            .overlay(alignment: .top) {
                SFSymbol(
                    symbol: symbol,
                    size: state.symbolSize,
                    color: DesignSystem.Colors.gray323232.swiftUIColor
                )
                .padding(.top, state.symbolTopPadding)
            }
            .overlay(alignment: .top) {
                Text(title)
                    .brandFont(.pretendard(.bold), state.titleFontSize)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(DesignSystem.Colors.gray323232.swiftUIColor)
                    .frame(maxWidth: state.size - (state.titleHorizontalPadding * 2))
                    .padding(.top, state.symbolTopPadding + state.symbolSize + 16)
            }
    }
    
    @ViewBuilder
    private func AmountLabel() -> some View {
        HStack(spacing: 0) {
            Text("+")
                .foregroundStyle(color)
            
            Text(String(format: "%.1f", amount))
                .foregroundStyle(DesignSystem.Colors.gray323232.swiftUIColor)
        }
        .brandFont(.poppins(.bold), state.amountLabelFontSize)
    }
    
    @ViewBuilder
    private func Tag() -> some View {
        UnevenRoundedRectangle(
            topLeadingRadius: 0,
            bottomLeadingRadius: state.tagCornerRadius,
            bottomTrailingRadius: state.tagCornerRadius,
            topTrailingRadius: 0
        )
        .frame(width: state.tagWidth, height: state.tagHeight)
        .foregroundStyle(color)
    }
}

// MARK: - State
extension DayBlock {
    
    public enum State {
        case medium
        case large
        
        var size: CGFloat {
            switch self {
            case .medium: 180
            case .large: 250
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .medium: 26
            case .large: 36
            }
        }
        
        var amountLabelFontSize: CGFloat {
            switch self {
            case .medium: 18
            case .large: 24
            }
        }
        
        var amountLabelPadding: CGFloat {
            switch self {
            case .medium: 16
            case .large: 24
            }
        }
        
        var tagCornerRadius: CGFloat {
            switch self {
            case .medium: 9
            case .large: 11
            }
        }
        
        var tagWidth: CGFloat {
            switch self {
            case .medium: 20
            case .large: 26
            }
        }
        
        var tagHeight: CGFloat {
            switch self {
            case .medium: 30
            case .large: 38
            }
        }
        
        var tagTrailingPadding: CGFloat {
            switch self {
            case .medium: 32
            case .large: 48
            }
        }
        
        var symbolSize: CGFloat {
            switch self {
            case .medium: 52
            case .large: 68
            }
        }
        
        var symbolTopPadding: CGFloat {
            switch self {
            case .medium: 52
            case .large: 68
            }
        }
        
        var titleFontSize: CGFloat {
            switch self {
            case .medium: 17
            case .large: 24
            }
        }
        
        var titleBottomPadding: CGFloat {
            switch self {
            case .medium: 24
            case .large: 36
            }
        }
        
        var titleHorizontalPadding: CGFloat {
            switch self {
            case .medium: 16
            case .large: 24
            }
        }
    }
}
