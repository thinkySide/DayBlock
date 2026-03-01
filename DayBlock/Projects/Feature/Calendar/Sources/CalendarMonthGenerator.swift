//
//  CalendarMonthGenerator.swift
//  Calendar
//
//  Created by 김민준 on 3/1/26.
//

import Foundation

enum CalendarMonthGenerator {

    static let baseYear = 2015
    static let baseMonth = 1
    static let totalMonths = 252

    /// 2015년 1월 기준 월 오프셋 계산
    static func monthOffset(year: Int, month: Int) -> Int {
        (year - baseYear) * 12 + (month - baseMonth)
    }

    /// 오프셋에서 년/월 복원
    static func yearMonth(from offset: Int) -> (year: Int, month: Int) {
        let year = baseYear + offset / 12
        let month = baseMonth + offset % 12
        return (year, month)
    }

    /// 날짜 키 생성 (딕셔너리 룩업용)
    static func dayKey(year: Int, month: Int, day: Int) -> String {
        "\(year)-\(month)-\(day)"
    }

    /// 42셀 그리드 생성 (전월 trailing + 당월 + 차월 leading)
    static func generate(year: Int, month: Int, calendar: Calendar) -> MonthPage {
        let offset = monthOffset(year: year, month: month)

        guard let firstOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1)),
              let range = calendar.range(of: .day, in: .month, for: firstOfMonth)
        else {
            return MonthPage(id: offset, year: year, month: month, days: [])
        }

        let daysInMonth = range.count
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth) - 1

        var days: [CalendarDay] = []

        // Leading days (이전 달)
        if firstWeekday > 0 {
            let prevMonth = calendar.date(byAdding: .month, value: -1, to: firstOfMonth)!
            let prevRange = calendar.range(of: .day, in: .month, for: prevMonth)!
            let prevDaysInMonth = prevRange.count
            let prevYM = yearMonth(from: offset - 1 < 0 ? 0 : offset - 1)

            for i in 0..<firstWeekday {
                let dayNum = prevDaysInMonth - firstWeekday + i + 1
                days.append(CalendarDay(
                    id: "\(offset)-prev-\(dayNum)",
                    dayNumber: dayNum,
                    dateComponents: DateComponents(year: prevYM.year, month: prevYM.month, day: dayNum),
                    ownership: .previousMonth
                ))
            }
        }

        // Current month days (당월)
        for day in 1...daysInMonth {
            days.append(CalendarDay(
                id: "\(offset)-cur-\(day)",
                dayNumber: day,
                dateComponents: DateComponents(year: year, month: month, day: day),
                ownership: .currentMonth
            ))
        }

        // Trailing days (다음 달)
        let totalUsed = firstWeekday + daysInMonth
        let trailingCount = 42 - totalUsed
        if trailingCount > 0 {
            let nextYM = yearMonth(from: min(offset + 1, totalMonths - 1))
            for i in 1...trailingCount {
                days.append(CalendarDay(
                    id: "\(offset)-next-\(i)",
                    dayNumber: i,
                    dateComponents: DateComponents(year: nextYM.year, month: nextYM.month, day: i),
                    ownership: .nextMonth
                ))
            }
        }

        return MonthPage(id: offset, year: year, month: month, days: days)
    }
}
