//
//  BlockEditorFeature.swift
//  Editor
//
//  Created by 김민준 on 12/21/25.
//

import Foundation
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

        @Presents var groupSelect: GroupSelectFeature.State?
        @Presents var iconSelect: IconSelectFeature.State?

        public init(
            mode: Mode
        ) {
            self.mode = mode
            switch mode {
            case .add:
                initialBlock = Block.defaultValue
                editingBlock = Block.defaultValue
                nameText = ""
                selectedGroup = BlockGroup.defaultValue
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

            case .iconSelect(.presented(.delegate(.didSelectIcon(let iconIndex)))):
                state.editingBlock.iconIndex = iconIndex
                state.iconSelect = nil
                return .none
                
            case .groupSelect(.presented(.delegate(.didSelectGroup(let group)))):
                state.selectedGroup = group
                state.groupSelect = nil
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
