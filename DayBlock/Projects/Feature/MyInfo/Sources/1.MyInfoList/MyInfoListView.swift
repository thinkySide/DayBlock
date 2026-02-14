//
//  MyInfoListView.swift
//  MyInfo
//
//  Created by 김민준 on 2/14/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct MyInfoListView: View {
    
    private var store: StoreOf<MyInfoListFeature>

    public init(store: StoreOf<MyInfoListFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            NavigationBar()
            
            Header()
            
            Spacer()
        }
        .background(DesignSystem.Colors.gray0.swiftUIColor)
    }
    
    @ViewBuilder
    private func Header() -> some View {
        VStack(spacing: 20) {
            Text("생산한 블럭을\n차곡차곡 쌓아뒀어요")
                .brandFont(.pretendard(.bold), 20)
                .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 24) {
                HeaderInfoCell(
                    title: "total",
                    value: 72.5,
                    symbolName: Symbol.batteryblock_fill.symbolName,
                    color: DesignSystem.ColorPalette.blueBlock4.swiftUIColor
                )
                
                HeaderInfoCell(
                    title: "today",
                    value: 2.5,
                    symbolName: Symbol.gauge_with_needle_fill.symbolName,
                    color: DesignSystem.ColorPalette.greenBlock4.swiftUIColor
                )
                
                HeaderInfoCell(
                    title: "streaks",
                    value: 13,
                    symbolName: Symbol.flame_fill.symbolName,
                    color: DesignSystem.ColorPalette.redBlock5.swiftUIColor
                )
            }
        }
    }
    
    @ViewBuilder
    private func HeaderInfoCell(
        title: String,
        value: Double,
        symbolName: String,
        color: Color
    ) -> some View {
        VStack(spacing: 0) {
            Circle()
                .frame(width: 24, height: 24)
                .foregroundStyle(color.opacity(0.3))
                .overlay {
                    SFSymbol(
                        symbol: symbolName,
                        size: 12,
                        color: color
                    )
                }
            
            Text(value.toValueString())
                .brandFont(.poppins(.semiBold), 16)
                .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                .padding(.top, 3)
            
            Text(title)
                .brandFont(.poppins(.semiBold), 16)
                .foregroundStyle(DesignSystem.Colors.gray400.swiftUIColor)
        }
        .frame(width: 64)
    }
}
