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
    
    var colorIndex: Int
    
    var order: Int

    @Relationship(inverse: \BlockGroupSwiftData.blockList)
    var group: BlockGroupSwiftData

    @Relationship(deleteRule: .cascade)
    var trackingSessions: [TrackingSessionSwiftData]

    init(
        id: UUID,
        name: String,
        output: Double,
        iconIndex: Int,
        colorIndex: Int,
        order: Int,
        group: BlockGroupSwiftData,
        trackingSessions: [TrackingSessionSwiftData] = []
    ) {
        self.id = id
        self.name = name
        self.output = output
        self.iconIndex = iconIndex
        self.colorIndex = colorIndex
        self.order = order
        self.group = group
        self.trackingSessions = trackingSessions
    }
}
