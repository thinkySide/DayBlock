//
//  GroupListFeature.swift
//  ManagementDemoApp
//
//  Created by 김민준 on 1/26/26.
//

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

        // 드래그 상태
        var draggingGroup: GroupListViewItem?
        var dropTargetIndex: Int?

        public init() {}
    }

    public enum Action: TCAFeatureAction {
        public enum ViewAction {
            case onAppear
            case onTapGroupCell(GroupListViewItem)
            case onTapAddGroupButton

            // 드래그 액션
            case onDragStarted(GroupListViewItem)
            case onDragEnded
            case onDropTargetChanged(index: Int?)
        }

        public enum InnerAction {
            case setGroupList(IdentifiedArrayOf<GroupListViewItem>)
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

                case .onDragStarted(let group):
                    state.draggingGroup = group
                    return .none

                case .onDragEnded:
                    defer {
                        state.draggingGroup = nil
                        state.dropTargetIndex = nil
                    }

                    guard let draggingGroup = state.draggingGroup,
                          let targetIndex = state.dropTargetIndex else {
                        return .none
                    }

                    // 로컬 상태 먼저 업데이트
                    moveGroup(&state.groupList, group: draggingGroup, toIndex: targetIndex)

                    // DB 업데이트
                    return .run { [groupList = state.groupList] _ in
                        await updateGroupOrders(groupList)
                    }

                case .onDropTargetChanged(let index):
                    state.dropTargetIndex = index
                    return .none
                }

            case .inner(let innerAction):
                switch innerAction {
                case .setGroupList(let groupList):
                    state.groupList = groupList
                    return .none
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

    /// 그룹을 다른 위치로 이동합니다.
    private func moveGroup(
        _ groupList: inout IdentifiedArrayOf<GroupListViewItem>,
        group: GroupListViewItem,
        toIndex: Int
    ) {
        guard let currentIndex = groupList.firstIndex(where: { $0.id == group.id }) else { return }

        // 같은 위치면 무시
        guard currentIndex != toIndex else { return }

        // 이동
        groupList.remove(at: currentIndex)
        let clampedIndex = min(toIndex, groupList.count)
        groupList.insert(group, at: clampedIndex)
    }

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
