//
//  MainView.swift
//  App
//
//  Created by 김민준 on 12/14/25.
//

import SwiftUI
import DesignSystem
import Tracking

struct MainView: View {
    
    @State private var tab: MainTab = .tracking
    
    var body: some View {
        TabView(selection: $tab) {
            Tab(value: MainTab.tracking) {
                TrackingCarouselView()
            } label: {
                Label {
                    Text("트래킹")
                } icon: {
                    DesignSystem.Icons.tabTracking.swiftUIImage
                }
            }
            
            Tab(value: MainTab.calendar) {
                EmptyView()
            } label: {
                Label {
                    Text("캘린더")
                } icon: {
                    DesignSystem.Icons.tabCalendar.swiftUIImage
                }
            }
            
            Tab(value: MainTab.repository) {
                EmptyView()
            } label: {
                Label {
                    Text("관리소")
                } icon: {
                    DesignSystem.Icons.tabRepository.swiftUIImage
                }
            }
            
            Tab(value: MainTab.myInfo) {
                EmptyView()
            } label: {
                Label {
                    Text("내정보")
                } icon: {
                    DesignSystem.Icons.tabMyinfo.swiftUIImage
                }
            }
        }
        .tint(DesignSystem.Colors.gray323232.swiftUIColor)
    }
}

#Preview {
    MainView()
}
