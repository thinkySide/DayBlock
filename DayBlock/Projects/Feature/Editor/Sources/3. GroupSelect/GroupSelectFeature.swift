//
//  GroupSelectFeature.swift
//  Editor
//
//  Created by 김민준 on 12/27/25.
//

import Foundation
import ComposableArchitecture
import Domain
import PersistentData
import Util

@Reducer
public struct GroupSelectFeature {
    
    public struct GroupListViewItem: Identifiable, Equatable {
        public var id: UUID { group.id }
        public let group: BlockGroup
        public let blockCount: Int
    }

    @ObservableState
    public struct State: Equatable {
        var selectedGroup: BlockGroup
        var groupList: IdentifiedArrayOf<GroupListViewItem> = []
        
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
                    state.groupList = fetchGroupListViewItems()
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

// MARK: - Helper
extension GroupSelectFeature {
    
    /// 전체 GroupList ViewItem 배열을 반환합니다.
    private func fetchGroupListViewItems() -> IdentifiedArrayOf<GroupListViewItem> {
        let domainGroupList = swiftDataRepository.fetchGroupList()
        let groupList = domainGroupList.map {
            let blockList = swiftDataRepository.fetchBlockList(groupId: $0.id)
            return GroupListViewItem(
                group: $0,
                blockCount: blockList.count)
        }
        return .init(uniqueElements: groupList)
    }
}
