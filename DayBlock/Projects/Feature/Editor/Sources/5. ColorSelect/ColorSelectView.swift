//
//  ColorSelectView.swift
//  Editor
//
//  Created by 김민준 on 12/28/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct ColorSelectView: View {
    
    private var store: StoreOf<ColorSelectFeature>

    public init(store: StoreOf<ColorSelectFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            NavigationBar(title: "색상 선택", isSheet: true)
            
            ColorScrollView()
        }
        .background(DesignSystem.Colors.gray0.swiftUIColor)
    }
    
    @ViewBuilder
    private func ColorScrollView() -> some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 5)
        ScrollViewReader { proxy in
            ScrollView {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(ColorPalette.colors, id: \.self) { color in
                        ColorCell(color: color)
                    }
                }
                .padding(16)
            }
            .onAppear {
                scrollToSelectedColor(proxy: proxy)
            }
        }
    }
    
    @ViewBuilder
    private func ColorCell(color: Color) -> some View {
        let selectedIndex = ColorPalette.colors.firstIndex(of: color) ?? 0
        let isSelected = selectedIndex == store.selectedColorIndex
        ZStack {
            if isSelected {
                Circle()
                    .fill(DesignSystem.Colors.gray300.swiftUIColor)

                Circle()
                    .strokeBorder(style: .init(lineWidth: 3))
                    .foregroundStyle(DesignSystem.Colors.gray600.swiftUIColor)
            }

            RoundedRectangle(cornerRadius: 10)
                .frame(width: 32, height: 32)
                .foregroundStyle(color)
        }
        .frame(width: 64, height: 64)
        .onTapGesture {
            store.send(.view(.onTapColor(selectedIndex: selectedIndex)))
        }
    }
}

// MARK: - Helper
extension ColorSelectView {
    
    /// 선택된 아이콘으로 스크롤합니다.
    private func scrollToSelectedColor(proxy: ScrollViewProxy) {
        let selectedColorName = ColorPalette.toColor(from: store.selectedColorIndex)
        proxy.scrollTo(selectedColorName, anchor: .center)
    }
}
