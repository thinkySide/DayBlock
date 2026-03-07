//
//  RootFeature.swift
//  App
//
//  Created by 김민준 on 3/7/26.
//

import ComposableArchitecture
import Onboarding
import UserDefaults
import Util

@Reducer
struct RootFeature {

    @ObservableState
    struct State {
        var isOnboardingCompleted: Bool
        var main: MainAppFeature.State = .init()
        var onboarding: OnboardingStartFeature.State = .init()

        init() {
            @Dependency(\.userDefaultsService) var userDefaultsService
            self.isOnboardingCompleted = userDefaultsService.get(\.isOnboardingCompleted)
        }
    }

    enum Action {
        case main(MainAppFeature.Action)
        case onboarding(OnboardingStartFeature.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.main, action: \.main) {
            MainAppFeature()
        }
        Scope(state: \.onboarding, action: \.onboarding) {
            OnboardingStartFeature()
        }
        Reduce { state, action in
            switch action {
            case .onboarding(.delegate(.didCompleteOnboarding)):
                state.isOnboardingCompleted = true
                return .none

            default:
                return .none
            }
        }
    }
}
