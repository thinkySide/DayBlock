//
//  BlockAddEditFeature.swift
//  Block
//
//  Created by 김민준 on 12/21/25.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct BlockAddEditFeature {

    @ObservableState
    public struct State: Equatable {
        public init() {}
    }

    public enum Action {
        case dismiss
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .dismiss:
                return .none
            }
        }
    }
}
