//
//  CalendarFeature.swift
//  Calendar
//
//  Created by 김민준 on 2/4/26.
//

import ComposableArchitecture
import Domain
import Foundation
import PersistentData
import Util

// MARK: - TimelineEntry

public struct TimelineEntry: Equatable, Identifiable {
    public let id: UUID
    public let blockName: String
    public let iconIndex: Int
    public let colorIndex: Int
    public let startDate: Date
    public let endDate: Date?
    public let output: Double
}

// MARK: - CalendarFeature

@Reducer
public struct CalendarFeature {

    @ObservableState
    public struct State: Equatable {
        var visibleMonth: DateComponents
        var selectedDate: DateComponents?
        var shouldUpdate: Bool = false
        var timelineEntries: [TimelineEntry] = []

        var totalOutput: Double {
            timelineEntries.reduce(0) { $0 + $1.output }
        }

        let visibleDateRange: ClosedRange<Date>

        public init() {
            @Dependency(\.date) var date
            @Dependency(\.calendar) var calendar

            let today = date.now
            self.selectedDate = calendar.dateComponents([.year, .month, .day], from: today)
            self.visibleMonth = calendar.dateComponents([.year, .month], from: today)

            let startDate = calendar.date(from: .init(year: 2015, month: 1, day: 1)) ?? today
            let endDate = calendar.date(from: .init(year: 2035, month: 12, day: 31)) ?? today
            self.visibleDateRange = startDate...endDate
        }
    }

    public enum Action: TCAFeatureAction {
        public enum ViewAction {
            case onAppear
            case onTapToday
            case onDaySelected(DateComponents)
        }

        public enum InnerAction {
            case setTimelineEntries([TimelineEntry])
        }

        public enum DelegateAction {
            case didScrollToMonth
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
    }

    @Dependency(\.date) private var date
    @Dependency(\.calendar) private var calendar
    @Dependency(\.haptic) private var haptic
    @Dependency(\.groupRepository) private var groupRepository
    @Dependency(\.blockRepository) private var blockRepository
    @Dependency(\.trackingRepository) private var trackingRepository

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                let todayComponents = calendar.dateComponents([.year, .month, .day], from: date.now)
                return fetchTimeline(for: todayComponents)

            case .view(.onTapToday):
                haptic.impact(.soft)
                let today = date.now
                state.shouldUpdate = true
                state.visibleMonth = calendar.dateComponents([.year, .month], from: today)
                let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
                state.selectedDate = todayComponents
                return fetchTimeline(for: todayComponents)

            case let .view(.onDaySelected(day)):
                haptic.impact(.soft)
                state.selectedDate = day
                return fetchTimeline(for: day)

            case let .inner(.setTimelineEntries(entries)):
                state.timelineEntries = entries
                return .none

            case .delegate(let delegateAction):
                switch delegateAction {
                case .didScrollToMonth:
                    state.shouldUpdate = false
                    return .none
                }
            }
        }
    }

    // MARK: - Private

    private func fetchTimeline(for dateComponents: DateComponents) -> Effect<Action> {
        .run { send in
            guard let targetDate = calendar.date(from: dateComponents) else { return }

            let groupList = await groupRepository.fetchGroupList()
            var entries: [TimelineEntry] = []

            for group in groupList {
                let blockList = await blockRepository.fetchBlockList(group.id)

                for block in blockList {
                    let sessions = await trackingRepository.fetchSessions(block.id)

                    for session in sessions {
                        let matchingTimes = session.timeList
                            .filter { calendar.isDate($0.startDate, inSameDayAs: targetDate) }
                            .sorted { $0.startDate < $1.startDate }

                        guard !matchingTimes.isEmpty else { continue }

                        let entry = TimelineEntry(
                            id: session.id,
                            blockName: block.name,
                            iconIndex: block.iconIndex,
                            colorIndex: block.colorIndex,
                            startDate: matchingTimes.first!.startDate,
                            endDate: matchingTimes.last!.endDate,
                            output: Double(matchingTimes.count) * 0.5
                        )
                        entries.append(entry)
                    }
                }
            }

            entries.sort { $0.startDate < $1.startDate }
            await send(.inner(.setTimelineEntries(entries)))
        }
    }
}
