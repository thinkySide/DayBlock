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
        public var path = StackState<Path.State>()

        public init() {}
    }

    public enum Action {
        case onTapAddBlock
        
        case path(StackActionOf<Path>)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onTapAddBlock:
                let blockEditorState = BlockEditorFeature.State(mode: .add)
                state.path.append(.blockEditor(blockEditorState))
                return .none

            case .path(let stackAction):
                switch stackAction {
                case .element(id: _, action: .blockEditor(.delegate(.didPop))):
                    state.path.removeAll()
                    return .none
                    
                case let .element(id: _, action: .blockEditor(.delegate(.didConfirm(block)))):
                    state.path.removeAll()
                    return .none
                    
                default:
                    return .none
                }
            }
        }
        .forEach(\.path, action: \.path)
    }
}

// MARK: - Path
extension TrackingCarouselFeature.Path.State: Equatable {}
