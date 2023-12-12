//
//  RepositoryManager.swift
//  DayBlock
//
//  Created by 김민준 on 12/5/23.
//

import UIKit

final class RepositoryManager {
    
    /// 싱글톤
    static let shared = RepositoryManager()
    private init() {}
    
    /// 저장소 월 아이템 배열
    private var monthItems: [RepositoryItem] = []
    
    var dayItems: [RepositoryItem] = []
    
    /// 현재 날짜
    var currentDate = Date()
    
    // MARK: - 저장소 아이템 반환 메서드
    
    /// 저장소 아이템 배열을 반환합니다.
    func currentItems() -> [RepositoryItem] {
        return monthItems
    }
    
    /// 저장소 아이템 배열을 트래킹 시간 순으로 정렬 후 업데이트 합니다.
    func updateCurrentItems(_ items: [RepositoryItem]) {
        let sortedItems =  items.sorted { first, second in
            guard let firstString = first.trackingTimes.first?.startTime,
                  let firstTime = Int(firstString),
                  let secondString = second.trackingTimes.first?.startTime,
                  let secondTime = Int(secondString) else { return false }
            
            return firstTime < secondTime
        }
        self.monthItems = sortedItems
    }
    
    // MARK: - 캘린더 관련 메서드
    
    /// 현재 날짜 기준의 items를 필터링하여 반환합니다.
    func filterSelectedDate(_ dateString: String) {
        
        let fullDate = dateString.components(separatedBy: ".")
        let year = fullDate[0]
        let month = fullDate[1]
        let day = fullDate[2]
        
        let filter = monthItems.filter { item in
            item.trackingDate.year == year &&
            item.trackingDate.month == month &&
            item.trackingDate.day == day
        }
        
        dayItems = filter
    }
    
    /// 해당 날짜가 몇개의 블록 타입을 가지고 있는지 반환합니다.
    func blockTypeCount(dateString: String) -> CalendarCellState {
        let fullDate = dateString.components(separatedBy: ".")
        let year = fullDate[0]
        let month = fullDate[1]
        let day = fullDate[2]
        
        // 년, 월, 일이 맞는지 확인하며 셀 타입 반환
        var groupArray: [String] = []
        for item in monthItems {
            if (item.trackingDate.year == year && item.trackingDate.month == month)
                && item.trackingDate.day == day {
                    
                // 여기서 블럭 타입이 몇개였는지 체크하는 로직 작성해야 함.
                groupArray.append(item.groupName)
            }
        }
        
        // 중복된 요소 삭제 후 최종 개수 결정
        switch Set(groupArray).count {
        case 1: return .one
        case 2: return .two
        case 3: return .three
        case 4: return .four
        case 5: return .five
        default: return .none
        }
    }
    
    /// dayItems의 값을 이용해 컬러 배열을 반환합니다.
    func blockColors(dateString: String) -> [UIColor] {
        let fullDate = dateString.components(separatedBy: ".")
        let year = fullDate[0]
        let month = fullDate[1]
        let day = fullDate[2]
        
        var colorValues: [Int] = []
        for item in monthItems where !colorValues.contains(item.groupColor) {
            if (item.trackingDate.year == year && item.trackingDate.month == month)
                && item.trackingDate.day == day {
                colorValues.append(item.groupColor)
            }
        }
        
        return colorValues.map { UIColor(rgb: $0) }
    }
    
    // MARK: - 변환 메서드
    
    /// 트래킹 시간 문자열을 반환합니다.
    func trackingTimeString(to index: Int) -> String {
        let trackingTimes = dayItems[index].trackingTimes
        
        // 시작 및 종료 시간 옵셔널 바인딩
        guard let startTime = trackingTimes.first?.startTime,
              let endTime = trackingTimes.last?.endTime else {
            fatalError("트래킹 시간 반환에 실패했습니다.")
        }
        
        // 실제 시간으로 변환
        return "\(secondsToTime(startTime))-\(secondsToTime(endTime))"
    }
    
    /// 초 단위를 실제 시간 포맷으로 변환 후 반환합니다.
    func secondsToTime(_ time: String) -> String {
        let seconds = Int(time)!
        
        // 1. 시간 단위로 변환
        let hour = seconds / 3600
        let minute = seconds / 60 - (60 * hour)
        
        // 2. 만약 10보다 작다면(한자리 수라면) 앞에 0 붙여서 return
        var stringHour = String(hour)
        var stringMinute = String(minute)
        if hour < 10 { stringHour.insert("0", at: stringHour.startIndex) }
        if minute < 10 { stringMinute.insert("0", at: stringMinute.startIndex) }
        
        return "\(stringHour):\(stringMinute)"
    }
    
    /// 총 생산량을 반환합니다.
    func totalOutput(to index: Int) -> String {
        let trackingTimes = dayItems[index].trackingTimes
        
        var output = 0.0
        trackingTimes.forEach { _ in
            output += 0.5
        }
        
        return String(output)
    }
}
