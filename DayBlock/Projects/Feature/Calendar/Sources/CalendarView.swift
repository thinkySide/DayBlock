//
//  CalendarView.swift
//  Calendar
//
//  Created by 김민준 on 2/4/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Domain
import HorizonCalendar

public struct CalendarView: View {

    @Bindable private var store: StoreOf<CalendarFeature>
    @StateObject private var calendarProxy = CalendarViewProxy()

    @Dependency(\.calendar) private var calendar

    public init(store: StoreOf<CalendarFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            NavigationBar()

            MonthCalendar()
                .onAppear {
                    if let date = calendar.date(from: store.visibleMonth) {
                        calendarProxy.scrollToMonth(
                            containing: date,
                            scrollPosition: .firstFullyVisiblePosition,
                            animated: false
                        )
                    }
                }
                .onChange(of: store.visibleMonth) { _, newMonth in
                    if let date = calendar.date(from: newMonth) {
                        calendarProxy.scrollToMonth(
                            containing: date,
                            scrollPosition: .firstFullyVisiblePosition,
                            animated: false
                        )
                    }
                }

            Spacer()
        }
    }

    @ViewBuilder
    private func Header() -> some View {
        HStack {
            Text(headerTitle)
                .brandFont(.poppins(.bold), 22)
                .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)

            Spacer()
            
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
            .padding(.trailing, 8)
            .scaleButton()

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
            calendar: calendar,
            visibleDateRange: store.visibleDateRange,
            monthsLayout: .horizontal(
                options: HorizontalMonthsLayoutOptions(
                    maximumFullyVisibleMonths: 1,
                    scrollingBehavior: .paginatedScrolling(
                        .init(restingPosition: .atLeadingEdgeOfEachMonth, restingAffinity: .atPositionsClosestToTargetOffset)
                    )
                )
            ),
            dataDependency: store.selectedDate,
            proxy: calendarProxy
        )
        .days { day in
            DayView(
                dayNumber: day.day,
                isSelected: day.month.year == store.selectedDate?.year
                && day.month.month == store.selectedDate?.month
                && day.day == store.selectedDate?.day
            )
        }
        .dayOfWeekHeaders { _, weekdayIndex in
            DayOfWeekView(dayOfWeek: .init(rawValue: weekdayIndex) ?? .sunday)
                .padding(.bottom, -24)
        }
        .monthHeaders { _ in
            Header()
        }
        .onDaySelection { day in
            store.send(.view(.onDaySelected(day.components)))
        }
        .dayAspectRatio(1)
        .verticalDayMargin(8)
        .horizontalDayMargin(0)
    }

}

// MARK: - DayOfWeek
private struct DayOfWeekView: View {
    
    let dayOfWeek: DayOfWeek
    
    var body: some View {
        Text(dayOfWeek.toString)
            .brandFont(.poppins(.semiBold), 13)
            .foregroundStyle(DesignSystem.Colors.gray700.swiftUIColor)
    }
}

// MARK: - Day
private struct DayView: View {
    let dayNumber: Int
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 7)
                .foregroundStyle(DesignSystem.Colors.gray300.swiftUIColor)
                .frame(width: 24, height: 24)
            
            Circle()
                .frame(width: 20, height: 20)
                .foregroundStyle(
                    isSelected
                    ? DesignSystem.Colors.gray900.swiftUIColor
                    : .clear
                )
                .padding(.top, 1)
                .overlay {
                    Text(dayNumber.description)
                        .brandFont(.poppins(.semiBold), 12)
                        .foregroundStyle(
                            isSelected
                            ? DesignSystem.Colors.gray0.swiftUIColor
                            : DesignSystem.Colors.gray800.swiftUIColor
                        )
                }
        }
        .frame(width: 40, height: 46)
    }
}
