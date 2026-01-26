//
//  ManagementTabFeature.swift
//  Management
//
//  Created by 김민준 on 1/26/26.
//

import ComposableArchitecture
import Domain
import Editor
import Util

@Reducer
public struct ManagementTabFeature {
    
    @Reducer
    public enum Path {
        case groupEditor(GroupEditorFeature)
    }

    @ObservableState
    public struct State: Equatable {
        var selectedTab: Tab = .block
        
        public var path = StackState<Path.State>()
        var groupList: GroupListFeature.State = .init()
        var blockList: BlockListFeature.State = .init()
        
        public init() {}
        
        public enum Tab: Equatable, CaseIterable {
            case group
            case block
        }
    }

    public enum Action: TCAFeatureAction, BindableAction {
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
        case binding(BindingAction<State>)
        case path(StackActionOf<Path>)
        case groupList(GroupListFeature.Action)
        case blockList(BlockListFeature.Action)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
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
                
            case .groupList(.delegate(.pushEditGroupEditor(let group))):
                state.path.append(.groupEditor(.init(mode: .edit(group), isSheet: false)))
                return .none

            case .groupList(.delegate(.pushAddGroupEditor)):
                state.path.append(.groupEditor(.init(mode: .add, isSheet: false)))
                return .none
                
            case .path(let stackAction):
                switch stackAction {
                case .element(id: _, action: .groupEditor(.delegate(.didPop))):
                    state.path.removeAll()
                    return .none
                    
                case .element(id: _, action: .groupEditor(.delegate(.didConfirm))):
                    state.path.removeAll()
                    return .none
                    
                default:
                    return .none
                }

            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

// MARK: - Path
extension ManagementTabFeature.Path.State: Equatable {}
