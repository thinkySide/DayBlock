//
//  GroupListFeature.swift
//  ManagementDemoApp
//
//  Created by 김민준 on 1/26/26.
//

import ComposableArchitecture
import Domain
import PersistentData
import Util

@Reducer
public struct GroupListFeature {

    @ObservableState
    public struct State: Equatable {
        var groupList: IdentifiedArrayOf<BlockGroup> = []

        public init() {}
    }

    public enum Action: TCAFeatureAction {
        public enum ViewAction {
            case onAppear
        }

        public enum InnerAction {
            case setGroupList(IdentifiedArrayOf<BlockGroup>)
        }

        public enum DelegateAction {
            
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
    }
    
    @Dependency(\.groupRepository) private var groupRepository

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .onAppear:
                    return fetchGroupList()
                }

            case .inner(let innerAction):
                switch innerAction {
                case .setGroupList(let groupList):
                    state.groupList = groupList
                    return .none
                }

            default:
                return .none
            }
        }
    }
}

// MARK: - Shared Effect
extension GroupListFeature {

    /// 전체 그룹 리스트를 가져옵니다.
    private func fetchGroupList() -> Effect<Action> {
        .run { send in
            let groupList = await groupRepository.fetchGroupList()
            await send(.inner(.setGroupList(.init(uniqueElements: groupList))))
        }
    }
}
