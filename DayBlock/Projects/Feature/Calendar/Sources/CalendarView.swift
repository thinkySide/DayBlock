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
            
            ScrollView {
                MonthCalendar()
                    .onAppear {
                        scrollToMonth(true)
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
            
            HStack(spacing: 6) {
                Text("total")
                    .brandFont(.pretendard(.bold), 14)
                    .foregroundStyle(DesignSystem.Colors.gray800.swiftUIColor)
                
                Text("+3.5")
                    .brandFont(.pretendard(.bold), 18)
                    .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
            }
        }
    }
    
    @ViewBuilder
    private func TimelineList() -> some View {
        VStack(spacing: 2) {
            TimelineCell()
            TimelineCell()
            TimelineCell()
            TimelineCell()
            TimelineCell()
            TimelineCell()
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func TimelineCell() -> some View {
        HStack {
            IconBlock(
                symbol: Symbol.batteryblock_fill.symbolName,
                color: DesignSystem.ColorPalette.blueBlock1.swiftUIColor,
                size: 32
            )
            
            VStack(alignment: .leading, spacing: 0) {
                Text("첫번째 블럭 만들기")
                    .brandFont(.pretendard(.bold), 16)
                    .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                
                Text("07:55 ~ 08:25")
                    .brandFont(.pretendard(.semiBold), 13)
                    .foregroundStyle(DesignSystem.Colors.gray800.swiftUIColor)
            }
            
            Spacer()
            
            Text(.buildAttributed([
                .init(
                    text: "+",
                    color: DesignSystem.ColorPalette.blueBlock1.swiftUIColor,
                    font: DesignSystemFontFamily.Poppins.bold.swiftUIFont(size: 16)
                ),
                .init(
                    text: "0.5",
                    color: DesignSystem.Colors.gray900.swiftUIColor,
                    font: DesignSystemFontFamily.Poppins.bold.swiftUIFont(size: 16)
                )
            ]))
        }
        .frame(height: 48)
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
