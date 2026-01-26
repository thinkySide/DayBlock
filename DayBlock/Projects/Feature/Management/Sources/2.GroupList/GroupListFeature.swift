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

        public init() {}
    }

    public enum Action: TCAFeatureAction {
        public enum ViewAction {
            case onAppear
            case onTapAddGroupButton
        }

        public enum InnerAction {
            case setGroupList(IdentifiedArrayOf<GroupListViewItem>)
        }

        public enum DelegateAction {
            case pushGroupEditor
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
                    
                case .onTapAddGroupButton:
                    return .send(.delegate(.pushGroupEditor))
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
                    id: group.id,
                    name: group.name,
                    blockCount: blockList.count,
                    isDefault: group.id == defaultGroupId
                )
                viewItems.append(viewItem)
            }

            await send(.inner(.setGroupList(.init(uniqueElements: viewItems))))
        }
    }
}
