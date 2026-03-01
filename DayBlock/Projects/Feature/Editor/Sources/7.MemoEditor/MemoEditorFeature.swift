//
//  MemoEditorFeature.swift
//  Editor
//
//  Created by 김민준 on 1/25/26.
//

import ComposableArchitecture
import Domain
import Util

@Reducer
public struct MemoEditorFeature {

    @ObservableState
    public struct State: Equatable {
        var memoText: String
        var colorIndex: Int
        
        public init(
            memoText: String,
            colorIndex: Int
        ) {
            self.memoText = memoText
            self.colorIndex = colorIndex
        }
    }

    public enum Action: TCAFeatureAction, BindableAction {
        public enum ViewAction {
            case onTapDismissButton
            case onTapConfirmButton
        }

        public enum InnerAction {

        }

        public enum DelegateAction {
            case didDismiss
            case didConfirm(memoText: String)
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .onTapDismissButton:
                    return .send(.delegate(.didDismiss))
                    
                case .onTapConfirmButton:
                    return .send(.delegate(.didConfirm(memoText: state.memoText)))
                }
                
            default:
                return .none
            }
        }
    }
}
