//
//  ResetDataFeature.swift
//  MyInfo
//
//  Created by 김민준 on 2/15/26.
//

import ComposableArchitecture
import Domain
import PersistentData
import Util

@Reducer
public struct ResetDataFeature {

    @ObservableState
    public struct State: Equatable {
        var isPopupPresented: Bool = false
    }

    public enum Action: TCAFeatureAction, BindableAction {
        public enum ViewAction {
            case onTapBackButton
            case onTapResetDataButton
        }

        public enum InnerAction {

        }

        public enum DelegateAction {
            case didPop
        }
        
        public enum PopupAction {
            case cancel
            case reset
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case popup(PopupAction)
        case binding(BindingAction<State>)
    }

    public init() {}

    @Dependency(\.groupRepository) private var groupRepository

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .onTapBackButton:
                    return .send(.delegate(.didPop))
                    
                case .onTapResetDataButton:
                    state.isPopupPresented = true
                    return .none
                }
                
            case .popup(let popupAction):
                switch popupAction {
                case .cancel:
                    state.isPopupPresented = false
                    return .none
                    
                case .reset:
                    state.isPopupPresented = false
                    return .run { [groupRepository] send in
                        await groupRepository.resetAll()
                        await send(.delegate(.didPop))
                    }
                }

            default:
                return .none
            }
        }
    }
}
