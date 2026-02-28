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
        var currentPageID: Int?
        var visibleMonth: DateComponents
        var selectedDate: DateComponents?
        var timelineEntries: [TimelineEntry] = []

        var totalOutput: Double {
            timelineEntries.reduce(0) { $0 + $1.output }
        }

        public init() {
            @Dependency(\.date) var date
            @Dependency(\.calendar) var calendar

            let today = date.now
            self.selectedDate = calendar.dateComponents([.year, .month, .day], from: today)
            self.visibleMonth = calendar.dateComponents([.year, .month], from: today)

            let year = calendar.component(.year, from: today)
            let month = calendar.component(.month, from: today)
            self.currentPageID = CalendarMonthGenerator.monthOffset(year: year, month: month)
        }
    }

    public enum Action: TCAFeatureAction, BindableAction {
        public enum ViewAction {
            case onAppear
            case onTapToday
            case onDaySelected(CalendarDay)
            case onPageChanged(Int?)
        }

        public enum InnerAction {
            case setTimelineEntries([TimelineEntry])
        }

        public enum DelegateAction {}

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)
    }

    @Dependency(\.date) private var date
    @Dependency(\.calendar) private var calendar
    @Dependency(\.haptic) private var haptic
    @Dependency(\.groupRepository) private var groupRepository
    @Dependency(\.blockRepository) private var blockRepository
    @Dependency(\.trackingRepository) private var trackingRepository

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                let todayComponents = calendar.dateComponents([.year, .month, .day], from: date.now)
                return fetchTimeline(for: todayComponents)

            case .view(.onTapToday):
                haptic.impact(.soft)
                let today = date.now
                let year = calendar.component(.year, from: today)
                let month = calendar.component(.month, from: today)
                state.currentPageID = CalendarMonthGenerator.monthOffset(year: year, month: month)
                state.visibleMonth = calendar.dateComponents([.year, .month], from: today)
                let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
                state.selectedDate = todayComponents
                return fetchTimeline(for: todayComponents)

            case let .view(.onDaySelected(day)):
                haptic.impact(.soft)
                state.selectedDate = day.dateComponents

                // 전월/차월 일 탭 시 해당 월로 페이지 이동
                if day.ownership != .currentMonth,
                   let year = day.dateComponents.year,
                   let month = day.dateComponents.month {
                    state.currentPageID = CalendarMonthGenerator.monthOffset(year: year, month: month)
                    state.visibleMonth = DateComponents(year: year, month: month)
                }

                return fetchTimeline(for: day.dateComponents)

            case let .view(.onPageChanged(pageID)):
                guard let pageID else { return .none }
                let ym = CalendarMonthGenerator.yearMonth(from: pageID)
                state.visibleMonth = DateComponents(year: ym.year, month: ym.month)
                return .none

            case let .inner(.setTimelineEntries(entries)):
                state.timelineEntries = entries
                return .none

            case .delegate:
                return .none

            case .binding:
                return .none
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
