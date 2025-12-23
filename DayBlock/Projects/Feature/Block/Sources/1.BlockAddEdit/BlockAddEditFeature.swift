//
//  BlockAddEditFeature.swift
//  Block
//
//  Created by 김민준 on 12/21/25.
//

import Foundation
import ComposableArchitecture
import Domain
import Util

@Reducer
public struct BlockAddEditFeature {
    
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
        
        public init(
            mode: Mode
        ) {
            self.mode = mode
            switch mode {
            case .add:
                initialBlock = Block.defaultValue
                editingBlock = Block.defaultValue
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
        }

        public enum InnerAction {

        }

        public enum DelegateAction {
            
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)
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
                }
                
            default:
                return .none
            }
        }
    }
}
