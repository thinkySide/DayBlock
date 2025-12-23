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

    @ObservableState
    public struct State: Equatable {
        var selectedBlock: Block
        
        public init(selectedBlock: Block) {
            self.selectedBlock = selectedBlock
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
