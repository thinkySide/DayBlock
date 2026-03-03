//
//  OnboardingStartFeature.swift
//  Onboarding
//
//  Created by 김민준 on 3/1/26.
//

import ComposableArchitecture
import Domain
import Util

@Reducer
public struct OnboardingStartFeature {

    @ObservableState
    public struct State: Equatable {
        @Presents var slide: OnboardingSlideFeature.State?
        public init() {}
    }

    public enum Action: TCAFeatureAction {
        public enum ViewAction {
            case startButtonTapped
        }

        public enum InnerAction {}

        public enum DelegateAction {}

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case slide(PresentationAction<OnboardingSlideFeature.Action>)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.startButtonTapped):
                state.slide = OnboardingSlideFeature.State()
                return .none

            default:
                return .none
            }
        }
        .ifLet(\.$slide, action: \.slide) {
            OnboardingSlideFeature()
        }
    }
}
