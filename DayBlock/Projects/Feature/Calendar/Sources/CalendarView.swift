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
import Util

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
            
            ScrollView {
                MonthCalendar()
                    .onAppear {
                        scrollToMonth(true)
                        store.send(.view(.onAppear))
                    }
                    .onChange(of: store.shouldUpdate) {
                        scrollToMonth(store.shouldUpdate)
                    }
                    .overlay(alignment: .topTrailing) {
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
                                .padding(.leading, 4)
                                .padding(.trailing, 12)
                                .background(DesignSystem.Colors.gray0.swiftUIColor)
                        }
                        .scaleButton()
                    }
                
                SectionDivider()
                    .padding(.top, 20)
                
                TimelineSection()
                    .padding(.top, 20)
            }
            .padding(.bottom, 56)
        }
        .background(DesignSystem.Colors.gray0.swiftUIColor)
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
                        .init(
                            restingPosition: .atIncrementsOfCalendarWidth,
                            restingAffinity: .atPositionsAdjacentToPrevious
                        )
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
        .monthHeaders { month in
            MonthHeaderView(visibleMonth: month.components)
                .padding(.bottom, -16)
                .padding(.horizontal, 14)
        }
        .dayOfWeekHeaders { _, weekdayIndex in
            DayOfWeekView(dayOfWeek: .init(rawValue: weekdayIndex) ?? .sunday)
                .padding(.bottom, -24)
        }
        .monthBackgrounds { context in
            AdjacentMonthDaysView(
                month: context.month,
                daysAndFrames: context.daysAndFrames,
                bounds: context.bounds,
                calendar: calendar
            )
        }
        .onDaySelection { day in
            store.send(.view(.onDaySelected(day.components)))
        }
        .dayAspectRatio(1)
        .verticalDayMargin(8)
        .horizontalDayMargin(0)
    }
    
    @ViewBuilder
    private func TimelineSection() -> some View {
        VStack(spacing: 8) {
            TimelineHeader()
                .padding(.horizontal, 20)
            
            TimelineList()
        }
    }
    
    @ViewBuilder
    private func TimelineHeader() -> some View {
        HStack {
            Text("타임라인")
                .brandFont(.pretendard(.bold), 18)
                .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)

            Spacer()

            if store.totalOutput > 0 {
                HStack(spacing: 6) {
                    Text("total")
                        .brandFont(.pretendard(.bold), 14)
                        .foregroundStyle(DesignSystem.Colors.gray800.swiftUIColor)

                    Text(store.totalOutput.toValueString())
                        .brandFont(.pretendard(.bold), 18)
                        .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                }
            }
        }
    }
    
    @ViewBuilder
    private func TimelineList() -> some View {
        if store.timelineEntries.isEmpty {
            Text("생산된 블럭이 없어요 😴")
                .brandFont(.pretendard(.semiBold), 14)
                .foregroundStyle(DesignSystem.Colors.gray500.swiftUIColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
        } else {
            VStack(spacing: 2) {
                ForEach(store.timelineEntries) { entry in
                    TimelineCell(entry: entry)
                }
            }
            .padding(.horizontal, 20)
        }
    }

    @ViewBuilder
    private func TimelineCell(entry: TimelineEntry) -> some View {
        let blockColor = ColorPalette.toColor(from: entry.colorIndex)

        HStack {
            IconBlock(
                symbol: IconPalette.toIcon(from: entry.iconIndex),
                color: blockColor,
                size: 32
            )

            VStack(alignment: .leading, spacing: 0) {
                Text(entry.blockName)
                    .brandFont(.pretendard(.bold), 16)
                    .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)

                Text(timeRangeText(entry: entry))
                    .brandFont(.pretendard(.semiBold), 13)
                    .foregroundStyle(DesignSystem.Colors.gray800.swiftUIColor)
            }

            Spacer()

            Text(.buildAttributed([
                .init(
                    text: "+",
                    color: blockColor,
                    font: DesignSystemFontFamily.Poppins.bold.swiftUIFont(size: 16)
                ),
                .init(
                    text: entry.output.toValueString(),
                    color: DesignSystem.Colors.gray900.swiftUIColor,
                    font: DesignSystemFontFamily.Poppins.bold.swiftUIFont(size: 16)
                )
            ]))
        }
        .frame(height: 48)
    }

    private func timeRangeText(entry: TimelineEntry) -> String {
        let start = entry.startDate.formattedTime24Hour
        if let endDate = entry.endDate {
            return "\(start) ~ \(endDate.formattedTime24Hour)"
        }
        return "\(start) ~"
    }
    
    private func scrollToMonth(_ shouldUpdate: Bool) {
        if shouldUpdate, let date = calendar.date(from: store.visibleMonth) {
            calendarProxy.scrollToMonth(
                containing: date,
                scrollPosition: .firstFullyVisiblePosition,
                animated: false
            )
            store.send(.delegate(.didScrollToMonth))
        }
    }
}

// MARK: - MonthHeader
private struct MonthHeaderView: View {
    
    let visibleMonth: DateComponents
    
    var body: some View {
        HStack {
            Text(headerTitle)
                .brandFont(.poppins(.bold), 22)
                .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)

            Spacer()
        }
    }

    private var headerTitle: String {
        let year = visibleMonth.year ?? 2025
        let month = visibleMonth.month ?? 1
        return String(format: "%d.%02d", year, month)
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
