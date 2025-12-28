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

    var colorIndex: Int

    @Relationship(deleteRule: .cascade)
    var blockList: [BlockSwiftData]
    
    public init(
        id: UUID,
        name: String,
        colorIndex: Int,
        blockList: [BlockSwiftData]
    ) {
        self.id = id
        self.name = name
        self.colorIndex = colorIndex
        self.blockList = blockList
    }
}
