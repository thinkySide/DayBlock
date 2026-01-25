//
//  BlockCarouselFeature.swift
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
public struct BlockCarouselFeature {

    @Reducer
    public enum Path {
        case blockEditor(BlockEditorFeature)
    }
    
    public enum FocusedBlock: Hashable, Equatable {
        case block(id: UUID)
        case addBlock
    }

    @ObservableState
    public struct State: Equatable {
        var isFirstAppear: Bool = true
        var blockList: IdentifiedArrayOf<Block> = []
        var selectedGroup: BlockGroup = .init(id: .init(), name: "", order: 0)
        var selectedBlock: Block?
        var focusedBlock: FocusedBlock?
        var previousFocusedBlock: FocusedBlock?
        var sheetDetent: PresentationDetent = .medium
        var currentDate: Date = .now
        var shouldTriggerFocusHaptic: Bool = true
        var isPopupPresented: Bool = false
        var deletedBlockIndex: Int?

        public var path = StackState<Path.State>()
        var trackingInProgress: TrackingInProgressFeature.State?
        @Presents var groupSelect: GroupSelectFeature.State?

        public init() { }
    }

    public enum Action: TCAFeatureAction, BindableAction {
        public enum ViewAction {
            case onLoad
            case onAppear
            case onDisappear
            case onTapGroupSelect
            case onTapBlock(Block)
            case onTapBlockDeleteButton
            case onTapBlockEditButton(Block)
            case onTapAddBlock
            case onTapTrackingButton
        }
        
        public enum InnerAction {
            case setSelectedGroup(BlockGroup)
            case setBlockList(IdentifiedArrayOf<Block>)
            case setCurrentDate(Date)
            case setFocusedBlock(FocusedBlock?)
            case completeDeleteBlock
            case updateSheetDetent(PresentationDetent)
            case restoreTrackingSession(TrackingSessionState)
        }
        
        public enum DelegateAction {
            
        }
        
        public enum PopupAction {
            case cancel
            case deleteBlock
        }
        
        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case popup(PopupAction)
        case binding(BindingAction<State>)
        case path(StackActionOf<Path>)
        case groupSelect(PresentationAction<GroupSelectFeature.Action>)
        case trackingInProgress(TrackingInProgressFeature.Action)
    }
    
    @CasePathable
    enum CancelID {
        case dateClock
        case updateSheetDetent
    }

    public init() {}

    @Dependency(\.date) private var date
    @Dependency(\.continuousClock) private var clock
    @Dependency(\.haptic) private var haptic
    @Dependency(\.groupRepository) private var groupRepository
    @Dependency(\.blockRepository) private var blockRepository
    @Dependency(\.userDefaultsService) private var userDefaultsService

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .onLoad:
                    return .merge(
                        startDateClock(),
                        fetchSelectedGroup()
                    )
                    
                case .onAppear:
                    return .none
                    
                case .onDisappear:
                    return .none
                    
                case .onTapGroupSelect:
                    let selectedGroup = state.selectedGroup
                    state.groupSelect = .init(selectedGroup: selectedGroup)
                    return .cancel(id: CancelID.dateClock)
                    
                case .onTapBlock(let block):
                    if state.selectedBlock == nil {
                        state.selectedBlock = block
                    } else {
                        state.selectedBlock = nil
                    }
                    return .none
                    
                case .onTapBlockDeleteButton:
                    state.isPopupPresented = true
                    haptic.notification(.warning)
                    return .none

                case .onTapBlockEditButton(let block):
                    let blockEditorState = BlockEditorFeature.State(
                        mode: .edit(selectedBlock: block),
                        selectedGroup: state.selectedGroup
                    )
                    state.path.append(.blockEditor(blockEditorState))
                    state.selectedBlock = nil
                    return .none
                    
                case .onTapAddBlock:
                    let blockEditorState = BlockEditorFeature.State(
                        mode: .add,
                        selectedGroup: state.selectedGroup
                    )
                    state.path.append(.blockEditor(blockEditorState))
                    return .none
                    
                case .onTapTrackingButton:
                    let block: Block?
                    
                    switch state.focusedBlock {
                    case .block(let id):
                        block = state.blockList.first(where: { $0.id == id })
                        userDefaultsService.set(\.selectedBlockId, id)
                    default:
                        block = nil
                    }
                    
