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
import Editor
import Util

public struct CalendarView: View {

    @Bindable private var store: StoreOf<CalendarFeature>

    @Dependency(\.calendar) private var calendar

    public init(store: StoreOf<CalendarFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    HStack {
                        MonthHeaderView(visibleMonth: store.visibleMonth)
                        Spacer()
                        TodayButton()
                    }
                    .padding(.horizontal, 14)

                    DayOfWeekHeader()
                        .padding(.horizontal, 14)

                    MonthCalendar()
                        .onAppear {
                            store.send(.view(.onAppear))
                        }
                }

                SectionDivider()
                    .padding(.top, 20)

                TimelineSection()
                    .padding(.top, 20)
            }
            .background(DesignSystem.Colors.gray0.swiftUIColor)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarVisibility(.visible, for: .navigationBar)
            .sheet(
                item: $store.scope(
                    state: \.trackingEditor,
                    action: \.trackingEditor
                )
            ) { childStore in
                TrackingEditorView(store: childStore)
            }
        }
    }

    // MARK: - MonthCalendar

    @ViewBuilder
    private func MonthCalendar() -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(0..<CalendarMonthGenerator.totalMonths, id: \.self) { offset in
                    let ym = CalendarMonthGenerator.yearMonth(from: offset)
                    let page = CalendarMonthGenerator.generate(
                        year: ym.year,
                        month: ym.month,
                        calendar: calendar
                    )

                    CalendarGridView(
                        page: page,
                        selectedDate: store.selectedDate,
                        dailyBlockColors: store.dailyBlockColors,
                        onDayTapped: { day in
                            store.send(.view(.onDaySelected(day)))
                        }
                    )
                    .padding(.horizontal, 10)
                    .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                    .id(offset)
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $store.currentPageID)
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
        .frame(height: 340)
        .onChange(of: store.currentPageID) { _, newValue in
            store.send(.view(.onPageChanged(newValue)))
        }
    }

    // MARK: - TodayButton

    @ViewBuilder
    private func TodayButton() -> some View {
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
        .scaleButton()
    }

    // MARK: - DayOfWeekHeader

    @ViewBuilder
    private func DayOfWeekHeader() -> some View {
        HStack(spacing: 0) {
            ForEach(0..<7, id: \.self) { index in
                Text(DayOfWeek(rawValue: index)?.toString ?? "")
                    .brandFont(.poppins(.semiBold), 13)
                    .foregroundStyle(DesignSystem.Colors.gray700.swiftUIColor)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.top, 8)
    }

    // MARK: - Timeline

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
                .foregroundStyle(DesignSystem.Colors.gray800.swiftUIColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
        } else {
            VStack(spacing: 2) {
                ForEach(store.timelineEntries) { entry in
                    Button {
                        store.send(.view(.onTapTimelineEntry(entry)))
                    } label: {
                        TimelineCell(entry: entry)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.bottom, 16)
            .padding(.horizontal, 20)
        }
    }

    @ViewBuilder
    private func TimelineCell(entry: TimelineEntry) -> some View {
        let blockColor = ColorPalette.toColor(from: entry.block.colorIndex)

        HStack {
            IconBlock(
                symbol: IconPalette.toIcon(from: entry.block.iconIndex),
                color: blockColor,
                size: 32
            )

            VStack(alignment: .leading, spacing: 0) {
                Text(entry.block.name)
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
        .background(DesignSystem.Colors.gray0.swiftUIColor)
    }

    private func timeRangeText(entry: TimelineEntry) -> String {
        let start = entry.startDate.formattedTime24Hour
        if let endDate = entry.endDate {
            return "\(start) ~ \(endDate.formattedTime24Hour)"
        }
        return "\(start) ~"
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
