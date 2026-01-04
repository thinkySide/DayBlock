//
//  CarouselDayBlock.swift
//  DesignSystem
//
//  Created by 김민준 on 12/17/25.
//

import SwiftUI

public struct CarouselDayBlock: View {

    public enum Variation {
        case front
        case back
    }

    let title: String
    let totalAmount: Double
    let todayAmount: Double
    let symbol: String
    let color: Color
    let variation: Variation

    let onTapCell: () -> Void
    let onTapDeleteButton: () -> Void
    let onTapEditButton: () -> Void

    @State private var rotation: Double = 0
    
    public init(
        title: String,
        totalAmount: Double,
        todayAmount: Double,
        symbol: String,
        color: Color,
        variation: Variation,
        onTapCell: @escaping () -> Void = {},
        onTapDeleteButton: @escaping () -> Void = {},
        onTapEditButton: @escaping () -> Void = {}
    ) {
        self.title = title
        self.totalAmount = totalAmount
        self.todayAmount = todayAmount
        self.symbol = symbol
        self.color = color
        self.variation = variation
        self.onTapCell = onTapCell
        self.onTapDeleteButton = onTapDeleteButton
        self.onTapEditButton = onTapEditButton
    }
    
    public var body: some View {
        ZStack {
            FrontView()
                .opacity(rotation < 90 ? 1 : 0)
                .rotation3DEffect(
                    .degrees(rotation),
                    axis: (x: 0, y: 1, z: 0)
                )

            BackView()
                .opacity(rotation >= 90 ? 1 : 0)
                .rotation3DEffect(
                    .degrees(rotation - 180),
                    axis: (x: 0, y: 1, z: 0)
                )
        }
        .onTapGesture {
            onTapCell()
        }
        .onAppear {
            rotation = variation == .back ? 180 : 0
        }
        .onChange(of: variation) { _, value in
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                rotation = value == .back ? 180 : 0
            }
        }
    }
}

// MARK: - Views
extension CarouselDayBlock {

    @ViewBuilder
    private func FrontView() -> some View {
        DesignSystem.Colors.grayF4F5F7.swiftUIColor
            .frame(width: 180, height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 26))
            .overlay(alignment: .topLeading) {
                AmountLabel()
                    .padding(.top, 16)
                    .padding(.leading, 16)
            }
            .overlay(alignment: .topTrailing) {
                Tag()
                    .padding(.trailing, 32)
            }
            .overlay(alignment: .top) {
                SFSymbol(
                    symbol: symbol,
                    size: 52,
                    color: DesignSystem.Colors.gray323232.swiftUIColor
                )
                .padding(.top, 52)
            }
            .overlay(alignment: .top) {
                Text(title)
                    .brandFont(.pretendard(.bold), 17)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(DesignSystem.Colors.gray323232.swiftUIColor)
                    .frame(maxWidth: 180 - (16 * 2))
                    .padding(.top, 52 + 52 + 16)
            }
    }

    @ViewBuilder
    private func BackView() -> some View {
        DesignSystem.Colors.grayF4F5F7.swiftUIColor
            .frame(width: 180, height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 26))
            .overlay(alignment: .top) {
                HStack(spacing: 22) {
                    LeftVStack()
                    RightVStack()
                }
                .padding(.top, 32)
            }
            .overlay(alignment: .top) {
                Capsule()
                    .frame(width: 2, height: 22)
                    .foregroundStyle(DesignSystem.Colors.grayC5C5C5.swiftUIColor)
                    .padding(.top, 48)
            }
    }
}

// MARK: - Front
extension CarouselDayBlock {

    @ViewBuilder
    private func AmountLabel() -> some View {
        HStack(spacing: 0) {
            Text("+")
                .foregroundStyle(color)
            
            Text(toLabelString(totalAmount))
                .foregroundStyle(DesignSystem.Colors.gray323232.swiftUIColor)
        }
        .brandFont(.poppins(.bold), 18)
    }
    
    @ViewBuilder
    private func Tag() -> some View {
        UnevenRoundedRectangle(
            topLeadingRadius: 0,
            bottomLeadingRadius: 9,
            bottomTrailingRadius: 9,
            topTrailingRadius: 0
        )
        .frame(width: 20, height: 30)
        .foregroundStyle(color)
    }
}

// MARK: - Back
extension CarouselDayBlock {
    
    @ViewBuilder
    private func LeftVStack() -> some View {
        VStack(spacing: 0) {
            TotalAmountVStack()
            
            DeleteButton()
                .padding(.top, 20)
        }
    }
    
    @ViewBuilder
    private func RightVStack() -> some View {
        VStack(spacing: 0) {
            TodayAmountVStack()
            
            EditButton()
                .padding(.top, 20)
        }
    }
    
    @ViewBuilder
    private func TotalAmountVStack() -> some View {
        VStack(spacing: -4) {
            Text(toLabelString(totalAmount))
                .brandFont(.poppins(.bold), 20)
                .foregroundStyle(DesignSystem.Colors.gray323232.swiftUIColor)
            
            Text("total")
                .brandFont(.poppins(.bold), 14)
                .foregroundStyle(DesignSystem.Colors.gray616161.swiftUIColor)
        }
    }
    
    @ViewBuilder
    private func TodayAmountVStack() -> some View {
        VStack(spacing: -4) {
            Text(toLabelString(todayAmount))
                .brandFont(.poppins(.bold), 20)
                .foregroundStyle(DesignSystem.Colors.gray323232.swiftUIColor)
            
            Text("today")
                .brandFont(.poppins(.bold), 14)
                .foregroundStyle(DesignSystem.Colors.gray616161.swiftUIColor)
        }
    }
    
    @ViewBuilder
    private func DeleteButton() -> some View {
        Button {
            onTapDeleteButton()
        } label: {
            Circle()
                .frame(width: 56, height: 56)
                .foregroundStyle(DesignSystem.Colors.eventDestructive.swiftUIColor)
                .overlay(
                    SFSymbol(
                        symbol: Symbol.trash_fill.symbolName,
                        size: 32,
                        color: DesignSystem.Colors.grayF4F5F7.swiftUIColor
                    )
                )
        }
    }
    
    @ViewBuilder
    private func EditButton() -> some View {
        Button {
            onTapEditButton()
        } label: {
            Circle()
                .frame(width: 56, height: 56)
                .foregroundStyle(DesignSystem.Colors.gray323232.swiftUIColor)
                .overlay(
                    SFSymbol(
                        symbol: Symbol.pencil.symbolName,
                        size: 32,
                        color: DesignSystem.Colors.grayF4F5F7.swiftUIColor
                    )
                )
        }
    }
}

// MARK: - Helper
extension CarouselDayBlock {
    
    /// 생산량 Double 타입을 문자열로 변환합니다.
    private func toLabelString(_ amount: Double) -> String {
        String(format: "%.1f", amount)
    }
}
