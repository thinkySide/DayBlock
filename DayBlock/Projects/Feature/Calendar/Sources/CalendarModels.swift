//
//  CalendarModels.swift
//  Calendar
//
//  Created by 김민준 on 3/1/26.
//

import Foundation

// MARK: - DayOwnership
public enum DayOwnership: Equatable {
    case currentMonth
    case previousMonth
    case nextMonth
}

// MARK: - CalendarDay
public struct CalendarDay: Equatable, Identifiable {
    public let id: String
    let dayNumber: Int
    let dateComponents: DateComponents
    let ownership: DayOwnership
}

// MARK: - MonthPage
public struct MonthPage: Equatable, Identifiable {
    public let id: Int
    let year: Int
    let month: Int
    let days: [CalendarDay]
}
