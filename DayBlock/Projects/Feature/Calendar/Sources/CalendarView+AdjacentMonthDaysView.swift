//
//  CalendarView+AdjacentMonthDaysView.swift
//  Calendar
//
//  Created by 김민준 on 2/22/26.
//

import SwiftUI
import DesignSystem
import HorizonCalendar

// MARK: - AdjacentMonthDays
struct AdjacentMonthDaysView: View {

    let month: MonthComponents
    let daysAndFrames: [(day: DayComponents, frame: CGRect)]
    let bounds: CGRect
    let calendar: Calendar

    var body: some View {
        ZStack {
            ForEach(Array(adjacentDays.enumerated()), id: \.offset) { _, item in
                AdjacentDayView(dayNumber: item.dayNumber)
                    .position(x: item.center.x, y: item.center.y)
            }
        }
        .frame(width: bounds.width, height: bounds.height)
    }

    private var adjacentDays: [(dayNumber: Int, center: CGPoint)] {
        guard daysAndFrames.count >= 14 else { return [] }

        guard let monthDate = calendar.date(
            from: DateComponents(year: month.year, month: month.month, day: 1)
        ) else { return [] }

        let firstWeekday = calendar.component(.weekday, from: monthDate) - 1
        let daysInMonth = daysAndFrames.count
        let cellSize = daysAndFrames[0].frame.size

        let secondWeekStart = 7 - firstWeekday
        var columnMinX = [CGFloat](repeating: 0, count: 7)
        for col in 0..<7 {
            columnMinX[col] = daysAndFrames[secondWeekStart + col].frame.minX
        }

        let row0Y = daysAndFrames[0].frame.minY
        let rowPitch = daysAndFrames[secondWeekStart].frame.minY - row0Y

        var result = [(dayNumber: Int, center: CGPoint)]()

        // Leading days (이전 달)
        if firstWeekday > 0,
           let prevMonthDate = calendar.date(byAdding: .month, value: -1, to: monthDate),
           let prevMonthRange = calendar.range(of: .day, in: .month, for: prevMonthDate) {
            let prevMonthDayCount = prevMonthRange.count
            for col in 0..<firstWeekday {
                result.append((
                    dayNumber: prevMonthDayCount - firstWeekday + col + 1,
                    center: CGPoint(
                        x: columnMinX[col] + cellSize.width / 2,
                        y: row0Y + cellSize.height / 2
                    )
                ))
            }
        }

        // Trailing days (다음 달)
        let totalUsedCells = firstWeekday + daysInMonth
        let trailingCount = 42 - totalUsedCells
        for i in 0..<trailingCount {
            let cellIndex = totalUsedCells + i
            let row = cellIndex / 7
            let col = cellIndex % 7
            result.append((
                dayNumber: i + 1,
                center: CGPoint(
                    x: columnMinX[col] + cellSize.width / 2,
                    y: row0Y + CGFloat(row) * rowPitch + cellSize.height / 2
                )
            ))
        }

        return result
    }
}

// MARK: - AdjacentDay
private struct AdjacentDayView: View {
    let dayNumber: Int

    var body: some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(width: 24, height: 24)

            Text(dayNumber.description)
                .brandFont(.poppins(.semiBold), 12)
                .foregroundStyle(DesignSystem.Colors.gray300.swiftUIColor)
                .frame(width: 20, height: 20)
                .padding(.top, 1)
        }
        .frame(width: 40, height: 46)
    }
}
