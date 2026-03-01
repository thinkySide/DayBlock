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
        public init() {}
    }

    public enum Action: TCAFeatureAction {
        public enum ViewAction {
            
        }

        public enum InnerAction {

        }

        public enum DelegateAction {
            
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            
                
            default:
                return .none
            }
        }
    }
}
