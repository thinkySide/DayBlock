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
        /// 현재 표시 중인 월
        var visibleMonth: DateComponents
        /// 선택된 날짜
        var selectedDate: DateComponents?
        /// 표시 가능한 날짜 범위 (무한 스크롤을 위해 넓은 범위 설정)
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
            /// 날짜 선택
            case onDaySelected(DateComponents)
            /// 보이는 월이 변경됨
            case onVisibleMonthChanged(DateComponents)
            /// 이전 월 버튼 탭
            case onTapPreviousMonth
            /// 다음 월 버튼 탭
            case onTapNextMonth
            /// 오늘 버튼 탭
            case onTapToday
        }

        public enum InnerAction {}

        public enum DelegateAction {}

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
    }
    
    @Dependency(\.date) private var date
    @Dependency(\.calendar) private var calendar

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(.onDaySelected(day)):
                state.selectedDate = day
                return .none

            case let .view(.onVisibleMonthChanged(month)):
                state.visibleMonth = month
                return .none

            case .view(.onTapPreviousMonth):
                if let currentDate = calendar.date(from: state.visibleMonth),
                   let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentDate) {
                    state.visibleMonth = calendar.dateComponents([.year, .month], from: previousMonth)
                }
                return .none

            case .view(.onTapNextMonth):
                if let currentDate = calendar.date(from: state.visibleMonth),
                   let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentDate) {
                    state.visibleMonth = calendar.dateComponents([.year, .month], from: nextMonth)
                }
                return .none

            case .view(.onTapToday):
                let today = date.now
                state.visibleMonth = calendar.dateComponents([.year, .month], from: today)
                state.selectedDate = calendar.dateComponents([.year, .month, .day], from: today)
                return .none

            default:
                return .none
            }
        }
    }
}
