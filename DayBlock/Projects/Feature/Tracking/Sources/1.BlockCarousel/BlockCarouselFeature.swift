//
//  BlockCarouselFeature.swift
//  Tracking
//
//  Created by 김민준 on 12/21/25.
//

import Foundation
import ComposableArchitecture
import Domain
import Editor
import PersistentData
import UserDefaults
import Util

@Reducer
public struct BlockCarouselFeature {

    public enum FocusedBlock: Hashable, Equatable {
        case block(id: UUID)
        case addBlock
    }

    /// 트래킹 시간과 색상 정보를 함께 저장하는 구조체
    public struct TrackingTimeEntry: Equatable {
        public let time: TrackingTime
        public let colorIndex: Int
        public let sessionId: UUID
    }

    /// 블럭별 생산량 정보
    public struct BlockOutput: Equatable {
        public let total: Double
        public let today: Double
    }

    @ObservableState
    public struct State: Equatable {
        var isFirstAppear: Bool = true
        var blockList: IdentifiedArrayOf<Block> = []
        var selectedGroup: BlockGroup = .init(id: .init(), name: "", order: 0)
        var selectedBlock: Block?
        var focusedBlock: FocusedBlock?
        var previousFocusedBlock: FocusedBlock?
        var currentDate: Date = .now
        var shouldTriggerFocusHaptic: Bool = true
        var isPopupPresented: Bool = false
        var deletedBlockIndex: Int?
        var todayTrackingEntries: [TrackingTimeEntry] = []
        var blockOutputs: [UUID: BlockOutput] = [:]
        var todayTotalOutput: Double = 0

        @Presents var blockEditor: BlockEditorFeature.State?
        @Presents var trackingInProgress: TrackingInProgressFeature.State?
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
            case onTapHelpButton
        }
        
        public enum InnerAction {
            case setSelectedGroup(BlockGroup)
            case setBlockList(IdentifiedArrayOf<Block>)
            case setCurrentDate(Date)
            case setFocusedBlock(FocusedBlock?)
            case setTodayTrackingEntries([TrackingTimeEntry])
            case setBlockOutputs([UUID: BlockOutput])
            case setTodayTotalOutput(Double)
            case completeDeleteBlock
            case restoreTrackingSession(TrackingSessionState)
            case refreshData
        }
        
        public enum DelegateAction {
            case didStart
            case didFinish
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
        case blockEditor(PresentationAction<BlockEditorFeature.Action>)
        case groupSelect(PresentationAction<GroupSelectFeature.Action>)
        case trackingInProgress(PresentationAction<TrackingInProgressFeature.Action>)
    }
    
    @CasePathable
    enum CancelID {
        case dateClock
    }

    public init() {}

    @Dependency(\.date) private var date
    @Dependency(\.calendar) private var calendar
    @Dependency(\.continuousClock) private var clock
    @Dependency(\.haptic) private var haptic
    @Dependency(\.groupRepository) private var groupRepository
    @Dependency(\.blockRepository) private var blockRepository
    @Dependency(\.trackingRepository) private var trackingRepository
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
                    state.blockEditor = BlockEditorFeature.State(
                        mode: .edit(selectedBlock: block),
                        selectedGroup: state.selectedGroup
                    )
                    state.selectedBlock = nil
                    return .none

                case .onTapAddBlock:
                    state.blockEditor = BlockEditorFeature.State(
                        mode: .add,
                        selectedGroup: state.selectedGroup
                    )
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
                    return .send(.delegate(.didStart))

                case .onTapHelpButton:
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

                case .setTodayTrackingEntries(let entries):
                    state.todayTrackingEntries = entries
                    return .none

                case .setBlockOutputs(let outputs):
                    state.blockOutputs = outputs
                    return .none

                case .setTodayTotalOutput(let output):
                    state.todayTotalOutput = output
                    return .none

                case .setFocusedBlock(let focusedBlock):
                    state.shouldTriggerFocusHaptic = false
                    state.focusedBlock = focusedBlock
                    return .none
                    
                case .completeDeleteBlock:
                    state.isPopupPresented = false
                    userDefaultsService.remove(\.selectedBlockId)
                    return refreshBlockList(from: state.selectedGroup.id)
                    
                case .refreshData:
                    state.shouldTriggerFocusHaptic = false
                    state.focusedBlock = nil
                    state.selectedBlock = nil
                    return fetchSelectedGroup()

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

