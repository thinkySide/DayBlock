//
//  OnboardingSlideFeature.swift
//  Onboarding
//
//  Created by 김민준 on 3/1/26.
//

import ComposableArchitecture
import Domain
import Util

@Reducer
public struct OnboardingSlideFeature {

    @ObservableState
    public struct State: Equatable {
        var currentPage: Int = 0
        
        public init() {}
    }

    public enum Action: TCAFeatureAction, BindableAction {
        public enum ViewAction {}

        public enum InnerAction {}

        public enum DelegateAction {}

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)
    }

    @Dependency(\.haptic) private var haptic

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.currentPage):
                haptic.impact(.light)
                return .none

            default:
                return .none
            }
        }
    }
}
