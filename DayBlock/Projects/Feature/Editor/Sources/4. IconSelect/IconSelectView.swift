//
//  IconSelectView.swift
//  Editor
//
//  Created by 김민준 on 12/26/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct IconSelectView: View {
    
    private var store: StoreOf<IconSelectFeature>

    public init(store: StoreOf<IconSelectFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            NavigationBar(title: "아이콘 선택", isSheet: true)
            
            IconGroupTab()
            
            IconScrollView()
        }
        .background(DesignSystem.Colors.gray0.swiftUIColor)
    }
    
    @ViewBuilder
    private func IconGroupTab() -> some View {
        HStack(spacing: 0) {
            IconGroupCell(.all)
            IconGroupCell(.object)
            IconGroupCell(.nature)
            IconGroupCell(.fitness)
            IconGroupCell(.furniture)
            IconGroupCell(.etc)
        }
    }
    
    @ViewBuilder
    private func IconGroupCell(_ iconGroup: IconSelectFeature.IconGroup) -> some View {
        let isSelected = iconGroup == store.selectedIconGroup
        Button {
            store.send(.view(.onTapIconGroup(selectedIconGroup: iconGroup)))
        } label: {
            Text(iconGroupName(from: iconGroup))
                .brandFont(.pretendard(.semiBold), 14)
                .foregroundStyle(
                    isSelected
                    ? DesignSystem.Colors.gray900.swiftUIColor
                    : DesignSystem.Colors.gray600.swiftUIColor
                )
                .frame(maxWidth: .infinity)
                .frame(height: 42)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(
                            isSelected
                            ? DesignSystem.Colors.gray900.swiftUIColor
                            : DesignSystem.Colors.gray500.swiftUIColor
                        )
                        .frame(height: isSelected ? 3 : 1)
                }
        }
    }
    
    @ViewBuilder
    private func IconScrollView() -> some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 5)
        ScrollViewReader { proxy in
            ScrollView {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(iconList(from: store.selectedIconGroup), id: \.self) { iconName in
                        IconCell(iconName: iconName)
                    }
                }
                .padding(16)
            }
            .onAppear {
                scrollToSelectedIcon(proxy: proxy)
            }
        }
    }

    @ViewBuilder
    private func IconCell(iconName: String) -> some View {
        let selectedIndex = IconPalette.icons.firstIndex(of: iconName) ?? 0
        let isSelected = selectedIndex == store.selectedIconIndex
        ZStack {
            if isSelected {
                Circle()
                    .fill(DesignSystem.Colors.gray300.swiftUIColor)

                Circle()
                    .strokeBorder(style: .init(lineWidth: 3))
                    .foregroundStyle(DesignSystem.Colors.gray600.swiftUIColor)
            }

            Image(systemName: iconName)
                .font(.system(size: 28))
                .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                .symbolEffect(.bounce, options: .repeating, isActive: isSelected)
        }
        .frame(width: 64, height: 64)
        .onTapGesture {
            store.send(.view(.onTapIcon(selectedIndex: selectedIndex)))
        }
    }
}

// MARK: - Helper
extension IconSelectView {

    /// 아이콘 그룹 이름을 반환합니다.
    private func iconGroupName(from iconGroup: IconSelectFeature.IconGroup) -> String {
        switch iconGroup {
        case .all: "전체"
        case .object: "사물"
        case .nature: "자연"
        case .fitness: "운동"
        case .furniture: "가구"
        case .etc: "기타"
        }
    }

    /// 아이콘 그룹에 해당하는 아이콘 배열을 반환합니다.
    private func iconList(from iconGroup: IconSelectFeature.IconGroup) -> [String] {
        switch iconGroup {
        case .all: IconPalette.icons
        case .object: IconPalette.objectIcons
        case .nature: IconPalette.natureIcons
        case .fitness: IconPalette.fitnessIcons
        case .furniture: IconPalette.furnitureIcons
        case .etc: IconPalette.etcIcons
        }
    }

    /// 선택된 아이콘으로 스크롤합니다.
    private func scrollToSelectedIcon(proxy: ScrollViewProxy) {
        let selectedIconName = IconPalette.toIcon(from: store.selectedIconIndex)
        proxy.scrollTo(selectedIconName, anchor: .center)
    }
}
