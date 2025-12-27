//
//  GroupSelectFeature.swift
//  Editor
//
//  Created by 김민준 on 12/27/25.
//

import ComposableArchitecture
import Domain
import Util

@Reducer
public struct GroupSelectFeature {

    @ObservableState
    public struct State: Equatable {
        var selectedGroup: BlockGroup
        var groupList: IdentifiedArrayOf<BlockGroup> = [
            .defaultValue,
            .init(name: "운동", colorIndex: 13),
            .init(name: "공부", colorIndex: 27)
        ]
        
        @Presents var groupEditor: GroupEditorFeature.State?
        
        public init(
            selectedGroup: BlockGroup
        ) {
            self.selectedGroup = selectedGroup
        }
    }

    public enum Action: TCAFeatureAction {
        public enum ViewAction {
            case onTapGroup(BlockGroup)
            case onTapAddGroup
        }

        public enum InnerAction {

        }

        public enum DelegateAction {
            case didSelectGroup(BlockGroup)
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case groupEditor(PresentationAction<GroupEditorFeature.Action>)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .onTapGroup(let group):
                    state.selectedGroup = group
                    return .send(.delegate(.didSelectGroup(group)))

                case .onTapAddGroup:
                    state.groupEditor = .init(mode: .add)
                    return .none
                }
                
            case .groupEditor(.presented(.delegate(.didPop))):
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
