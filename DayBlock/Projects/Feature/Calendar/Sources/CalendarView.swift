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
                .padding(.horizontal, 20)

            WeekdayHeader()
                .padding(.horizontal, 20)
                .padding(.top, 24)

            MonthCalendar()
                .padding(.top, 8)

            Spacer()
        }
    }

    // MARK: - Header

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

    // MARK: - Weekday Header

    @ViewBuilder
    private func WeekdayHeader() -> some View {
        let weekdays = ["S", "M", "T", "W", "T", "F", "S"]
        HStack(spacing: 0) {
            ForEach(weekdays.indices, id: \.self) { index in
                Text(weekdays[index])
                    .brandFont(.poppins(.semiBold), 14)
                    .foregroundStyle(
                        index == 0
                            ? DesignSystem.Colors.eventDestructive.swiftUIColor
                            : DesignSystem.Colors.gray500.swiftUIColor
                    )
                    .frame(maxWidth: .infinity)
            }
        }
    }

    // MARK: - Month Calendar

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
            EmptyView()
        }
        .monthHeaders { _ in
            EmptyView()
        }
        .onDaySelection { day in
            store.send(.view(.onDaySelected(day.components)))
        }
        .dayAspectRatio(1)
        .layoutMargins(.zero)
        .interMonthSpacing(0)
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
        ZStack {
            if isSelected {
                Circle()
                    .fill(DesignSystem.Colors.gray900.swiftUIColor)
            } else if isToday {
                Circle()
                    .strokeBorder(DesignSystem.Colors.gray900.swiftUIColor, lineWidth: 1.5)
            }

            Text("\(dayNumber)")
                .brandFont(.poppins(.bold), 16)
                .foregroundStyle(
                    isSelected
                        ? DesignSystem.Colors.gray0.swiftUIColor
                        : DesignSystem.Colors.gray900.swiftUIColor
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(1, contentMode: .fit)
    }
}