                    guard let block else { return .none }
                    haptic.impact(.light)
                    state.trackingInProgress = .init(
                        trackingGroup: state.selectedGroup,
                        trackingBlock: block
                    )
                    return .none
                }
                
            case .inner(let innerAction):
                switch innerAction {
                case .setSelectedGroup(let group):
                    state.selectedGroup = group
                    return refreshBlockList(from: group.id)

                case .setBlockList(let blockList):
                    state.blockList = blockList
                    state.shouldTriggerFocusHaptic = false

                    if let deletedIndex = state.deletedBlockIndex {
                        state.deletedBlockIndex = nil

                        if deletedIndex > 0 {
                            let previousBlock = blockList[deletedIndex - 1]
                            state.focusedBlock = .block(id: previousBlock.id)
                        } else if !blockList.isEmpty {
                            state.focusedBlock = .block(id: blockList[0].id)
                        } else {
                            state.focusedBlock = nil
                        }

                        state.selectedBlock = nil
                        return .none
                    }

                    if state.isFirstAppear {
                        state.isFirstAppear = false
                        
                        if let selectedBlockId = userDefaultsService.get(\.selectedBlockId) {
                            state.focusedBlock = .block(id: selectedBlockId)
                        } else {
                            state.focusedBlock = nil
                        }

                        if let trackingSession = userDefaultsService.get(\.trackingSession) {
                            return .merge(
                                setFocusedBlock(state),
                                .send(.inner(.restoreTrackingSession(trackingSession)))
                            )
                        }
                    }
                    return setFocusedBlock(state)

                case .setCurrentDate(let date):
                    state.currentDate = date
                    return .none
                    
                case .setFocusedBlock(let focusedBlock):
                    state.shouldTriggerFocusHaptic = false
                    state.focusedBlock = focusedBlock
                    return .none
                    
                case .completeDeleteBlock:
                    state.isPopupPresented = false
                    userDefaultsService.remove(\.selectedBlockId)
                    return refreshBlockList(from: state.selectedGroup.id)
                    
                case .updateSheetDetent(let sheetDetent):
                    state.sheetDetent = sheetDetent
                    return .none

                case .restoreTrackingSession(let trackingSession):
                    guard trackingSession.trackingGroupId == state.selectedGroup.id,
                          let block = state.blockList.first(where: { $0.id == trackingSession.trackingBlockId })
                    else {
                        userDefaultsService.remove(\.trackingSession)
                        return .none
                    }

                    state.trackingInProgress = .init(
                        trackingGroup: state.selectedGroup,
                        trackingBlock: block,
                        trackingSession: trackingSession
                    )
                    return .none
                }
                
            case .popup(let popupAction):
                switch popupAction {
                case .cancel:
                    state.isPopupPresented = false
                    return .none

                case .deleteBlock:
                    guard let selectedBlock = state.selectedBlock else { return .none }
                    let blockId = selectedBlock.id

                    if let index = state.blockList.firstIndex(where: { $0.id == blockId }) {
                        state.deletedBlockIndex = index
                    }

                    return .run { send in
                        await blockRepository.deleteBlock(blockId: blockId)
                        await send(.inner(.completeDeleteBlock))
                    }
                }
                
            case .binding(\.focusedBlock):
                state.selectedBlock = nil

                if state.shouldTriggerFocusHaptic
                    && state.previousFocusedBlock != state.focusedBlock {
                    haptic.impact(.soft)
                }

                state.previousFocusedBlock = state.focusedBlock
                state.shouldTriggerFocusHaptic = true

                return .none

            case .path(let stackAction):
                switch stackAction {
                case .element(id: _, action: .blockEditor(.delegate(.didPop))):
                    state.path.removeAll()
                    return .none
                    
                case let .element(id: _, action: .blockEditor(.delegate(.didConfirm(block, group)))):
                    state.path.removeAll()
                    state.shouldTriggerFocusHaptic = false
                    state.focusedBlock = nil
                    state.selectedGroup = group
                    userDefaultsService.set(\.selectedBlockId, block.id)
                    userDefaultsService.set(\.selectedGroupId, group.id)
                    return refreshBlockList(from: state.selectedGroup.id)
                    
                default:
                    return .none
                }
                
            case .groupSelect(.presented(.delegate(.didSelectGroup(let group)))):
                state.selectedGroup = group
                state.groupSelect = nil
                state.sheetDetent = .medium

                if let firstBlockId = state.blockList.first?.id {
                    state.shouldTriggerFocusHaptic = false
                    state.focusedBlock = .block(id: firstBlockId)
                }

                userDefaultsService.set(\.selectedGroupId, group.id)

                return .merge(
                    .cancel(id: CancelID.updateSheetDetent),
                    refreshBlockList(from: group.id)
                )
                
            case .groupSelect(.presented(.delegate(.didSelectAddGroup))):
                state.sheetDetent = .medium
                return updateSheetDetent(.large)
                
            case .groupSelect(.presented(.groupEditor(.presented(.delegate(.didPop))))):
                return updateSheetDetent(.medium)
                
            case .groupSelect(.presented(.groupEditor(.presented(.delegate(.didConfirm(let group)))))):
                state.selectedGroup = group
                userDefaultsService.set(\.selectedGroupId, group.id)
                return .merge(
                    updateSheetDetent(.medium),
                    refreshBlockList(from: group.id)
                )
                
            case .groupSelect(.dismiss):
                state.sheetDetent = .medium
                return .concatenate(
                    .cancel(id: CancelID.updateSheetDetent),
                    startDateClock()
                )
                
            case .trackingInProgress(.delegate(.didDismiss)):
                state.trackingInProgress = nil
                return .none
                
            case .trackingInProgress(.delegate(.didFinish)):
                state.trackingInProgress = nil
                return .none
                
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        .ifLet(\.$groupSelect, action: \.groupSelect) {
            GroupSelectFeature()
        }
        .ifLet(\.trackingInProgress, action: \.trackingInProgress) {
            TrackingInProgressFeature()
        }
    }
}

