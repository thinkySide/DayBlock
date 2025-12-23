//
//  BlockAddEditFeature.swift
//  Block
//
//  Created by 김민준 on 12/21/25.
//

import Foundation
import ComposableArchitecture
import Domain
import Util

@Reducer
public struct BlockAddEditFeature {
    
    public enum Mode: Equatable {
        case add
        case edit(selectedBlock: Block)
    }

    @ObservableState
    public struct State: Equatable {
        var mode: Mode
        var block: Block
        
        public init(
            mode: Mode
        ) {
            self.mode = mode
            switch mode {
            case .add: block = Block.defaultValue
            case .edit(let selectedBlock): block = selectedBlock
            }
        }
    }

    public enum Action: TCAFeatureAction {
        public enum ViewAction {
            
        }
        
        public enum InnerAction {
            
        }
        
        public enum DelegateAction {
            
        }
        
        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {

            }
        }
    }
}
