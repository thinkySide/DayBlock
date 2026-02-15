//
//  ResetDataFeature.swift
//  MyInfo
//
//  Created by 김민준 on 2/15/26.
//

import ComposableArchitecture
import Domain
import Util

@Reducer
public struct ResetDataFeature {

    @ObservableState
    public struct State: Equatable {
        
    }

    public enum Action: TCAFeatureAction {
        public enum ViewAction {
            case didPop
        }

        public enum InnerAction {

        }

        public enum DelegateAction {
            case pop
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .didPop:
                    return .send(.delegate(.pop))
                }

            default:
                return .none
            }
        }
    }
}
