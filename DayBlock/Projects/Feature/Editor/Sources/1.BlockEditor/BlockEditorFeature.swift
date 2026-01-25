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
import UserDefaults

@Reducer
public struct BlockEditorFeature {
    
    public enum Mode: Equatable {
        case add
        case edit(selectedBlock: Block)
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
        @Presents var colorSelect: ColorSelectFeature.State?

        public init(
            mode: Mode,
            selectedGroup: BlockGroup
        ) {
            @Dependency(\.uuid) var uuid
            self.mode = mode
            self.selectedGroup = selectedGroup
            let defaultBlock = Block(
                id: uuid(),
                name: "블럭 쌓기",
                iconIndex: 0,
                colorIndex: 4,
                output: 0,
                order: 0
            )
            switch mode {
            case .add:
                initialBlock = defaultBlock
                editingBlock = defaultBlock
                nameText = ""

            case .edit(let selectedBlock):
                initialBlock = selectedBlock
                editingBlock = selectedBlock
                nameText = selectedBlock.name
            }
        }
    }

    public enum Action: TCAFeatureAction, BindableAction {
        public enum ViewAction {
            case typeNameText(String)
            case onAppear
            case onTapBackButton
            case onTapConfirmButton
            case onTapGroupSelection
            case onTapIconSelection
            case onTapColorSelection
        }

        public enum InnerAction {
            case setDefaultGroup(BlockGroup)
            case updateSheetDetent(PresentationDetent)
        }

        public enum DelegateAction {
            case didPop
            case didConfirm(Block, BlockGroup)
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)
        case groupSelect(PresentationAction<GroupSelectFeature.Action>)
        case iconSelect(PresentationAction<IconSelectFeature.Action>)
        case colorSelect(PresentationAction<ColorSelectFeature.Action>)
    }

    public init() {}
    
    @Dependency(\.blockRepository) private var blockRepository

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .onAppear:
                    return .none
                    
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
                    
                case .onTapColorSelection:
                    let colorIndex = state.editingBlock.colorIndex
                    state.colorSelect = .init(selectedColorIndex: colorIndex)
                    return .none

                case .onTapConfirmButton:
                    let targetGroup = state.selectedGroup
                    let targetBlock = state.editingBlock
                    return .run { [state] send in
                        let savedBlock: Block
                        switch state.mode {
                        case .add:
                            savedBlock = try await blockRepository.createBlock(
                                targetGroup.id,
                                targetBlock
                            )
                        case .edit:
                            savedBlock = try await blockRepository.updateBlock(
                                targetBlock.id,
                                targetGroup.id,
                                targetBlock
                            )
                        }
                        await send(.delegate(.didConfirm(savedBlock, targetGroup)))
                    }
                }
                
            case .inner(let innerAction):
                switch innerAction {
                case .setDefaultGroup(let group):
                    state.selectedGroup = group
                    return .none
                    
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
                state.sheetDetent = .medium
                return updateSheetDetent(.large)
                
            case .groupSelect(.presented(.groupEditor(.presented(.delegate(.didPop))))):
                return updateSheetDetent(.medium)
                
            case .groupSelect(.presented(.groupEditor(.presented(.delegate(.didConfirm(let group)))))):
                state.selectedGroup = group
                return updateSheetDetent(.medium)

            case .groupSelect(.dismiss):
                state.groupSelect = nil
                state.sheetDetent = .medium
                return .none

            case .iconSelect(.dismiss):
                state.iconSelect = nil
                state.sheetDetent = .medium
                return .none
                
            case .colorSelect(.presented(.delegate(.didSelectColor(let selectedIndex)))):
                state.editingBlock.colorIndex = selectedIndex
                state.colorSelect = nil
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
        .ifLet(\.$colorSelect, action: \.colorSelect) {
            ColorSelectFeature()
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
