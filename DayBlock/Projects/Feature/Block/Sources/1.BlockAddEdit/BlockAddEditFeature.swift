//
//  BlockAddEditFeature.swift
//  Block
//
//  Created by 김민준 on 12/21/25.
//

import Foundation
import ComposableArchitecture
import Domain

@Reducer
public struct BlockAddEditFeature {

    @ObservableState
    public struct State: Equatable {
        var selectedBlock: Block
        
        public init(selectedBlock: Block) {
            self.selectedBlock = selectedBlock
        }
    }

    public enum Action {
        
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {

            }
        }
    }
}
