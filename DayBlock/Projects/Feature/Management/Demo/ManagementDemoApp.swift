//
//  ManagementDemoApp.swift
//  Management
//
//  Created by 김민준 on 1/26/26.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture
import Management
import PersistentData
import SwiftData

@main
struct ManagementDemoApp: App {
    
    let store = Store(initialState: .init()) {
        ManagementTabFeature()
    }
    
    @Dependency(\.modelContainer) private var modelContainer
    
    init() {
        DesignSystemConfiguration.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ManagementTabView(store: store)
        }
        .modelContainer(modelContainer)
    }
}
