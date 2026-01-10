//
//  MainTabBar.swift
//  App
//
//  Created by 김민준 on 12/21/25.
//

import SwiftUI
import DesignSystem

struct MainTabBar: View {

    @Binding var selectedTab: MainTab

    var body: some View {
        HStack(spacing: 0) {
            TabBarItem(
                selectedTab: $selectedTab,
                tab: .tracking,
                icon: DesignSystem.Icons.tabTracking,
                label: "트래킹"
            )

            TabBarItem(
                selectedTab: $selectedTab,
                tab: .calendar,
                icon: DesignSystem.Icons.tabCalendar,
                label: "캘린더"
            )

            TabBarItem(
                selectedTab: $selectedTab,
                tab: .repository,
                icon: DesignSystem.Icons.tabRepository,
                label: "관리소"
            )

            TabBarItem(
                selectedTab: $selectedTab,
                tab: .myInfo,
                icon: DesignSystem.Icons.tabMyinfo,
                label: "내정보"
            )
        }
        .frame(height: 40)
    }
}

// MARK: - TabBarItem
private struct TabBarItem: View {
    
    @Binding var selectedTab: MainTab

    let tab: MainTab
    let icon: DesignSystemImages
    let label: String

    var body: some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                icon.swiftUIImage
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(
                        isSelected
                        ? DesignSystem.Colors.gray900.swiftUIColor
                        : DesignSystem.Colors.gray500.swiftUIColor
                    )

                Text(label)
                    .brandFont(.pretendard(isSelected ? .bold : .medium), 10)
                    .foregroundStyle(
                        isSelected
                        ? DesignSystem.Colors.gray900.swiftUIColor
                        : DesignSystem.Colors.gray500.swiftUIColor
                    )
            }
            .frame(maxWidth: 72)
        }
    }
    
    private var isSelected: Bool {
        selectedTab == tab
    }
}
