//
//  OnboardingDemoApp.swift
//  Onboarding
//
//  Created by 김민준 on 3/1/26.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture
import PersistentData
import SwiftData
import Onboarding

@main
struct MyInfoDemoApp: App {
    
    let store = Store(initialState: .init()) {
        OnboardingSlideFeature()
    }
    
    @Dependency(\.modelContainer) private var modelContainer
    
    init() {
        DesignSystemConfiguration.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            OnboardingSlideView(store: store)
        }
        .modelContainer(modelContainer)
    }
}
