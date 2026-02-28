//
//  DeveloperInfoFeature.swift
//  MyInfo
//
//  Created by 김민준 on 2/28/26.
//

import ComposableArchitecture
import Domain
import Util

@Reducer
public struct DeveloperInfoFeature {

    @ObservableState
    public struct State: Equatable {
        
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
