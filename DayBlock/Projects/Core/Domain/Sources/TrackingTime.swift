//
//  TrackingTime.swift
//  Domain
//
//  Created by 김민준 on 1/25/26.
//

import Foundation

/// 0.5 블럭 하나의 트래킹 시간 정보입니다.
public struct TrackingTime: Identifiable, Equatable, Codable {

    /// 시간 ID
    public let id: UUID

    /// 시작 날짜
    public var startDate: Date

    /// 종료 날짜 (트래킹 진행 중일 때는 nil)
    public var endDate: Date?

    public init(
        id: UUID = UUID(),
        startDate: Date,
        endDate: Date? = nil
    ) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
    }
}

// MARK: - Computed Properties
public extension TrackingTime {

    /// 트래킹 시간 (초)
    var duration: TimeInterval {
        guard let endDate else { return 0 }
        return endDate.timeIntervalSince(startDate)
    }
}
