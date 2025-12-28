//
//  GroupEditorFeature.swift
//  Editor
//
//  Created by 김민준 on 12/27/25.
//

import ComposableArchitecture
import Domain
import Util

@Reducer
public struct GroupEditorFeature {
    
    public enum Mode: Equatable {
        case add
        case edit
    }

    @ObservableState
    public struct State: Equatable {
        let nameTextLimit: Int = 8
        let initialGroup: BlockGroup = .defaultValue
        
        var mode: Mode
        var nameText: String = ""
        var editingGroup: BlockGroup = .defaultValue
        
        @Presents var colorSelect: ColorSelectFeature.State?
        
        public init(
            mode: Mode
        ) {
            self.mode = mode
        }
    }

    public enum Action: TCAFeatureAction, BindableAction {
        public enum ViewAction {
            case typeNameText(String)
            case onTapBackButton
            case onTapConfirmButton
            case onTapColorSelection
        }

        public enum InnerAction {

        }

        public enum DelegateAction {
            case didPop
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)
        case colorSelect(PresentationAction<ColorSelectFeature.Action>)
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
                    return .none
                    
                case .onTapBackButton:
                    return .send(.delegate(.didPop))
                    
                case .onTapConfirmButton:
                    return .none
                    
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
