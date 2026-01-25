//
//  TrackingSession.swift
//  Domain
//
//  Created by 김민준 on 1/25/26.
//

import Foundation

/// 하나의 트래킹 세션을 나타냅니다.
public struct TrackingSession: Identifiable, Equatable, Codable {

    /// 세션 ID
    public let id: UUID

    /// 세션 메모
    public var memo: String

    /// 세션 생성일
    public var createdAt: Date

    /// 트래킹 시간 리스트 (생산한 0.5 블럭들)
    public var timeList: [TrackingTime]

    public init(
        id: UUID,
        memo: String = "",
        createdAt: Date,
        timeList: [TrackingTime]
    ) {
        self.id = id
        self.memo = memo
        self.createdAt = createdAt
        self.timeList = timeList
    }
}

// MARK: - Computed Properties
public extension TrackingSession {

    /// 세션의 총 생산량 (0.5 단위)
    var totalOutput: Double {
        Double(timeList.count) * 0.5
    }

    /// 세션의 총 시간 (초)
    var totalTime: TimeInterval {
        timeList.reduce(0) { total, time in
            total + time.duration
        }
    }
}
