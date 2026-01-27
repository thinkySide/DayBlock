//
//  BlockListFeature.swift
//  Management
//
//  Created by 김민준 on 1/26/26.
//

import Foundation
import ComposableArchitecture
import Domain
import PersistentData
import Util

@Reducer
public struct BlockListFeature {

    @ObservableState
    public struct State: Equatable {
        var sectionList: IdentifiedArrayOf<BlockListViewItem> = []

        // 드래그 상태
        var draggingBlock: BlockListViewItem.BlockViewItem?
        var draggingFromGroup: BlockGroup?
        var dropTargetGroupId: UUID?
        var dropTargetIndex: Int?

        public init() {}
    }

    public enum Action: TCAFeatureAction {
        public enum ViewAction {
            case onAppear
            case onTapBlockCell(BlockListViewItem.BlockViewItem, BlockGroup)
            case onTapAddBlockButton(BlockGroup)

            // 드래그 액션
            case onDragStarted(BlockListViewItem.BlockViewItem, BlockGroup)
            case onDragEnded
            case onDropTargetChanged(groupId: UUID?, index: Int?)
        }

        public enum InnerAction {
            case setSectionList(IdentifiedArrayOf<BlockListViewItem>)
        }

        public enum DelegateAction {
            case pushEditBlockEditor(Block, BlockGroup)
            case pushAddBlockEditor(BlockGroup)
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

                case .onTapBlockCell(let viewItem, let group):
                    // 드래그 중이면 탭 무시
                    guard state.draggingBlock == nil else { return .none }
                    return .send(.delegate(.pushEditBlockEditor(viewItem.block, group)))

                case .onTapAddBlockButton(let group):
                    return .send(.delegate(.pushAddBlockEditor(group)))

                case .onDragStarted(let block, let group):
                    state.draggingBlock = block
                    state.draggingFromGroup = group
                    return .none

                case .onDragEnded:
                    defer {
                        state.draggingBlock = nil
                        state.draggingFromGroup = nil
                        state.dropTargetGroupId = nil
                        state.dropTargetIndex = nil
                    }

                    guard let draggingBlock = state.draggingBlock,
                          let fromGroup = state.draggingFromGroup,
                          let targetGroupId = state.dropTargetGroupId,
                          let targetIndex = state.dropTargetIndex else {
                        return .none
                    }

                    // 로컬 상태 먼저 업데이트
                    moveBlock(
                        &state.sectionList,
                        block: draggingBlock,
                        fromGroupId: fromGroup.id,
                        toGroupId: targetGroupId,
                        toIndex: targetIndex
                    )

                    // DB 업데이트
                    return .run { [sectionList = state.sectionList] _ in
                        await updateBlockOrders(sectionList)
                    }

                case .onDropTargetChanged(let groupId, let index):
                    state.dropTargetGroupId = groupId
                    state.dropTargetIndex = index
                    return .none
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

// MARK: - Helper
extension BlockListFeature {

    /// 블럭을 다른 위치로 이동합니다.
    private func moveBlock(
        _ sectionList: inout IdentifiedArrayOf<BlockListViewItem>,
        block: BlockListViewItem.BlockViewItem,
        fromGroupId: UUID,
        toGroupId: UUID,
        toIndex: Int
    ) {
        // 원본 섹션에서 블럭 제거
        guard var fromSection = sectionList[id: fromGroupId] else { return }
        fromSection.blockList.removeAll { $0.id == block.id }
        sectionList[id: fromGroupId] = fromSection

        // 대상 섹션에 블럭 추가
        guard var toSection = sectionList[id: toGroupId] else { return }
        let clampedIndex = min(toIndex, toSection.blockList.count)
        toSection.blockList.insert(block, at: clampedIndex)
        sectionList[id: toGroupId] = toSection
    }

    /// DB에 블럭 순서를 업데이트합니다.
    private func updateBlockOrders(_ sectionList: IdentifiedArrayOf<BlockListViewItem>) async {
        for section in sectionList {
            for (index, blockViewItem) in section.blockList.enumerated() {
                await blockRepository.moveBlock(
                    blockViewItem.block.id,
                    section.group.id,
                    index
                )
            }
        }
    }
}
