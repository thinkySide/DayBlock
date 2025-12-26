//
//  IconSelectFeature.swift
//  Editor
//
//  Created by 김민준 on 12/26/25.
//

import ComposableArchitecture
import Domain
import Util

@Reducer
public struct IconSelectFeature {

    @ObservableState
    public struct State: Equatable {
        var selectedIconIndex: Int
        
        public init(
            selectedIconIndex: Int
        ) {
            self.selectedIconIndex = selectedIconIndex
        }
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
        case binding(BindingAction<State>)
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
