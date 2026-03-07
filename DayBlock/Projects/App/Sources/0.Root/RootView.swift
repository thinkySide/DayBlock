//
//  RootView.swift
//  App
//
//  Created by 김민준 on 3/7/26.
//

import SwiftUI
import ComposableArchitecture
import Onboarding

struct RootView: View {

    let store: StoreOf<RootFeature>

    var body: some View {
        if store.isOnboardingCompleted {
            MainView(store: store.scope(state: \.main, action: \.main))
        } else {
            OnboardingStartView(
                store: store.scope(state: \.onboarding, action: \.onboarding)
            )
        }
    }
}
