//
//  TrackingSessionSwiftData.swift
//  PersistentData
//
//  Created by 김민준 on 1/25/26.
//

import Foundation
import SwiftData

@Model
final class TrackingSessionSwiftData: Identifiable, Sendable {

    @Attribute(.unique)
    var id: UUID

    var memo: String

    var createdAt: Date

    @Relationship(inverse: \BlockSwiftData.trackingSessions)
    var block: BlockSwiftData?

    @Relationship(deleteRule: .cascade)
    var timeList: [TrackingTimeSwiftData]

    init(
        id: UUID,
        memo: String,
        createdAt: Date,
        timeList: [TrackingTimeSwiftData] = []
    ) {
        self.id = id
        self.memo = memo
        self.createdAt = createdAt
        self.timeList = timeList
    }
}