// MARK: - Shared Effect
extension BlockCarouselFeature {
    
    /// 기본 그룹을 반환합니다.
    private func fetchSelectedGroup() -> Effect<Action> {
        .run { send in
            if let selectedGroupId = userDefaultsService.get(\.selectedGroupId) {
                let groupList = await groupRepository.fetchGroupList()
                if let selectedGroup = groupList.matchGroup(from: selectedGroupId) {
                    await send(.inner(.setSelectedGroup(selectedGroup)))
                }
            } else {
                let defaultGroup = await groupRepository.fetchDefaultGroup()
                await send(.inner(.setSelectedGroup(defaultGroup)))
            }
        }
    }
    
    /// 블럭 리스트를 리프레쉬 합니다.
    private func refreshBlockList(from groupId: UUID) -> Effect<Action> {
        .run { send in
            let blockList = await blockRepository.fetchBlockList(groupId: groupId)
            await send(.inner(.setBlockList(.init(uniqueElements: blockList))))
        }
    }

    /// 포커스 블럭을 설정합니다.
    private func setFocusedBlock(_ state: State) -> Effect<Action> {
        .run { send in
            switch state.focusedBlock {
            case .block(let id):
                if state.blockList.contains(where: { $0.id == id }) {
                    await send(.inner(.setFocusedBlock(.block(id: id))))
                } else if let firstId = state.blockList.first?.id {
                    await send(.inner(.setFocusedBlock(.block(id: firstId))))
                } else {
                    await send(.inner(.setFocusedBlock(nil)))
                }
            default:
                if let selectedBlockId = userDefaultsService.get(\.selectedBlockId) {
                    await send(.inner(.setFocusedBlock(.block(id: selectedBlockId))))
                } else {
                    if let firstId = state.blockList.first?.id {
                        await send(.inner(.setFocusedBlock(.block(id: firstId))))
                    } else {
                        await send(.inner(.setFocusedBlock(nil)))
                    }
                }
            }
        }
    }

    /// 자연스러운 애니메이션을 위해 딜레이 후 SheetDetent를 업데이트합니다.
    private func updateSheetDetent(_ sheetDetent: PresentationDetent) -> Effect<Action> {
        .run { send in
            try await clock.sleep(for: .seconds(0.4))
            await send(.inner(.updateSheetDetent(sheetDetent)))
        }
        .cancellable(id: CancelID.updateSheetDetent, cancelInFlight: true)
    }

    /// 현재 시간을 주기적으로 업데이트합니다.
    private func startDateClock() -> Effect<Action> {
        .run { send in
            for await _ in self.clock.timer(interval: .seconds(1)) {
                await send(.inner(.setCurrentDate(date.now)))
            }
        }
        .cancellable(id: CancelID.dateClock, cancelInFlight: true)
    }
}

// MARK: - Path
extension BlockCarouselFeature.Path.State: Equatable {}
