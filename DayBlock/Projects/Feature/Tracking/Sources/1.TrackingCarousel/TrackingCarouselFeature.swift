//
//  TrackingCarouselFeature.swift
//  Tracking
//
//  Created by 김민준 on 12/21/25.
//

import Foundation
import ComposableArchitecture
import Domain
import Block

@Reducer
public struct TrackingCarouselFeature {
    
    @Reducer
    public enum Path {
        case blockAddEdit(BlockAddEditFeature)
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
                let selectedBlock = Block(name: "테스트", symbol: "batteryblock.fill", output: 1.5)
                let blockAddEditState = BlockAddEditFeature.State(selectedBlock: selectedBlock)
                state.path.append(.blockAddEdit(blockAddEditState))
                return .none

            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

// MARK: - Path
extension TrackingCarouselFeature.Path.State: Equatable {}
