//
//  GroupSelectFeature.swift
//  Editor
//
//  Created by 김민준 on 12/27/25.
//

import ComposableArchitecture
import Domain
import PersistentData
import Util

@Reducer
public struct GroupSelectFeature {

    @ObservableState
    public struct State: Equatable {
        var selectedGroup: BlockGroup
        var groupList: IdentifiedArrayOf<BlockGroup> = []
        
        @Presents var groupEditor: GroupEditorFeature.State?
        
        public init(
            selectedGroup: BlockGroup
        ) {
            self.selectedGroup = selectedGroup
        }
    }

    public enum Action: TCAFeatureAction {
        public enum ViewAction {
            case onAppear
            case onTapGroup(BlockGroup)
            case onTapAddGroup
        }

        public enum InnerAction {

        }

        public enum DelegateAction {
            case didSelectGroup(BlockGroup)
            case didSelectAddGroup
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case groupEditor(PresentationAction<GroupEditorFeature.Action>)
    }
    
    @Dependency(\.swiftDataRepository) private var swiftDataRepository

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .onAppear:
                    let groupList = swiftDataRepository.fetchGroupList()
                    state.groupList = .init(uniqueElements: groupList)
                    return .none
                    
                case .onTapGroup(let group):
                    state.selectedGroup = group
                    return .send(.delegate(.didSelectGroup(group)))

                case .onTapAddGroup:
                    state.groupEditor = .init(mode: .add)
                    return .send(.delegate(.didSelectAddGroup))
                }
                
            case .groupEditor(.presented(.delegate(.didPop))):
                state.groupEditor = nil
                return .none

            case .groupEditor(.dismiss):
                state.groupEditor = nil
                return .none

            default:
                return .none
            }
        }
        .ifLet(\.$groupEditor, action: \.groupEditor) {
            GroupEditorFeature()
        }
    }
}
