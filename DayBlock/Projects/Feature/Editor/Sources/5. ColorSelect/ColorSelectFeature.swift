//
//  ColorSelectFeature.swift
//  Editor
//
//  Created by 김민준 on 12/28/25.
//

import ComposableArchitecture
import Domain
import Util

@Reducer
public struct ColorSelectFeature {

    @ObservableState
    public struct State: Equatable {
        var selectedColorIndex: Int
        
        public init(
            selectedColorIndex: Int
        ) {
            self.selectedColorIndex = selectedColorIndex
        }
    }

    public enum Action: TCAFeatureAction {
        public enum ViewAction {
            case onTapColor(selectedIndex: Int)
        }

        public enum InnerAction {

        }

        public enum DelegateAction {
            case didSelectColor(selectedIndex: Int)
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
                case .onTapColor(let selectedIndex):
                    state.selectedColorIndex = selectedIndex
                    return .send(.delegate(.didSelectColor(selectedIndex: selectedIndex)))
                }
                
            default:
                return .none
            }
        }
    }
}

