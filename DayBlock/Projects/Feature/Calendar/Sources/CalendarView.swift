//
//  CalendarView.swift
//  Calendar
//
//  Created by 김민준 on 2/4/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import HorizonCalendar

public struct CalendarView: View {

    @Bindable private var store: StoreOf<CalendarFeature>

    public init(store: StoreOf<CalendarFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            NavigationBar()

            Header()
                .padding(.horizontal, 14)

            WeekdayHeader()
                .padding(.top, 12)
                .padding(.horizontal, 8)

            MonthCalendar()
                .padding(.top, -48)
                .zIndex(-1)

            Spacer()
        }
    }

    @ViewBuilder
    private func Header() -> some View {
        HStack {
            Text(headerTitle)
                .brandFont(.poppins(.bold), 22)
                .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)

            Button {
                store.send(.view(.onTapToday))
            } label: {
                Text("today")
                    .brandFont(.poppins(.bold), 13)
                    .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                    .frame(height: 26)
                    .padding(.horizontal, 10)
                    .background(DesignSystem.Colors.gray100.swiftUIColor)
                    .clipShape(Capsule())
            }
            .padding(.leading, 8)
            .scaleButton()

            Spacer()

            CalendarMonthIndicator()
        }
    }

    private var headerTitle: String {
        let year = store.visibleMonth.year ?? 2025
        let month = store.visibleMonth.month ?? 1
        return String(format: "%d.%02d", year, month)
    }

    @ViewBuilder
    private func CalendarMonthIndicator() -> some View {
        HStack(spacing: 16) {
            Button {
                store.send(.view(.onTapPreviousMonth))
            } label: {
                DesignSystem.Icons.arrowLeft.swiftUIImage
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .scaleButton()

            Button {
                store.send(.view(.onTapNextMonth))
            } label: {
                DesignSystem.Icons.arrowRight.swiftUIImage
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .scaleButton()
        }
    }

    @ViewBuilder
    private func WeekdayHeader() -> some View {
        let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        HStack(spacing: 0) {
            ForEach(Array(weekdays.enumerated()), id: \.offset) { index, weekday in
                Text(weekday)
                    .brandFont(.poppins(.semiBold), 13)
                    .foregroundStyle(DesignSystem.Colors.gray700.swiftUIColor)
                    .frame(width: 40)
                
                if index < weekdays.count - 1 {
                    Spacer()
                }
            }
        }
    }

    @ViewBuilder
    private func MonthCalendar() -> some View {
        CalendarViewRepresentable(
            calendar: store.calendar,
            visibleDateRange: store.visibleDateRange,
            monthsLayout: .horizontal(
                options: HorizontalMonthsLayoutOptions(
                    maximumFullyVisibleMonths: 1,
                    scrollingBehavior: .paginatedScrolling(
                        .init(restingPosition: .atLeadingEdgeOfEachMonth, restingAffinity: .atPositionsClosestToTargetOffset)
                    )
                )
            ),
            dataDependency: store.selectedDate
        )
        .days { day in
            DayView(
                dayNumber: day.day,
                isSelected: false,
                isToday: isToday(day)
            )
        }
        .dayOfWeekHeaders { _, _ in
            Color.clear
                .frame(height: .zero)
        }
        .monthHeaders { _ in
            Color.clear
                .frame(height: .zero)
        }
        .onDaySelection { day in
            store.send(.view(.onDaySelected(day.components)))
        }
        .dayAspectRatio(1)
        .verticalDayMargin(8)
        .horizontalDayMargin(0)
    }

    private func isToday(_ day: DayComponents) -> Bool {
        let today = store.calendar.dateComponents([.year, .month, .day], from: Date())
        return day.month.year == today.year
            && day.month.month == today.month
            && day.day == today.day
    }
}

// MARK: - Day View
private struct DayView: View {
    let dayNumber: Int
    let isSelected: Bool
    let isToday: Bool

    var body: some View {
        VStack(spacing: 1) {
            RoundedRectangle(cornerRadius: 7)
                .foregroundStyle(DesignSystem.Colors.gray300.swiftUIColor)
                .frame(width: 24, height: 24)
            
            Text(dayNumber.description)
                .brandFont(.poppins(.semiBold), 12)
                .foregroundStyle(DesignSystem.Colors.gray800.swiftUIColor)
        }
        .frame(width: 40)
    }
}