            case .blockEditor(.presented(.delegate(.didPop))):
                state.blockEditor = nil
                return .none

            case let .blockEditor(.presented(.delegate(.didConfirm(block, group)))):
                state.blockEditor = nil
                state.shouldTriggerFocusHaptic = false
                state.focusedBlock = nil
                state.selectedGroup = group
                userDefaultsService.set(\.selectedBlockId, block.id)
                userDefaultsService.set(\.selectedGroupId, group.id)
                return refreshBlockList(from: state.selectedGroup.id)

            case .blockEditor(.presented(.delegate(.didDelete))):
                state.blockEditor = nil
                state.shouldTriggerFocusHaptic = false
                userDefaultsService.remove(\.selectedBlockId)
                return refreshBlockList(from: state.selectedGroup.id)
                
            case .groupSelect(.presented(.delegate(.didSelectGroup(let group)))):
                state.selectedGroup = group
                state.groupSelect = nil

                if let firstBlockId = state.blockList.first?.id {
                    state.shouldTriggerFocusHaptic = false
                    state.focusedBlock = .block(id: firstBlockId)
                }

                userDefaultsService.set(\.selectedGroupId, group.id)
                return refreshBlockList(from: group.id)

            case .groupSelect(.presented(.groupEditor(.presented(.delegate(.didConfirm(let group)))))):
                state.selectedGroup = group
                userDefaultsService.set(\.selectedGroupId, group.id)
                return refreshBlockList(from: group.id)

            case .groupSelect(.dismiss):
                return startDateClock()
                
            case .trackingInProgress(.presented(.delegate(.didDismiss))):
                state.trackingInProgress = nil
                return .send(.delegate(.didFinish))

            case .trackingInProgress(.presented(.delegate(.didFinish))):
                state.trackingInProgress = nil
                return .merge(
                    refreshBlockList(from: state.selectedGroup.id),
                    .send(.delegate(.didFinish))
                )
                
            default:
                return .none
            }
        }
        .ifLet(\.$blockEditor, action: \.blockEditor) {
            BlockEditorFeature()
        }
        .ifLet(\.$groupSelect, action: \.groupSelect) {
            GroupSelectFeature()
        }
        .ifLet(\.$trackingInProgress, action: \.trackingInProgress) {
            TrackingInProgressFeature()
        }
    }
}

// MARK: - Shared Effect
extension BlockCarouselFeature {
    
    /// 기본 그룹을 반환합니다.
    private func fetchSelectedGroup() -> Effect<Action> {
        .run { send in
            if userDefaultsService.get(\.defaultGroupId) == nil {
                let defaultGroup = await groupRepository.fetchDefaultGroup()
                userDefaultsService.set(\.defaultGroupId, defaultGroup.id)
            }

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

            let today = date.now
            var todayEntries: [TrackingTimeEntry] = []
            var outputs: [UUID: BlockOutput] = [:]

            for block in blockList {
                let sessions = await trackingRepository.fetchSessions(block.id)
                var totalCount = 0
                var todayCount = 0

                for session in sessions {
                    totalCount += session.timeList.count
                    let todayTimes = session.timeList.filter { time in
                        calendar.isDate(time.startDate, inSameDayAs: today)
                    }
                    todayCount += todayTimes.count
                    let entries = todayTimes.map {
                        TrackingTimeEntry(time: $0, colorIndex: block.colorIndex, sessionId: session.id)
                    }
                    todayEntries.append(contentsOf: entries)
                }

                outputs[block.id] = BlockOutput(
                    total: Double(totalCount) * 0.5,
                    today: Double(todayCount) * 0.5
                )
            }

            await send(.inner(.setTodayTrackingEntries(todayEntries)))
            await send(.inner(.setBlockOutputs(outputs)))

            // 모든 그룹/블럭의 오늘 총 생산량 계산
            let allGroups = await groupRepository.fetchGroupList()
            var totalTodayCount = 0
            for group in allGroups {
                let groupBlocks = await blockRepository.fetchBlockList(groupId: group.id)
                for block in groupBlocks {
                    let sessions = await trackingRepository.fetchSessions(block.id)
                    for session in sessions {
                        totalTodayCount += session.timeList.filter { time in
                            calendar.isDate(time.startDate, inSameDayAs: today)
                        }.count
                    }
                }
            }
            await send(.inner(.setTodayTotalOutput(Double(totalTodayCount) * 0.5)))
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
