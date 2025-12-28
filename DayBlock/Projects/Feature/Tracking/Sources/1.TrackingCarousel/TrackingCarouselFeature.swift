//
//  TrackingCarouselFeature.swift
//  Tracking
//
//  Created by 김민준 on 12/21/25.
//

import Foundation
import ComposableArchitecture
import Domain
import Editor
import Util

@Reducer
public struct TrackingCarouselFeature {
    
    @Reducer
    public enum Path {
        case blockEditor(BlockEditorFeature)
    }

    @ObservableState
    public struct State: Equatable {
        var blockList: IdentifiedArrayOf<Block> = []
        var selectedGroup: BlockGroup = .init(id: .init(), name: "", colorIndex: 4)
        
        public var path = StackState<Path.State>()

        public init() {}
    }

    public enum Action: TCAFeatureAction {
        public enum ViewAction {
            case onAppear
            case onTapAddBlock
        }
        
        public enum InnerAction {
            case setSelectedGroup(BlockGroup)
            case setBlockList(IdentifiedArrayOf<Block>)
        }
        
        public enum DelegateAction {
            
        }
        
        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case path(StackActionOf<Path>)
    }

    public init() {}
    
    @Dependency(\.swiftDataRepository) private var swiftDataRepository

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .onAppear:
                    return .concatenate(
                        fetchSelectedGroup(),
                        refreshBlockList(from: state.selectedGroup.id)
                    )
                    
                case .onTapAddBlock:
                    let blockEditorState = BlockEditorFeature.State(mode: .add)
                    state.path.append(.blockEditor(blockEditorState))
                    return .none
                }
                
            case .inner(let innerAction):
                switch innerAction {
                case .setSelectedGroup(let group):
                    state.selectedGroup = group
                    return .none
                    
                case .setBlockList(let blockList):
                    state.blockList = blockList
                    return .none
                }

            case .path(let stackAction):
                switch stackAction {
                case .element(id: _, action: .blockEditor(.delegate(.didPop))):
                    state.path.removeAll()
                    return .none
                    
                case let .element(id: _, action: .blockEditor(.delegate(.didConfirm(block)))):
                    state.path.removeAll()
                    return .concatenate(
                        fetchSelectedGroup(),
                        refreshBlockList(from: state.selectedGroup.id)
                    )
                    
                default:
                    return .none
                }
                
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

// MARK: - Shared Effect
extension TrackingCarouselFeature {
    
    /// 기본 그룹을 반환합니다.
    private func fetchSelectedGroup() -> Effect<Action> {
        .run { send in
            // TODO: 선택한 값 가져오기
            let selectedGroup = await swiftDataRepository.fetchDefaultGroup()
            await send(.inner(.setSelectedGroup(selectedGroup)))
        }
    }
    
    /// 그룹 리스트를 리프레쉬 합니다.
    private func refreshBlockList(from groupId: UUID) -> Effect<Action> {
        .run { send in
            let blockList = await swiftDataRepository.fetchBlockList(groupId: groupId)
            await send(.inner(.setBlockList(.init(uniqueElements: blockList))))
        }
    }
}

// MARK: - Path
extension TrackingCarouselFeature.Path.State: Equatable {}
