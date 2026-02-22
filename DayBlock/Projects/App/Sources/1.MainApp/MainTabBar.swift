//
//  MainTabBar.swift
//  App
//
//  Created by 김민준 on 12/21/25.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

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
                tab: .management,
                icon: DesignSystem.Icons.tabRepository,
                label: "관리소"
            )
            
            TabBarItem(
                selectedTab: $selectedTab,
                tab: .calendar,
                icon: DesignSystem.Icons.tabCalendar,
                label: "캘린더"
            )

            TabBarItem(
                selectedTab: $selectedTab,
                tab: .myInfo,
                icon: DesignSystem.Icons.tabMyinfo,
                label: "내정보"
            )
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }
}

// MARK: - TabBarItem
private struct TabBarItem: View {
    
    @Binding var selectedTab: MainTab
    @Dependency(\.haptic) private var haptic

    let tab: MainTab
    let icon: DesignSystemImages
    let label: String

    var body: some View {
        Button {
            haptic.impact(.soft)
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
                    .brandFont(.pretendard(isSelected ? .bold : .semiBold), 10)
                    .foregroundStyle(
                        isSelected
                        ? DesignSystem.Colors.gray900.swiftUIColor
                        : DesignSystem.Colors.gray600.swiftUIColor
                    )
            }
            .transaction { $0.animation = nil }
            .frame(width: 72, height: 40)
            .contentShape(.rect)
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    private var isSelected: Bool {
        selectedTab == tab
    }
}
