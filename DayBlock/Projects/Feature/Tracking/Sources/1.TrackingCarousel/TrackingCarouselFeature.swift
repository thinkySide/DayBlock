//
//  TrackingCarouselFeature.swift
//  Tracking
//
//  Created by 김민준 on 12/21/25.
//

import SwiftUI
import ComposableArchitecture
import Domain
import Editor
import UserDefaults
import Util

@Reducer
public struct TrackingCarouselFeature {
    
    @Reducer
    public enum Path {
        case blockEditor(BlockEditorFeature)
    }

    @ObservableState
    public struct State: Equatable {
        var blockList: IdentifiedArrayOf<Block> = []
        var selectedGroup: BlockGroup = .init(id: .init(), name: "", colorIndex: 4)
        var focusedBlock: Block?
        var sheetDetent: PresentationDetent = .medium
        var currentDate: Date = .now

        var path = StackState<Path.State>()
        @Presents var groupSelect: GroupSelectFeature.State?

        public init() { }
    }

    public enum Action: TCAFeatureAction, BindableAction {
        public enum ViewAction {
            case onLoad
            case onTapGroupSelect
            case onTapAddBlock
            case scrollingCarousel(focusedBlock: Block?)
        }
        
        public enum InnerAction {
            case setSelectedGroup(BlockGroup)
            case setBlockList(IdentifiedArrayOf<Block>)
            case updateSheetDetent(PresentationDetent)
            case setCurrentDate(Date)
        }
        
        public enum DelegateAction {
            
        }
        
        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)
        case path(StackActionOf<Path>)
        case groupSelect(PresentationAction<GroupSelectFeature.Action>)
    }

    public init() {}
    
    @Dependency(\.date) private var date
    @Dependency(\.swiftDataRepository) private var swiftDataRepository
    @Dependency(\.userDefaultsService) private var userDefaultsService

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .onLoad:
                    return .concatenate(
                        fetchSelectedGroup(),
                        refreshBlockList(from: state.selectedGroup.id),
                        startDateUpdates()
                    )
                    
                case .onTapGroupSelect:
                    let selectedGroup = state.selectedGroup
                    state.groupSelect = .init(selectedGroup: selectedGroup)
                    return .none
                    
                case .onTapAddBlock:
                    let blockEditorState = BlockEditorFeature.State(
                        mode: .add,
                        selectedGroup: state.selectedGroup
                    )
                    state.path.append(.blockEditor(blockEditorState))
                    return .none
                    
                case .scrollingCarousel(let focusedBlock):
                    state.focusedBlock = focusedBlock
                    return .none
                }
                
            case .inner(let innerAction):
                switch innerAction {
                case .setSelectedGroup(let group):
                    state.selectedGroup = group
                    return .none

                case .setBlockList(let blockList):
                    state.blockList = blockList
                    return .none

                case .updateSheetDetent(let sheetDetent):
                    state.sheetDetent = sheetDetent
                    return .none

                case .setCurrentDate(let date):
                    state.currentDate = date
                    return .none
                }

            case .path(let stackAction):
                switch stackAction {
                case .element(id: _, action: .blockEditor(.delegate(.didPop))):
                    state.path.removeAll()
                    return .none
                    
                case let .element(id: _, action: .blockEditor(.delegate(.didConfirm(block, group)))):
                    state.path.removeAll()
                    state.focusedBlock = block
                    state.selectedGroup = group
                    return .concatenate(
                        refreshBlockList(from: state.selectedGroup.id)
                    )
                    
                default:
                    return .none
                }
                
            case .groupSelect(.presented(.delegate(.didSelectGroup(let group)))):
                state.selectedGroup = group
                state.groupSelect = nil
                state.sheetDetent = .medium
                userDefaultsService.set(\.selectedGroup, group)
                return refreshBlockList(from: group.id)
                
            case .groupSelect(.presented(.delegate(.didSelectAddGroup))):
                return updateSheetDetent(.large)
                
            case .groupSelect(.presented(.groupEditor(.presented(.delegate(.didPop))))):
                return updateSheetDetent(.medium)
                
            case .groupSelect(.presented(.groupEditor(.presented(.delegate(.didConfirm(let group)))))):
                state.selectedGroup = group
                return .merge(
                    updateSheetDetent(.medium),
                    refreshBlockList(from: group.id)
                )
                
            case .groupSelect(.dismiss):
                state.groupSelect = nil
                state.sheetDetent = .medium
                return .none
                
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        .ifLet(\.$groupSelect, action: \.groupSelect) {
            GroupSelectFeature()
        }
    }
}

// MARK: - Shared Effect
extension TrackingCarouselFeature {
    
    /// 기본 그룹을 반환합니다.
    private func fetchSelectedGroup() -> Effect<Action> {
        .run { send in
            if let selectedGroup = userDefaultsService.get(\.selectedGroup) {
                await send(.inner(.setSelectedGroup(selectedGroup)))
            } else {
                let defaultGroup = await swiftDataRepository.fetchDefaultGroup()
                await send(.inner(.setSelectedGroup(defaultGroup)))
            }
        }
    }
    
    /// 그룹 리스트를 리프레쉬 합니다.
    private func refreshBlockList(from groupId: UUID) -> Effect<Action> {
        .run { send in
            let blockList = await swiftDataRepository.fetchBlockList(groupId: groupId)
            await send(.inner(.setBlockList(.init(uniqueElements: blockList))))
        }
    }
    
    /// 자연스러운 애니메이션을 위해 딜레이 후 SheetDetent를 업데이트합니다.
    private func updateSheetDetent(_ sheetDetent: PresentationDetent) -> Effect<Action> {
        .run { send in
            try await Task.sleep(for: .seconds(0.4))
            await send(.inner(.updateSheetDetent(sheetDetent)))
        }
    }

    /// 현재 시간을 주기적으로 업데이트합니다.
    private func startDateUpdates() -> Effect<Action> {
        .run { send in
            while true {
                await send(.inner(.setCurrentDate(date.now)))
                try await Task.sleep(for: .seconds(1))
            }
        }
    }
}

// MARK: - Path
extension TrackingCarouselFeature.Path.State: Equatable {}
