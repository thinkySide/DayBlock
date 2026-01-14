//
//  UserDefaultsKeyGroup.swift
//  PersistentData
//
//  Created by 김민준 on 12/30/25.
//

import Foundation

public typealias KeyValue<T> = UserDefaultsKeyValue<T>

// MARK: - Key Group
public struct UserDefaultsKeyGroup {

    /// 마지막으로 선택된 그룹의 ID
    public var selectedGroupId: KeyValue<UUID?> {
        .init("selectedGroupId", defaultValue: nil)
    }

    /// 마지막으로 선택된 블럭의 ID
    public var selectedBlockId: KeyValue<UUID?> {
        .init("selectedBlockId", defaultValue: nil)
    }

    /// 트래킹 세션 상태
    public var trackingSession: KeyValue<TrackingSessionState?> {
        .init("trackingSession", defaultValue: nil)
    }
}

// MARK: - Tracking Session State
public struct TrackingSessionState: Codable, Equatable {
    public let trackingGroupId: UUID
    public let trackingBlockId: UUID
    public let trackingStartDate: Date
    public let timerBaseDate: Date
    public let elapsedTime: TimeInterval
    public let completedTrackingTimeList: [CompletedTime]
    public let isPaused: Bool

    public struct CompletedTime: Codable, Equatable {
        public let startDate: Date
        public let endDate: Date

        public init(startDate: Date, endDate: Date) {
            self.startDate = startDate
            self.endDate = endDate
        }
    }

    public init(
        trackingGroupId: UUID,
        trackingBlockId: UUID,
        trackingStartDate: Date,
        timerBaseDate: Date,
        elapsedTime: TimeInterval,
        completedTrackingTimeList: [CompletedTime],
        isPaused: Bool
    ) {
        self.trackingGroupId = trackingGroupId
        self.trackingBlockId = trackingBlockId
        self.trackingStartDate = trackingStartDate
        self.timerBaseDate = timerBaseDate
        self.elapsedTime = elapsedTime
        self.completedTrackingTimeList = completedTrackingTimeList
        self.isPaused = isPaused
    }
}
