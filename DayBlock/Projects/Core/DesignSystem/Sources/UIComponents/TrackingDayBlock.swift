//
//  TrackingDayBlock.swift
//  DesignSystem
//
//  Created by 김민준 on 1/10/26.
//

import SwiftUI

public struct TrackingDayBlock: View {

    let title: String
    let totalAmount: Double
    let todayAmount: Double
    let symbol: String
    let color: Color
    let onTapCell: () -> Void

    public init(
        title: String,
        totalAmount: Double,
        todayAmount: Double,
        symbol: String,
        color: Color,
        onTapCell: @escaping () -> Void = {}
    ) {
        self.title = title
        self.totalAmount = totalAmount
        self.todayAmount = todayAmount
        self.symbol = symbol
        self.color = color
        self.onTapCell = onTapCell
    }
    
    public var body: some View {
        let size: CGFloat = 250
        let symbolTopPadding: CGFloat = 72
        
        DesignSystem.Colors.gray100.swiftUIColor
            .frame(width: size, height: size)
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
            .onTapGesture {
                onTapCell()
            }
    }
}

// MARK: - SubViews
extension TrackingDayBlock {

    @ViewBuilder
    private func AmountLabel() -> some View {
        HStack(spacing: 0) {
            Text("+")
                .foregroundStyle(color)
            
            Text(toLabelString(totalAmount))
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
