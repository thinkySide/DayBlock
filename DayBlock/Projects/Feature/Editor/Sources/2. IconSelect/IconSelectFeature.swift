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
    
    public enum IconGroup {
        case all
        case object
        case nature
        case fitness
        case furniture
        case etc
    }

    @ObservableState
    public struct State: Equatable {
        var selectedIconIndex: Int
        var selectedIconGroup: IconGroup = .all
        
        public init(
            selectedIconIndex: Int
        ) {
            self.selectedIconIndex = selectedIconIndex
        }
    }

    public enum Action: TCAFeatureAction {
        public enum ViewAction {
            case onTapIconGroup(selectedIconGroup: IconGroup)
            case onTapIcon(selectedIndex: Int)
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
            case .view(let viewAction):
                switch viewAction {
                case .onTapIconGroup(let selectedIconGroup):
                    state.selectedIconGroup = selectedIconGroup
                    return .none

                case .onTapIcon(let selectedIndex):
                    state.selectedIconIndex = selectedIndex
                    return .none
                }
                
            default:
                return .none
            }
        }
    }
}
