//
//  MainView.swift
//  App
//
//  Created by 김민준 on 12/14/25.
//

import SwiftUI
import DesignSystem
import Tracking
import Management
import Calendar
import MyInfo
import ComposableArchitecture

struct MainView: View {

    @Bindable var store: StoreOf<MainAppFeature>

    var body: some View {
        Group {
            switch store.selectedTab {
            case .tracking:
                BlockCarouselView(
                    store: store.scope(state: \.tracking, action: \.tracking)
                )

            case .management:
                ManagementTabView(
                    store: store.scope(state: \.management, action: \.management)
                )
                
            case .calendar:
                CalendarView(
                    store: store.scope(state: \.calendar, action: \.calendar)
                )

            case .myInfo:
                MyInfoListView(
                    store: store.scope(state: \.myInfo, action: \.myInfo)
                )
            }
        }
        .overlay(alignment: .bottom) {
            Group {
                if store.isTabBarVisible {
                    MainTabBar(selectedTab: $store.selectedTab)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: store.isTabBarVisible)
        }
    }
}
