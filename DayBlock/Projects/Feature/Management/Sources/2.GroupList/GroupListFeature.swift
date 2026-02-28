//
//  GroupListFeature.swift
//  ManagementDemoApp
//
//  Created by 김민준 on 1/26/26.
//

import Foundation
import ComposableArchitecture
import Domain
import Editor
import PersistentData
import UserDefaults
import Util

@Reducer
public struct GroupListFeature {

    @ObservableState
    public struct State: Equatable {
        var groupList: IdentifiedArrayOf<GroupListViewItem> = []

        public init() {}
    }

    public enum Action: TCAFeatureAction {
        public enum ViewAction {
            case onAppear
            case onTapGroupCell(GroupListViewItem)
            case onTapAddGroupButton
            case onMoveGroup(from: IndexSet, to: Int)
        }

        public enum InnerAction {
            case setGroupList(IdentifiedArrayOf<GroupListViewItem>)
            case refreshList
        }

        public enum DelegateAction {
            case pushEditGroupEditor(BlockGroup)
            case pushAddGroupEditor
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
    }
    
    @Dependency(\.groupRepository) private var groupRepository
    @Dependency(\.blockRepository) private var blockRepository
    @Dependency(\.userDefaultsService) private var userDefaultsService

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .onAppear:
                    return fetchGroupList()
                    
                case .onTapGroupCell(let viewItem):
                    return .send(.delegate(.pushEditGroupEditor(viewItem.group)))
                    
                case .onTapAddGroupButton:
                    return .send(.delegate(.pushAddGroupEditor))

                case .onMoveGroup(let from, let to):
                    state.groupList.move(fromOffsets: from, toOffset: to)
                    return .run { [groupList = state.groupList] _ in
                        await updateGroupOrders(groupList)
                    }
                }

            case .inner(let innerAction):
                switch innerAction {
                case .setGroupList(let groupList):
                    state.groupList = groupList
                    return .none

                case .refreshList:
                    return fetchGroupList()
                }

            default:
                return .none
            }
        }
    }
}

// MARK: - Shared Effect
extension GroupListFeature {

    /// 전체 그룹 리스트를 가져옵니다.
    private func fetchGroupList() -> Effect<Action> {
        .run { send in
            let groupList = await groupRepository.fetchGroupList()
            let defaultGroupId = userDefaultsService.get(\.defaultGroupId)
            var viewItems: [GroupListViewItem] = []

            for group in groupList {
                let blockList = await blockRepository.fetchBlockList(groupId: group.id)
                let viewItem = GroupListViewItem(
                    group: group,
                    blockCount: blockList.count,
                    isDefault: group.id == defaultGroupId
                )
                viewItems.append(viewItem)
            }

            await send(.inner(.setGroupList(.init(uniqueElements: viewItems))))
        }
    }
}

// MARK: - Helper
extension GroupListFeature {

    /// DB에 그룹 순서를 업데이트합니다.
    private func updateGroupOrders(_ groupList: IdentifiedArrayOf<GroupListViewItem>) async {
        for (index, viewItem) in groupList.enumerated() {
            let updatedGroup = BlockGroup(
                id: viewItem.group.id,
                name: viewItem.group.name,
                order: index
            )
            _ = try? await groupRepository.updateGroup(viewItem.group.id, updatedGroup)
        }
    }
}
