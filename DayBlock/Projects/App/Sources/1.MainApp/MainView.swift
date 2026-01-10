//
//  MainView.swift
//  App
//
//  Created by 김민준 on 12/14/25.
//

import SwiftUI
import DesignSystem
import Tracking
import ComposableArchitecture

struct MainView: View {

    @Bindable var store: StoreOf<MainAppFeature>

    var body: some View {
        Group {
            switch store.selectedTab {
            case .tracking:
                BlockCarouselView(
                    store: store.scope(state: \.trackingState, action: \.tracking)
                )

            case .calendar:
                ScrollView {}

            case .repository:
                ScrollView {}

            case .myInfo:
                ScrollView {}
            }
        }
        .overlay(alignment: .bottom) {
            if isTabBarVisible {
                MainTabBar(selectedTab: $store.selectedTab)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isTabBarVisible)
    }
}

// MARK: - Helper
extension MainView {
    
    /// TabBar가 표시되는 조건을 반환합니다.
    private var isTabBarVisible: Bool {
        store.trackingState.path.isEmpty
    }
}
