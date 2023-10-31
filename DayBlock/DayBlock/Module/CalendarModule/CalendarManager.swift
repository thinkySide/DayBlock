//
//  CalendarManager.swift
//  DayBlock
//
//  Created by 김민준 on 10/31/23.
//

import Foundation
import FSCalendar

final class CalendarManager {
    static let shared = CalendarManager()
    private init() {}
    
    /// Header의 기본 달력 포맷
    let headerDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(identifier: "KST")
        return formatter
    }()
}
