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
    let trackingColors: [Int]

    var body: some View {
        switch day.ownership {
        case .currentMonth:
            currentMonthCell
        case .previousMonth, .nextMonth:
            adjacentMonthCell
        }
    }

    // MARK: - Current Month

    private var currentMonthCell: some View {
        VStack(spacing: 0) {
            blockIndicator
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

    // MARK: - Adjacent Month
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

    // MARK: - Block Indicator

    @ViewBuilder
    private var blockIndicator: some View {
        let colors = trackingColors.prefix(5).map { ColorPalette.toColor(from: $0) }

        if colors.isEmpty {
            RoundedRectangle(cornerRadius: 7)
                .foregroundStyle(DesignSystem.Colors.gray300.swiftUIColor)
        } else {
            switch colors.count {
            case 1: design1(colors[0])
            case 2: design2(colors[0], colors[1])
            case 3: design3(colors[0], colors[1], colors[2])
            case 4: design4(colors[0], colors[1], colors[2], colors[3])
            default: design5(colors[0], colors[1], colors[2], colors[3], colors[4])
            }
        }
    }

    // MARK: - Design 1 (1블럭)
    private func design1(_ c1: Color) -> some View {
        RoundedRectangle(cornerRadius: 7)
            .foregroundStyle(c1)
    }

    // MARK: - Design 2 (2블럭)
    private func design2(_ c1: Color, _ c2: Color) -> some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 4)
                .foregroundStyle(c1)
            RoundedRectangle(cornerRadius: 4)
                .foregroundStyle(c2)
        }
    }

    // MARK: - Design 3 (3블럭)
    private func design3(_ c1: Color, _ c2: Color, _ c3: Color) -> some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 4)
                .foregroundStyle(c1)
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(c2)
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(c3)
            }
        }
    }

    // MARK: - Design 4 (4블럭)
    private func design4(_ c1: Color, _ c2: Color, _ c3: Color, _ c4: Color) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(c1)
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(c2)
            }
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(c3)
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(c4)
            }
        }
    }

    // MARK: - Design 5 (5블럭 이상)
    private func design5(
        _ c1: Color, _ c2: Color, _ c3: Color, _ c4: Color, _ c5: Color
    ) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(c1)
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(c2)
            }
            
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(c3)
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(c4)
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 4)
                .foregroundStyle(c5)
                .frame(width: 12, height: 12)
        }
    }
}
