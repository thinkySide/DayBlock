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
        var isSheet: Bool
        var nameText: String
        var editingGroup: BlockGroup
        
        public init(
            mode: Mode,
            isSheet: Bool
        ) {
            self.mode = mode
            self.isSheet = isSheet

            switch mode {
            case .add:
                @Dependency(\.uuid) var uuid
                let newGroup = BlockGroup(id: uuid(), name: "", order: 0)
                self.initialGroup = newGroup
                self.editingGroup = newGroup
                self.nameText = ""
                
            case .edit(let group):
                self.initialGroup = group
                self.editingGroup = group
                self.nameText = group.name
            }
        }
    }

    public enum Action: TCAFeatureAction, BindableAction {
        public enum ViewAction {
            case typeNameText(String)
            case onAppear
            case onTapBackButton
            case onTapConfirmButton
        }

        public enum InnerAction {

        }

        public enum DelegateAction {
            case didPop
            case didConfirm(BlockGroup)
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.groupRepository) private var groupRepository

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
                    return .run { [state] send in
                        let savedGroup: BlockGroup
                        switch state.mode {
                        case .add:
                            savedGroup = try await groupRepository.createGroup(group)
                        case .edit:
                            savedGroup = try await groupRepository.updateGroup(group.id, group)
                        }
                        await send(.delegate(.didConfirm(savedGroup)))
                    }
                }
                
            default:
                return .none
            }
        }
    }
}
