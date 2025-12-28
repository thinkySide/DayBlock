//
//  BlockEditorFeature.swift
//  Editor
//
//  Created by 김민준 on 12/21/25.
//

import SwiftUI
import ComposableArchitecture
import Domain
import Util

@Reducer
public struct BlockEditorFeature {
    
    public enum Mode: Equatable {
        case add
        case edit(selectedBlock: Block, selectedBlockGroup: BlockGroup)
    }

    @ObservableState
    public struct State: Equatable {
        let nameTextLimit: Int = 16
        let initialBlock: Block

        var mode: Mode
        var editingBlock: Block
        var nameText: String
        var selectedGroup: BlockGroup
        var sheetDetent: PresentationDetent = .medium

        @Presents var groupSelect: GroupSelectFeature.State?
        @Presents var iconSelect: IconSelectFeature.State?

        public init(
            mode: Mode
        ) {
            @Dependency(\.uuid) var uuid
            @Dependency(\.swiftDataRepository) var swiftDataRepository
            self.mode = mode
            let defaultBlock = Block(
                id: uuid(),
                name: "블럭 쌓기",
                iconIndex: 0,
                output: 0
            )
            switch mode {
            case .add:
                initialBlock = defaultBlock
                editingBlock = defaultBlock
                nameText = ""
                selectedGroup = swiftDataRepository.fetchDefaultGroup()
            case .edit(let selectedBlock, let blockGroup):
                initialBlock = selectedBlock
                editingBlock = selectedBlock
                nameText = selectedBlock.name
                selectedGroup = blockGroup
            }
        }
    }

    public enum Action: TCAFeatureAction, BindableAction {
        public enum ViewAction {
            case typeNameText(String)
            case onTapBackButton
            case onTapConfirmButton
            case onTapGroupSelection
            case onTapIconSelection
        }

        public enum InnerAction {
            case updateSheetDetent(PresentationDetent)
        }

        public enum DelegateAction {
            case didPop
            case didConfirm(Block)
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)
        case groupSelect(PresentationAction<GroupSelectFeature.Action>)
        case iconSelect(PresentationAction<IconSelectFeature.Action>)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .onTapBackButton:
                    return .send(.delegate(.didPop))
                    
                case .typeNameText(let text):
                    state.nameText = text.slice(to: state.nameTextLimit)
                    state.editingBlock.name = state.nameText
                    return .none

                case .onTapGroupSelection:
                    let selectedGroup = state.selectedGroup
                    state.groupSelect = .init(selectedGroup: selectedGroup)
                    return .none

                case .onTapIconSelection:
                    let selectedIconIndex = state.editingBlock.iconIndex
                    state.iconSelect = .init(selectedIconIndex: selectedIconIndex)
                    return .none

                case .onTapConfirmButton:
                    return .send(.delegate(.didConfirm(state.editingBlock)))
                }
                
            case .inner(let innerAction):
                switch innerAction {
                case .updateSheetDetent(let sheetDetent):
                    state.sheetDetent = sheetDetent
                    return .none
                }

            case .iconSelect(.presented(.delegate(.didSelectIcon(let iconIndex)))):
                state.editingBlock.iconIndex = iconIndex
                state.iconSelect = nil
                state.sheetDetent = .medium
                return .none
                
            case .groupSelect(.presented(.delegate(.didSelectGroup(let group)))):
                state.selectedGroup = group
                state.groupSelect = nil
                state.sheetDetent = .medium
                return .none
                
            case .groupSelect(.presented(.delegate(.didSelectAddGroup))):
                return updateSheetDetent(.large)
                
            case .groupSelect(.presented(.groupEditor(.presented(.delegate(.didPop))))):
                return updateSheetDetent(.medium)

            case .groupSelect(.dismiss):
                state.groupSelect = nil
                state.sheetDetent = .medium
                return .none

            case .iconSelect(.dismiss):
                state.iconSelect = nil
                state.sheetDetent = .medium
                return .none

            default:
                return .none
            }
        }
        .ifLet(\.$groupSelect, action: \.groupSelect) {
            GroupSelectFeature()
        }
        .ifLet(\.$iconSelect, action: \.iconSelect) {
            IconSelectFeature()
        }
    }
}

// MARK: - Shared Effect
extension BlockEditorFeature {
    
    /// 자연스러운 애니메이션을 위해 딜레이 후 SheetDetent를 업데이트합니다.
    private func updateSheetDetent(_ sheetDetent: PresentationDetent) -> Effect<Action> {
        .run { send in
            try await Task.sleep(for: .seconds(0.4))
            await send(.inner(.updateSheetDetent(sheetDetent)))
        }
    }
}
