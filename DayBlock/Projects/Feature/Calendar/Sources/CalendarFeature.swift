//
//  CalendarFeature.swift
//  Calendar
//
//  Created by 김민준 on 2/4/26.
//

import ComposableArchitecture
import Domain
import Foundation
import Util

@Reducer
public struct CalendarFeature {

    @ObservableState
    public struct State: Equatable {
        var visibleMonth: DateComponents
        var selectedDate: DateComponents?
        var shouldUpdate: Bool = false
        
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
            case onTapToday
            case onDaySelected(DateComponents)
        }

        public enum InnerAction {}

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

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onTapToday):
                haptic.impact(.soft)
                let today = date.now
                state.shouldUpdate = true
                state.visibleMonth = calendar.dateComponents([.year, .month], from: today)
                state.selectedDate = calendar.dateComponents([.year, .month, .day], from: today)
                return .none
                
            case let .view(.onDaySelected(day)):
                haptic.impact(.soft)
                state.selectedDate = day
                return .none
                
            case .delegate(let delegateAction):
                switch delegateAction {
                case .didScrollToMonth:
                    state.shouldUpdate = false
                    return .none
                }

            default:
                return .none
            }
        }
    }
}
