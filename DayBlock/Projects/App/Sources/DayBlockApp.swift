//
//  DayBlockApp.swift
//  App
//
//  Created by 김민준 on 12/14/25.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

@main
struct DayBlockApp: App {

    @State private var store = Store(initialState: .init()) {
        MainAppFeature()
    }

    init() {
        DesignSystemConfiguration.configure()
    }

    var body: some Scene {
        WindowGroup {
            MainView(store: store)
        }
    }
}
