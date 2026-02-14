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
        /// 캘린더
        let calendar: Calendar
        /// 표시 가능한 날짜 범위 (무한 스크롤을 위해 넓은 범위 설정)
        let visibleDateRange: ClosedRange<Date>

        public init() {
            let calendar = Calendar.current
            self.calendar = calendar

            // 현재 월로 초기화
            let today = Date()
            self.visibleMonth = calendar.dateComponents([.year, .month], from: today)
            self.selectedDate = nil

            // 10년 전 ~ 10년 후 범위 설정 (무한 스크롤 효과)
            let startDate = calendar.date(from: DateComponents(year: 2015, month: 1, day: 1))!
            let endDate = calendar.date(from: DateComponents(year: 2035, month: 12, day: 31))!
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
                if let currentDate = state.calendar.date(from: state.visibleMonth),
                   let previousMonth = state.calendar.date(byAdding: .month, value: -1, to: currentDate) {
                    state.visibleMonth = state.calendar.dateComponents([.year, .month], from: previousMonth)
                }
                return .none

            case .view(.onTapNextMonth):
                if let currentDate = state.calendar.date(from: state.visibleMonth),
                   let nextMonth = state.calendar.date(byAdding: .month, value: 1, to: currentDate) {
                    state.visibleMonth = state.calendar.dateComponents([.year, .month], from: nextMonth)
                }
                return .none

            case .view(.onTapToday):
                let today = Date()
                state.visibleMonth = state.calendar.dateComponents([.year, .month], from: today)
                state.selectedDate = state.calendar.dateComponents([.year, .month, .day], from: today)
                return .none

            default:
                return .none
            }
        }
    }
}
