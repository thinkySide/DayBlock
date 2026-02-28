//
//  CalendarGridView.swift
//  Calendar
//
//  Created by 김민준 on 3/1/26.
//

import SwiftUI

struct CalendarGridView: View {

    let page: MonthPage
    let selectedDate: DateComponents?
    let onDayTapped: (CalendarDay) -> Void

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(page.days) { day in
                CalendarDayCell(
                    day: day,
                    isSelected: isSelected(day)
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    onDayTapped(day)
                }
            }
        }
    }

    private func isSelected(_ day: CalendarDay) -> Bool {
        guard let selected = selectedDate else { return false }
        return day.dateComponents.year == selected.year
            && day.dateComponents.month == selected.month
            && day.dateComponents.day == selected.day
    }
}
