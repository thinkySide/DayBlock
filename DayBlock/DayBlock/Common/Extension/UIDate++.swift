//
//  UIDate++.swift
//  DayBlock
//
//  Created by 김민준 on 11/2/23.
//

import UIKit

extension Date {
    
    /// 날짜 문자열을 반환합니다.
    var dayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "dd"
        return formatter.string(from: self)
    }
    
    /// 지정한 날의 이전 Date를 반환합니다.
    func previousDay(from date: Date) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(byAdding: .day, value: -1, to: date)!
    }
    
    /// 지정한 날의 다음 Date를 반환합니다.
    func nextDay(from date: Date) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(byAdding: .day, value: +1, to: date)!
    }
    
    /// 지정한 날의 마지막 Date를 반환합니다.
    func lastDayOfMonth(from date: Date) -> Date {
        let formatter = DateFormatter()
        let calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy-MM-dd"
        var dateString = formatter.string(from: date)
        dateString.removeLast(3)
        
        let start = formatter.date(from: "\(dateString)-01")!
        let end = calendar.date(byAdding: .month, value: +1, to: start)!
        let result = calendar.date(byAdding: .day, value: -1, to: end)!
        return result
    }
    
    /// 지정한 날의 시작 Date를 반환합니다.
    func firstDayOfMonth(from date: Date) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var dateString = formatter.string(from: date)
        dateString.removeLast(3)
        
        let start = formatter.date(from: "\(dateString)-01")!
        return start
    }
}
