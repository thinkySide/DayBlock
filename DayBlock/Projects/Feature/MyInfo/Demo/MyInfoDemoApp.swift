//
//  MyInfoDemoApp.swift
//  MyInfo
//
//  Created by 김민준 on 2/14/26.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture
import PersistentData
import SwiftData
import MyInfo

@main
struct MyInfoDemoApp: App {
    
    let store = Store(initialState: .init()) {
        MyInfoListFeature()
    }
    
    @Dependency(\.modelContainer) private var modelContainer
    
    init() {
        DesignSystemConfiguration.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MyInfoListView(store: store)
        }
        .modelContainer(modelContainer)
    }
}
