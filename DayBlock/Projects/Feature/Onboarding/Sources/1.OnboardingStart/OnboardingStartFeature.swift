//
//  OnboardingStartFeature.swift
//  Onboarding
//
//  Created by 김민준 on 3/1/26.
//

import ComposableArchitecture
import Domain
import PersistentData
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

        public enum DelegateAction {
            case didCompleteOnboarding
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case slide(PresentationAction<OnboardingSlideFeature.Action>)
    }

    public init() {}
    
    @Dependency(\.haptic) private var haptic

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.startButtonTapped):
                haptic.impact(.soft)
                state.slide = OnboardingSlideFeature.State()
                return .none

            case .slide(.presented(.delegate(.didCompleteOnboarding))):
                return .send(.delegate(.didCompleteOnboarding))

            default:
                return .none
            }
        }
        .ifLet(\.$slide, action: \.slide) {
            OnboardingSlideFeature()
        }
    }
}
