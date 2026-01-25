//
//  BlockGroupSwiftData.swift
//  PersistentData
//
//  Created by 김민준 on 12/28/25.
//

import Foundation
import SwiftData

@Model
final class BlockGroupSwiftData: Identifiable, Sendable {
    
    @Attribute(.unique)
    var id: UUID

    @Attribute(.unique)
    var name: String
    
    var order: Int

    @Relationship(deleteRule: .cascade)
    var blockList: [BlockSwiftData]
    
    public init(
        id: UUID,
        name: String,
        order: Int,
        blockList: [BlockSwiftData]
    ) {
        self.id = id
        self.name = name
        self.order = order
        self.blockList = blockList
    }
}
