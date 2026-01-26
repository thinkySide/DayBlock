//
//  BlockListViewItem.swift
//  Management
//
//  Created by 김민준 on 1/26/26.
//

import Foundation
import Domain

public struct BlockListViewItem: Identifiable, Equatable {
    public var id: UUID { group.id }
    let group: BlockGroup
    let blockList: [BlockViewItem]
    
    public init(
        group: BlockGroup,
        blockList: [BlockViewItem]
    ) {
        self.group = group
        self.blockList = blockList
    }
    
    public struct BlockViewItem: Identifiable, Equatable {
        public var id: UUID { block.id }
        let block: Block
        let total: Double
        
        public init(
            block: Block,
            total: Double
        ) {
            self.block = block
            self.total = total
        }
    }
}
