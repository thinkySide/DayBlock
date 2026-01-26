//
//  ManagementTabFeature.swift
//  Management
//
//  Created by 김민준 on 1/26/26.
//

import ComposableArchitecture
import Domain
import Util

@Reducer
public struct ManagementTabFeature {

    @ObservableState
    public struct State: Equatable {
        var selectedTab: Tab = .group
        
        var groupList: GroupListFeature.State = .init()
        var blockList: BlockListFeature.State = .init()
        
        public init() {}
        
        public enum Tab: Equatable, CaseIterable {
            case group
            case block
        }
    }

    public enum Action: TCAFeatureAction {
        public enum ViewAction {
            case onTapTab(State.Tab)
        }

        public enum InnerAction {

        }

        public enum DelegateAction {
            
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case groupList(GroupListFeature.Action)
        case blockList(BlockListFeature.Action)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.groupList, action: \.groupList) {
            GroupListFeature()
        }
        Scope(state: \.blockList, action: \.blockList) {
            BlockListFeature()
        }
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .onTapTab(let tab):
                    state.selectedTab = tab
                    return .none
                }
                
            default:
                return .none
            }
        }
    }
}
