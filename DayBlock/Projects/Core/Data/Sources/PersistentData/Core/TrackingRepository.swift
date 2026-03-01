//
//  TrackingRepository.swift
//  PersistentData
//
//  Created by 김민준 on 1/25/26.
//

import Foundation
import SwiftData
import Dependencies
import DependenciesMacros
import Domain
import Util

@DependencyClient
public struct TrackingRepository {
    /// 트래킹 세션 생성
    public var createSession: @Sendable (_ blockId: UUID, TrackingSession) async throws -> TrackingSession
    /// 특정 블럭의 트래킹 세션 목록 조회
    public var fetchSessions: @Sendable (_ blockId: UUID) async -> [TrackingSession] = { _ in [] }
    /// 트래킹 세션 업데이트 (메모 수정 등)
    public var updateSession: @Sendable (_ sessionId: UUID, TrackingSession) async throws -> TrackingSession
    /// 트래킹 세션 삭제
    public var deleteSession: @Sendable (_ sessionId: UUID) async -> Void
}

// MARK: - DependencyKey
extension TrackingRepository: DependencyKey {

    @MainActor
    static let modelContext: ModelContext = {
        @Dependency(\.modelContainer) var modelContainer
        return modelContainer.mainContext
    }()

    public static var liveValue: TrackingRepository {
        TrackingRepository(
            createSession: { blockId, session in
                let blockDescriptor = FetchDescriptor<BlockSwiftData>(
                    predicate: #Predicate { $0.id == blockId }
                )

                let targetBlock = try await Task { @MainActor in
                    try modelContext.fetch(blockDescriptor).first
                }.value

                guard let targetBlock else {
                    throw PersistentDataError.notFound
                }

                // TrackingTime -> TrackingTimeSwiftData 변환
                @Dependency(\.date) var date
                let timeSwiftDataList = session.timeList.map { time in
                    TrackingTimeSwiftData(
                        id: time.id,
                        startDate: time.startDate,
                        endDate: time.endDate ?? date()
                    )
                }

                let sessionSwiftData = TrackingSessionSwiftData(
                    id: session.id,
                    memo: session.memo,
                    createdAt: session.createdAt,
                    timeList: timeSwiftDataList
                )

                try await MainActor.run {
                    // 관계 설정
                    sessionSwiftData.block = targetBlock
                    timeSwiftDataList.forEach { $0.session = sessionSwiftData }

                    modelContext.insert(sessionSwiftData)
                    try modelContext.save()
                }

                return session
            },
            fetchSessions: { blockId in
                do {
                    var descriptor = FetchDescriptor<TrackingSessionSwiftData>(
                        predicate: #Predicate { $0.block?.id == blockId }
                    )
                    descriptor.sortBy = [SortDescriptor(\.createdAt, order: .reverse)]

                    return try await Task { @MainActor in
                        let sessionList = try modelContext.fetch(descriptor)
                        return sessionList.map { swiftData in
                            TrackingSession(
                                id: swiftData.id,
                                memo: swiftData.memo,
                                createdAt: swiftData.createdAt,
                                timeList: swiftData.timeList.map { timeData in
                                    TrackingTime(
                                        id: timeData.id,
                                        startDate: timeData.startDate,
                                        endDate: timeData.endDate
                                    )
                                }
                            )
                        }
                    }.value
                } catch {
                    Debug.log("SwiftData ModelContext 에러: \(error)")
                    return []
                }
            },
            updateSession: { sessionId, session in
                let descriptor = FetchDescriptor<TrackingSessionSwiftData>(
                    predicate: #Predicate { $0.id == sessionId }
                )

                let targetSession = try await Task { @MainActor in
                    try modelContext.fetch(descriptor).first
                }.value

                guard let targetSession else {
                    throw PersistentDataError.notFound
                }

                return try await MainActor.run {
                    targetSession.memo = session.memo
                    try modelContext.save()

                    return TrackingSession(
                        id: targetSession.id,
                        memo: targetSession.memo,
                        createdAt: targetSession.createdAt,
                        timeList: targetSession.timeList.map { timeData in
                            TrackingTime(
                                id: timeData.id,
                                startDate: timeData.startDate,
                                endDate: timeData.endDate
                            )
                        }
                    )
                }
            },
            deleteSession: { sessionId in
                do {
                    let descriptor = FetchDescriptor<TrackingSessionSwiftData>(
                        predicate: #Predicate { $0.id == sessionId }
                    )

                    let targetSession = try await Task { @MainActor in
                        try modelContext.fetch(descriptor).first
                    }.value

                    guard let targetSession else {
                        throw PersistentDataError.notFound
                    }

                    try await MainActor.run {
                        modelContext.delete(targetSession)
                        try modelContext.save()
                    }
                } catch {
                    Debug.log("SwiftData ModelContext 에러: \(error)")
                }
            }
        )
    }
}

// MARK: - DependencyValues
extension DependencyValues {
    public var trackingRepository: TrackingRepository {
        get { self[TrackingRepository.self] }
        set { self[TrackingRepository.self] = newValue }
    }
}
