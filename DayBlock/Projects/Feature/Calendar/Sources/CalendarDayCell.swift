//
//  CalendarDayCell.swift
//  Calendar
//
//  Created by 김민준 on 3/1/26.
//

import SwiftUI
import DesignSystem

struct CalendarDayCell: View {

    let day: CalendarDay
    let isSelected: Bool

    var body: some View {
        switch day.ownership {
        case .currentMonth:
            currentMonthCell
        case .previousMonth, .nextMonth:
            adjacentMonthCell
        }
    }

    private var currentMonthCell: some View {
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
                    Text(day.dayNumber.description)
                        .brandFont(.poppins(.semiBold), 12)
                        .foregroundStyle(
                            isSelected
                            ? DesignSystem.Colors.gray0.swiftUIColor
                            : DesignSystem.Colors.gray800.swiftUIColor
                        )
                }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 46)
    }

    private var adjacentMonthCell: some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(width: 24, height: 24)

            Text(day.dayNumber.description)
                .brandFont(.poppins(.semiBold), 12)
                .foregroundStyle(DesignSystem.Colors.gray300.swiftUIColor)
                .frame(width: 20, height: 20)
                .padding(.top, 1)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 46)
    }
}
