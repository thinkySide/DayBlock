//
//  BlockSwiftData.swift
//  PersistentData
//
//  Created by 김민준 on 12/28/25.
//

import Foundation
import SwiftData

@Model
final class BlockSwiftData: Identifiable, Sendable {
    
    @Attribute(.unique)
    var id: UUID
    
    var name: String
    
    var output: Double
    
    var iconIndex: Int
    
    @Relationship(inverse: \BlockGroupSwiftData.blockList)
    var group: BlockGroupSwiftData
    
    init(
        id: UUID,
        name: String,
        output: Double,
        iconIndex: Int,
        group: BlockGroupSwiftData
    ) {
        self.id = id
        self.name = name
        self.output = output
        self.iconIndex = iconIndex
        self.group = group
    }
}
