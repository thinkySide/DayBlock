//
//  DateFormatter+.swift
//  Util
//
//  Created by 김민준 on 12/30/25.
//

import Foundation

public extension Date {

    /// 날짜를 "M월 d일 E요일" 형식으로 반환합니다.
    /// - Returns: "1월 2일 화요일" 형식의 문자열
    var formattedDateWithWeekday: String {
        self.formatted(
            .dateTime
                .month()
                .day()
                .weekday(.wide)
                .locale(Locale(identifier: "ko_KR"))
        )
    }

    /// 시간을 24시간 형식 "HH:mm"으로 반환합니다.
    /// - Returns: "08:25" 형식의 문자열
    var formattedTime24Hour: String {
        self.formatted(
            .dateTime
                .hour(.twoDigits(amPM: .omitted))
                .minute(.twoDigits)
        )
    }
}
