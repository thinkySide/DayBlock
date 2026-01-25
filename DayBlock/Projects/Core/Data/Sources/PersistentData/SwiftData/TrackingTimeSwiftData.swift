//
//  TrackingTimeSwiftData.swift
//  PersistentData
//
//  Created by 김민준 on 1/25/26.
//

import Foundation
import SwiftData

@Model
final class TrackingTimeSwiftData: Identifiable, Sendable {

    @Attribute(.unique)
    var id: UUID

    var startDate: Date

    var endDate: Date

    @Relationship(inverse: \TrackingSessionSwiftData.timeList)
    var session: TrackingSessionSwiftData?

    init(
        id: UUID,
        startDate: Date,
        endDate: Date
    ) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
    }
}
