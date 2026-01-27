//
//  BlockListFeature.swift
//  Management
//
//  Created by 김민준 on 1/26/26.
//

import ComposableArchitecture
import Domain
import PersistentData
import Util

@Reducer
public struct BlockListFeature {

    @ObservableState
    public struct State: Equatable {
        var sectionList: IdentifiedArrayOf<BlockListViewItem> = []

        public init() {}
    }

    public enum Action: TCAFeatureAction {
        public enum ViewAction {
            case onAppear
        }

        public enum InnerAction {
            case setSectionList(IdentifiedArrayOf<BlockListViewItem>)
        }

        public enum DelegateAction {

        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
    }

    public init() {}

    @Dependency(\.groupRepository) private var groupRepository
    @Dependency(\.blockRepository) private var blockRepository

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .onAppear:
                    return fetchSectionList()
                }

            case .inner(let innerAction):
                switch innerAction {
                case .setSectionList(let sectionList):
                    state.sectionList = sectionList
                    return .none
                }

            default:
                return .none
            }
        }
    }
}

// MARK: - Shared Effect
extension BlockListFeature {

    /// 전체 블럭 섹션 리스트를 가져옵니다.
    private func fetchSectionList() -> Effect<Action> {
        .run { send in
            let groupList = await groupRepository.fetchGroupList()
            var sectionList: [BlockListViewItem] = []

            for group in groupList {
                let blockList = await blockRepository.fetchBlockList(groupId: group.id)
                let blockViewItems = blockList.map { block in
                    BlockListViewItem.BlockViewItem(
                        block: block,
                        total: 0 // TODO: 트래킹 총 시간 계산
                    )
                }
                let section = BlockListViewItem(
                    group: group,
                    blockList: blockViewItems
                )
                sectionList.append(section)
            }

            await send(.inner(.setSectionList(.init(uniqueElements: sectionList))))
        }
    }
}
