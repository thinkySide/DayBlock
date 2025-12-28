//
//  GroupEditorFeature.swift
//  Editor
//
//  Created by 김민준 on 12/27/25.
//

import Foundation
import ComposableArchitecture
import Domain
import Util

@Reducer
public struct GroupEditorFeature {
    
    public enum Mode: Equatable {
        case add
        case edit(BlockGroup)
    }

    @ObservableState
    public struct State: Equatable {
        let nameTextLimit: Int = 8
        let initialGroup: BlockGroup
        
        var mode: Mode
        var nameText: String = ""
        var editingGroup: BlockGroup
        
        @Presents var colorSelect: ColorSelectFeature.State?
        
        public init(
            mode: Mode
        ) {
            self.mode = mode

            switch mode {
            case .add:
                @Dependency(\.uuid) var uuid
                let newGroup = BlockGroup(id: uuid(), name: "", colorIndex: 4)
                self.initialGroup = newGroup
                self.editingGroup = newGroup
                
            case .edit(let group):
                self.initialGroup = group
                self.editingGroup = group
            }
        }
    }

    public enum Action: TCAFeatureAction, BindableAction {
        public enum ViewAction {
            case typeNameText(String)
            case onAppear
            case onTapBackButton
            case onTapConfirmButton
            case onTapColorSelection
        }

        public enum InnerAction {

        }

        public enum DelegateAction {
            case didPop
            case didConfirm
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)
        case colorSelect(PresentationAction<ColorSelectFeature.Action>)
    }
    
    @Dependency(\.swiftDataRepository) private var swiftDataRepository

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .onAppear:
                    return .none
                    
                case .typeNameText(let text):
                    state.nameText = text.slice(to: state.nameTextLimit)
                    state.editingGroup.name = state.nameText
                    return .none
                    
                case .onTapBackButton:
                    return .send(.delegate(.didPop))
                    
                case .onTapConfirmButton:
                    let group = state.editingGroup
                    return .run { send in
                        await swiftDataRepository.createGroup(group)
                        await send(.delegate(.didConfirm))
                    }
                    
                case .onTapColorSelection:
                    let colorIndex = state.editingGroup.colorIndex
                    state.colorSelect = .init(selectedColorIndex: colorIndex)
                    return .none
                }
                
            case .colorSelect(.presented(.delegate(.didSelectColor(let selectedIndex)))):
                state.editingGroup.colorIndex = selectedIndex
                state.colorSelect = nil
                return .none
                
            default:
                return .none
            }
        }
        .ifLet(\.$colorSelect, action: \.colorSelect) {
            ColorSelectFeature()
        }
    }
}
