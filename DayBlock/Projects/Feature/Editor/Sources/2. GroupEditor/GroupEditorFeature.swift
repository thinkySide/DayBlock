//
//  GroupEditorFeature.swift
//  Editor
//
//  Created by 김민준 on 12/27/25.
//

import Foundation
import ComposableArchitecture
import Domain
import UserDefaults
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
        var nameText: String
        var editingGroup: BlockGroup
        var isPopupPresented: Bool = false
        var isDefaultGroup: Bool = false

        public init(mode: Mode) {
            @Dependency(\.userDefaultsService) var userDefaultsService
            self.mode = mode

            switch mode {
            case .add:
                @Dependency(\.uuid) var uuid
                let newGroup = BlockGroup(id: uuid(), name: "", order: 0)
                self.initialGroup = newGroup
                self.editingGroup = newGroup
                self.nameText = ""
                self.isDefaultGroup = false

            case .edit(let group):
                self.initialGroup = group
                self.editingGroup = group
                self.nameText = group.name
                self.isDefaultGroup = userDefaultsService.get(\.defaultGroupId) == group.id
            }
        }
    }

    public enum Action: TCAFeatureAction, BindableAction {
        public enum ViewAction {
            case typeNameText(String)
            case onAppear
            case onTapBackButton
            case onTapConfirmButton
            case onTapDeleteButton
        }

        public enum InnerAction {

        }

        public enum DelegateAction {
            case didPop
            case didConfirm(BlockGroup)
            case didDelete
        }

        public enum PopupAction {
            case cancel
            case deleteGroup
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case popup(PopupAction)
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

                case .onTapDeleteButton:
                    state.isPopupPresented = true
                    return .none
                }

            case .popup(let popupAction):
                switch popupAction {
                case .cancel:
                    state.isPopupPresented = false
                    return .none

                case .deleteGroup:
                    let groupId = state.editingGroup.id
                    state.isPopupPresented = false
                    return .run { send in
                        await groupRepository.deleteGroup(groupId)
                        await send(.delegate(.didDelete))
                    }
                }

            default:
                return .none
            }
        }
    }
}
