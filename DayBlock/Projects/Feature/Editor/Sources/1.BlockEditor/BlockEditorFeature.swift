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
        var selectedBlockGroup: BlockGroup

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
                selectedBlockGroup = BlockGroup.defaultValue
            case .edit(let selectedBlock, let blockGroup):
                initialBlock = selectedBlock
                editingBlock = selectedBlock
                nameText = selectedBlock.name
                selectedBlockGroup = blockGroup
            }
        }
    }

    public enum Action: TCAFeatureAction, BindableAction {
        public enum ViewAction {
            case typeNameText(String)
            case onTapConfirmButton
            case onTapGroupSelection
            case onTapIconSelection
        }

        public enum InnerAction {

        }

        public enum DelegateAction {

        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)
        case iconSelect(PresentationAction<IconSelectFeature.Action>)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .typeNameText(let text):
                    state.nameText = text.slice(to: state.nameTextLimit)
                    state.editingBlock.name = state.nameText
                    return .none

                case .onTapGroupSelection:
                    return .none

                case .onTapIconSelection:
                    let selectedIconIndex = state.editingBlock.iconIndex
                    state.iconSelect = .init(selectedIconIndex: selectedIconIndex)
                    return .none

                case .onTapConfirmButton:
                    return .none
                }

            case .iconSelect(.presented(.delegate(.didSelectIcon(let selectedIconIndex)))):
                state.editingBlock.iconIndex = selectedIconIndex
                state.iconSelect = nil
                return .none

            default:
                return .none
            }
        }
        .ifLet(\.$iconSelect, action: \.iconSelect) {
            IconSelectFeature()
        }
    }
}
