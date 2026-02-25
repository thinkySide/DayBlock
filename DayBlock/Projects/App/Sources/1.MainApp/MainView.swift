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
        TabView(selection: $store.selectedTab) {
            BlockCarouselView(
                store: store.scope(state: \.tracking, action: \.tracking)
            )
            .tag(MainTab.tracking)
            .tabItem {
                DesignSystem.Icons.tabTracking.swiftUIImage
                    .renderingMode(.template)
                Text("트래킹")
            }

            ManagementTabView(
                store: store.scope(state: \.management, action: \.management)
            )
            .tag(MainTab.management)
            .tabItem {
                DesignSystem.Icons.tabRepository.swiftUIImage
                    .renderingMode(.template)
                Text("관리소")
            }

            CalendarView(
                store: store.scope(state: \.calendar, action: \.calendar)
            )
            .tag(MainTab.calendar)
            .tabItem {
                DesignSystem.Icons.tabCalendar.swiftUIImage
                    .renderingMode(.template)
                Text("캘린더")
            }

            MyInfoListView(
                store: store.scope(state: \.myInfo, action: \.myInfo)
            )
            .tag(MainTab.myInfo)
            .tabItem {
                DesignSystem.Icons.tabMyinfo.swiftUIImage
                    .renderingMode(.template)
                Text("내정보")
            }
        }
        .tint(DesignSystem.Colors.gray900.swiftUIColor)
    }
}
