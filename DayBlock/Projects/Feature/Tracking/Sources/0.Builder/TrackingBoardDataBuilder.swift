//
//  TrackingBoardDataBuilder.swift
//  Tracking
//
//  Created by 김민준 on 1/25/26.
//

import SwiftUI
import Domain
import DesignSystem

/// TrackingBoard에 표시할 데이터를 생성하는 Builder입니다.
public struct TrackingBoardDataBuilder {

    /// 개별 트래킹 시간과 표시 정보
    public struct TimeEntry {
        public let time: TrackingTime
        public let color: Color
        public let variation: TrackingBoardBlock.Area.Variation
        public let sessionId: UUID?

        public init(
            time: TrackingTime,
            color: Color,
            variation: TrackingBoardBlock.Area.Variation = .stored,
            sessionId: UUID? = nil
        ) {
            self.time = time
            self.color = color
            self.variation = variation
            self.sessionId = sessionId
        }
    }

    private let calendar: Calendar

    public init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    /// TimeEntry 배열로 TrackingBoard 데이터를 생성합니다.
    /// - Parameter entries: 트래킹 시간 엔트리 배열
    /// - Returns: 시간별 TrackingBoardBlock.Area 딕셔너리
    public func build(entries: [TimeEntry]) -> [Int: TrackingBoardBlock.Area] {
        // 중간 결과를 AreaEntry로 저장 (sessionId 포함)
        var result: [Int: AreaEntry] = [:]

        for entry in entries {
            let newBlocks = convertTimeToBlocks(entry: entry)
            for (hour, newAreaEntry) in newBlocks {
                if let existing = result[hour] {
                    result[hour] = mergeAreaEntries(existing, newAreaEntry)
                } else {
                    result[hour] = newAreaEntry
                }
            }
        }

        // 최종 결과로 변환
        return result.mapValues { $0.area }
    }

    /// 단순 모드로 TrackingBoard 데이터를 생성합니다. (단일 색상, 단일 세션)
    /// - Parameters:
    ///   - timeList: 트래킹 시간 리스트
    ///   - color: 블럭 색상
    ///   - variation: 표시 상태
    ///   - sessionId: 세션 ID (같은 세션이면 full로 병합)
    /// - Returns: 시간별 TrackingBoardBlock.Area 딕셔너리
    public func build(
        timeList: [TrackingTime],
        color: Color,
        variation: TrackingBoardBlock.Area.Variation = .stored,
        sessionId: UUID? = nil
    ) -> [Int: TrackingBoardBlock.Area] {
        let entries = timeList.map {
            TimeEntry(time: $0, color: color, variation: variation, sessionId: sessionId)
        }
        return build(entries: entries)
    }
}

// MARK: - Private Types
private extension TrackingBoardDataBuilder {

    /// Area와 sessionId를 함께 저장하는 중간 구조체
    struct AreaEntry {
        let area: TrackingBoardBlock.Area
        let sessionId: UUID?
        let color: Color
        let variation: TrackingBoardBlock.Area.Variation

        /// firstHalf인지 확인
        var isFirstHalf: Bool {
            if case .firstHalf = area { return true }
            return false
        }

        /// secondHalf인지 확인
        var isSecondHalf: Bool {
            if case .secondHalf = area { return true }
            return false
        }
    }
}

// MARK: - Private Methods
private extension TrackingBoardDataBuilder {

    /// TimeEntry를 블럭 딕셔너리로 변환합니다.
    func convertTimeToBlocks(entry: TimeEntry) -> [Int: AreaEntry] {
        let components = calendar.dateComponents([.hour, .minute], from: entry.time.startDate)
        guard let hour = components.hour, let minute = components.minute else { return [:] }

        let isFirstHalf = minute < 30
        let area: TrackingBoardBlock.Area = isFirstHalf
            ? .firstHalf(entry.color, entry.variation)
            : .secondHalf(entry.color, entry.variation)

        let areaEntry = AreaEntry(
            area: area,
            sessionId: entry.sessionId,
            color: entry.color,
            variation: entry.variation
        )

        return [hour: areaEntry]
    }

    /// 두 개의 AreaEntry를 병합합니다.
    func mergeAreaEntries(_ existing: AreaEntry, _ new: AreaEntry) -> AreaEntry {
        // firstHalf + secondHalf 조합인 경우
        let isComplementary = (existing.isFirstHalf && new.isSecondHalf) ||
                              (existing.isSecondHalf && new.isFirstHalf)

        guard isComplementary else {
            // 같은 half인 경우 새로운 것으로 대체
            return new
        }

        // 같은 세션이면 full로 병합
        let isSameSession = existing.sessionId != nil &&
                            new.sessionId != nil &&
                            existing.sessionId == new.sessionId

        if isSameSession {
            // 같은 세션: full로 병합 (우선순위 높은 variation 사용)
            let mergedVariation = priorityVariation(existing.variation, new.variation)
            let area: TrackingBoardBlock.Area = .full(existing.color, mergedVariation)
            return AreaEntry(
                area: area,
                sessionId: existing.sessionId,
                color: existing.color,
                variation: mergedVariation
            )
        } else {
            // 다른 세션: mixed로 유지
            let (firstHalf, secondHalf): (AreaEntry, AreaEntry)
            if existing.isFirstHalf {
                firstHalf = existing
                secondHalf = new
            } else {
                firstHalf = new
                secondHalf = existing
            }

            let area: TrackingBoardBlock.Area = .mixed(
                firstHalf: firstHalf.color,
                firstHalfState: firstHalf.variation,
                secondHalf: secondHalf.color,
                secondHalfState: secondHalf.variation
            )

            return AreaEntry(
                area: area,
                sessionId: nil, // mixed는 세션 정보 없음
                color: firstHalf.color,
                variation: firstHalf.variation
            )
        }
    }

    /// 두 Variation 중 우선순위가 높은 것을 반환합니다.
    /// 우선순위: tracking > paused > stored
    func priorityVariation(
        _ first: TrackingBoardBlock.Area.Variation,
        _ second: TrackingBoardBlock.Area.Variation
    ) -> TrackingBoardBlock.Area.Variation {
        if first == .tracking || second == .tracking {
            return .tracking
        } else if first == .paused || second == .paused {
            return .paused
        } else {
            return .stored
        }
    }
}
