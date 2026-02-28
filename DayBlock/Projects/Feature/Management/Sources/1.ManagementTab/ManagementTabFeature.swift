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
    
    @ObservableState
    public struct State: Equatable {
        var selectedTab: Tab = .group

        @Presents var groupEditor: GroupEditorFeature.State?
        @Presents var blockEditor: BlockEditorFeature.State?
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
        case groupEditor(PresentationAction<GroupEditorFeature.Action>)
        case blockEditor(PresentationAction<BlockEditorFeature.Action>)
        case groupList(GroupListFeature.Action)
        case blockList(BlockListFeature.Action)
    }
    
    @Dependency(\.haptic) private var haptic

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
                    haptic.impact(.soft)
                    state.selectedTab = tab
                    return .none
                }
                
            case .groupList(.delegate(.pushEditGroupEditor(let group))):
                state.groupEditor = .init(mode: .edit(group))
                return .none

            case .groupList(.delegate(.pushAddGroupEditor)):
                state.groupEditor = .init(mode: .add)
                return .none
                
            case .blockList(.delegate(.pushEditBlockEditor(let block, let group))):
                state.blockEditor = .init(mode: .edit(selectedBlock: block), selectedGroup: group)
                return .none

            case .blockList(.delegate(.pushAddBlockEditor(let group))):
                state.blockEditor = .init(mode: .add, selectedGroup: group)
                return .none
                
            case .groupEditor(.presented(.delegate(.didPop))):
                state.groupEditor = nil
                return .none

            case .groupEditor(.presented(.delegate(.didConfirm))):
                state.groupEditor = nil
                return .none

            case .groupEditor(.presented(.delegate(.didDelete))):
                state.groupEditor = nil
                return .none

            case .blockEditor(.presented(.delegate(.didPop))):
                state.blockEditor = nil
                return .none

            case .blockEditor(.presented(.delegate(.didConfirm))):
                state.blockEditor = nil
                return .none

            case .blockEditor(.presented(.delegate(.didDelete))):
                state.blockEditor = nil
                return .none

            default:
                return .none
            }
        }
        .ifLet(\.$groupEditor, action: \.groupEditor) {
            GroupEditorFeature()
        }
        .ifLet(\.$blockEditor, action: \.blockEditor) {
            BlockEditorFeature()
        }
    }
}
