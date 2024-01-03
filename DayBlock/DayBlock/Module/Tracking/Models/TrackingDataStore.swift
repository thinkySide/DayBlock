//
//  TrackingDataStore.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/26.
//

import UIKit
import CoreData

final class TrackingDataStore {
    
    /// 싱글톤
    static let shared = TrackingDataStore()
    private init() {}
    
    /// CoreData Context
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /// 0.5개의 블럭을 생산하는 주기 (30분)
    let targetSecond = 1800
    
    /// 그룹 & 블럭 데이터
    private let groupData = GroupDataStore.shared
    private let blockData = BlockDataStore.shared
    
    /// 트래킹 날짜 엔티티
    var focusDateList: [TrackingDate] {
        if let entity = blockData.focusEntity().trackingDateList?.array as? [TrackingDate] {
            return entity
        }
        
        fatalError("Error: trackingDateList Entity 반환 실패")
    }
    
    /// 트래킹 시간 엔티티
    var focusTimeList: [TrackingTime] {
        
        guard !focusDateList.isEmpty else { return [] }
        
        if let entity = focusDate().trackingTimeList?.array as? [TrackingTime] {
            return entity
        }
        
        fatalError("Error: trackingTimeList Entity 반환 실패")
    }
}

// MARK: - New Tracking Method
extension TrackingDataStore {
    
    /// 앱이 종료되어있을 동안 며칠이 지났는지 확인하는 값을 반환합니다.
    var calculateElapsedDaySinceAppExit: Int {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        let lastAccessDay = calendar.startOfDay(for: UserDefaultsItem.shared.lastAccessDate)
        let currentDay = calendar.startOfDay(for: Date())
        let dateComponents = calendar.dateComponents([.day], from: lastAccessDay, to: currentDay)
        return dateComponents.day ?? 0
    }
    
    /// 앱이 종료되어있을 동안 시간이 얼마나 흘렀는지 구하고 반환합니다.
    var calculateElapsedTimeSinceAppExit: Int {
        let lastAccess = UserDefaultsItem.shared.lastAccessDate
        let timeInterval = Date().timeIntervalSince(lastAccess)
        return Int(timeInterval)
    }
}


// MARK: - Format Method
extension TrackingDataStore {
    
    /// 커스텀 날짜 포맷을 지정하고 문자열을 반환합니다.
    func formatter(_ dateFormat: String, to date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = dateFormat
        return formatter.string(from: date)
    }
    
    /// 오늘 날짜가 00:00분을 기준으로 몇 초가 경과되었는지 문자열로 반환합니다.
    func todaySecondsToString() -> String {
        let currentTime = formatter("HH/mm/ss")
        let timeArray = currentTime.components(separatedBy: "/")
        
        guard let hour = Int(timeArray[0]),
              let minute = Int(timeArray[1]),
              let second = Int(timeArray[2]) else { return "" }
        
        return String((hour * 3600) + (minute * 60) + second)
    }
    
    /// 오늘 날짜가 00:00분을 기준으로 몇 초가 경과되었는지 정수형으로 반환합니다.
    func todaySecondsToInt() -> Int {
        let currentTime = formatter("HH/mm/ss")
        let timeArray = currentTime.components(separatedBy: "/")
        
        guard let hour = Int(timeArray[0]),
              let minute = Int(timeArray[1]),
              let second = Int(timeArray[2]) else { return 0 }
        
        return (hour * 3600) + (minute * 60) + second
    }
    
    /// 현재 날짜 라벨 문자열을 반환합니다.
    func dateLabel() -> String {
        return formatter("M월 d일 E요일", to: Date())
    }
    
    /// 현재 시간 라벨 문자열을 반환합니다.
    func timeLabel() -> String {
        return formatter("HH:mm", to: Date())
    }
}

// MARK: - READ Method
extension TrackingDataStore {
    
    /// 현재 트래킹 데이터를 출력합니다.
    func printData() {
        if let lastTime = focusTimeList.last {
            print("\(lastTime.startTime) ~ \(String(describing: lastTime.endTime))")
        }
    }
    
    /// 현재 포커스된(트래킹 중인) 날짜 데이터를 반환합니다.
    /// ⚠️ 트래킹 날짜 데이터의 가장 마지막 데이터를 트래킹 중인 것으로 간주
    func focusDate() -> TrackingDate {
        if let lastDate = focusDateList.last {
            return lastDate
        }
        
        fatalError("Error: focusDate 반환 실패")
    }
    
    /// 현재 포커스된(트래킹 중인) 시간 데이터를 반환합니다.
    /// ⚠️ 트래킹 시간 데이터의 가장 마지막 데이터를 트래킹 중인 것으로 간주
    func focusTime() -> TrackingTime {
        
        if let lastTime = focusTimeList.last {
            return lastTime
        }
        
        fatalError("Error: focusTime 반환 실패")
    }
    
    /// 포커스된(트래킹 완료) 날짜를 문자열로 변환 후 반환합니다.
    func focusDateFormat() -> String {
        return "\(focusDate().year)년 \(focusDate().month)월 \(focusDate().day)일 \(focusDate().dayOfWeek)요일"
    }
    
    /// 초 단위를 시간 문자열로 변환해 반환합니다.
    func secondsToTime(_ time: String?) -> String {
        if let time = time,
           let seconds = Int(time) {
            
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
        
        fatalError("잘못된 트래킹 데이터가 저장되었습니다.")
    }
    
    /// 포커스된(트래킹 완료) 시간을 문자열로 변환 후 반환합니다.
    func focusTrackingTimeFormat() -> String {
        guard let firstTime = focusTimeList.first else {
            return "12:34 ~ 56:78"
        }
        let startTime = secondsToTime(firstTime.startTime)
        let endTime = secondsToTime(focusTime().endTime)
        
        return "\(startTime) ~ \(endTime)"
    }
    
    /// 포커스 된 날짜를 Date 타입으로 변환해 반환합니다.
    func focusDateToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = "\(focusDate().year)-\(focusDate().month)-\(focusDate().day)"
        let date = dateFormatter.date(from: dateString)
        return date!
    }
    
    /// a날짜와 b날짜가 동일한지 확인 후 반환합니다.
    ///
    /// 연, 월, 일만을 비교합니다.
    func isSameDate(aDate: Date, bDate: Date) -> Bool {
        return formatter("yyyy-MM-dd", to: aDate) == formatter("yyyy-MM-dd", to: bDate) ? true : false
    }
    
    /// 포커스된(트래킹 완료) 블럭의 개수를 반환합니다.
    func focusTrackingBlockCount() -> Double {
        
        // endTime이 nil이 아닌 경우에 0.5개씩 추가
        var count: Double = 0.0
        for time in focusTimeList {
            if let _ = time.endTime {
                count += 0.5
            }
        }
        
        return count
    }
    
    /// 현재까지 트래킹한 전체 블록 개수 문자열을 반환합니다.
    func totalOutput() -> String {
        
        var count: Double = 0.0
        
        // 1. 그룹 반복
        for group in groupData.list() {
            guard let blockList = group.blockList?.array as? [Block] else {
                fatalError("블럭 리스트 반환 실패")
            }
            
            // 2. 블럭 반복
            for block in blockList {
                guard let dateList = block.trackingDateList?.array as? [TrackingDate] else {
                    fatalError("날짜 리스트 반환 실패")
                }
                
                // 3. 날짜 반복
                for date in dateList {
                    guard let timeList = date.trackingTimeList?.array as? [TrackingTime] else {
                        fatalError("시간 리스트 반환 실패")
                    }
                    
                    // 4. 시간 반복
                    for time in timeList {
                        guard let _ = time.endTime else { break }
                        count += 0.5
                    }
                }
            }
        }
        
        return String(count)
    }
    
    /// 지정한 블럭의 전체 생산량을 반환합니다.
    func totalOutput(_ block: Block) -> String {
        guard let dateList = block.trackingDateList?.array as? [TrackingDate] else {
            fatalError("전체 생산량 반환 실패")
        }
        
        var count: Double = 0.0
        
        // 개수 세기
        for date in dateList {
            if let trackingTimeList = date.trackingTimeList {
                for _ in trackingTimeList {
                    count += 0.5
                }
            }
        }
        
        return String(count)
    }
    
    /// 지정한 블럭의 오늘 생산량을 반환합니다.
    func todayOutput(_ block: Block) -> String {
        guard let dateList = block.trackingDateList?.array as? [TrackingDate] else {
            fatalError("오늘 생산량 반환 실패")
        }
        
        // 오늘 생산량 리스트
        let todayDateList = dateList.filter {
            $0.year == formatter("yyyy") &&
            $0.month == formatter("MM") &&
            $0.day == formatter("dd")
        }
        
        var count: Double = 0.0
        
        // 개수 세기
        for date in todayDateList {
            if let trackingTimeList = date.trackingTimeList {
                for _ in trackingTimeList {
                    count += 0.5
                }
            }
        }
        
        return String(count)
    }
    
    /// 전체 그룹 - 블럭의 오늘 생산량을 반환합니다.
    func todayAllOutput() -> String {
        var count: Double = 0.0
        
        // 1. 그룹 반복
        for group in groupData.list() {
            guard let blockList = group.blockList?.array as? [Block] else {
                fatalError("블럭 리스트 반환 실패")
            }
            
            // 2. 블럭 반복
            for block in blockList {
                guard let dateList = block.trackingDateList?.array as? [TrackingDate] else {
                    fatalError("날짜 리스트 반환 실패")
                }
                
                // 오늘 날짜 리스트
                let todayDateList = dateList.filter {
                    $0.year == formatter("yyyy") &&
                    $0.month == formatter("MM") &&
                    $0.day == formatter("dd")
                }
                
                // 3. 날짜 반복
                for date in todayDateList {
                    guard let timeList = date.trackingTimeList?.array as? [TrackingTime] else {
                        fatalError("시간 리스트 반환 실패")
                    }
                    
                    // 4. 시간 반복
                    for time in timeList {
                        guard let _ = time.endTime else { break }
                        count += 0.5
                    }
                }
            }
        }
        
        return String(count)
    }
    
    /// 오늘의 생산량 보드 데이터를 반환합니다.
    /// 시간 문자열 & 색상
    func todayOutputBoardData() -> [Dictionary<String, UIColor>.Element] {
        
        var datas: [String: UIColor] = [:]
        
        // 1. 그룹 반복
        for group in groupData.list() {
            guard let blockList = group.blockList?.array as? [Block] else {
                fatalError("블럭 리스트 반환 실패")
            }
            
            // 2. 블럭 반복
            for block in blockList {
                guard let dateList = block.trackingDateList?.array as? [TrackingDate] else {
                    fatalError("날짜 리스트 반환 실패")
                }
                
                // 오늘 날짜 리스트
                let todayDateList = dateList.filter {
                    $0.year == formatter("yyyy") &&
                    $0.month == formatter("MM") &&
                    $0.day == formatter("dd")
                }
                
                // 3. 날짜 반복
                for date in todayDateList {
                    guard let timeList = date.trackingTimeList?.array as? [TrackingTime] else {
                        fatalError("시간 리스트 반환 실패")
                    }
                    
                    // 4. 시간 반복
                    for time in timeList {
                        guard let _ = time.endTime else { break }
                        let startTime = secondsToTime(time.startTime)
                        datas.updateValue(UIColor(rgb: group.color), forKey: startTime)
                    }
                }
            }
        }
        
        let sorted = datas.sorted {
            let first = $0.key.components(separatedBy: ":")
            let second = $1.key.components(separatedBy: ":")
            return (first[0], first[1]) < (second[0], second[1])
        }
        
        print(sorted)
        
        return sorted
    }
    
    /// 전체 그룹 - 블럭의 선택한 날짜의 총 생산량을 반환합니다.
    func dateAllOutput(to date: Date) -> String {
        var count: Double = 0.0
        
        // 1. 그룹 반복
        for group in groupData.list() {
            guard let blockList = group.blockList?.array as? [Block] else {
                fatalError("블럭 리스트 반환 실패")
            }
            
            // 2. 블럭 반복
            for block in blockList {
                guard let dateList = block.trackingDateList?.array as? [TrackingDate] else {
                    fatalError("날짜 리스트 반환 실패")
                }
                
                // 날짜 리스트
                let todayDateList = dateList.filter {
                    $0.year == formatter("yyyy", to: date) &&
                    $0.month == formatter("MM", to: date) &&
                    $0.day == formatter("dd", to: date)
                }
                
                // 3. 날짜 반복
                for date in todayDateList {
                    guard let timeList = date.trackingTimeList?.array as? [TrackingTime] else {
                        fatalError("시간 리스트 반환 실패")
                    }
                    
                    // 4. 시간 반복
                    for time in timeList {
                        guard let _ = time.endTime else { break }
                        count += 0.5
                    }
                }
            }
        }
        
        return String(count)
    }
    
    /// 몇일 연속으로 블럭을 생산했는지 문자열 값으로 반환합니다.
    func burningCount() -> String {
        var count = 0
        var targetDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        
        while true {
            
            // 해당 날에 생산된 블럭이 있는 경우
            if Double(dateAllOutput(to: targetDate))! > 0 {
                count += 1
                targetDate = Calendar.current.date(byAdding: .day, value: -1, to: targetDate)!
            }
            
            // 해당 날에 생산된 블럭이 없는 경우
            else { break }
        }
        
        // 오늘 데이터 생성되었는지 확인
        if Double(todayAllOutput())! > 0 { count += 1 }
        
        // 최종 값 반환
        return String(count)
    }
}

// MARK: - CREAT & REMOVE Method
extension TrackingDataStore {
    
    /// 트래킹 시작 데이터를 생성합니다.
    func createStartData() {
        
        // 1. 현재 날짜를 기준으로 트래킹 날짜 엔티티 생성
        let newTrackingDate = TrackingDate(context: context)
        newTrackingDate.year = formatter("yyyy")
        newTrackingDate.month = formatter("MM")
        newTrackingDate.day = formatter("dd")
        newTrackingDate.dayOfWeek = formatter("E")
        
        // 2. 현재 시작 시간을 기준으로 트래킹 시간 엔티티 생성
        let newTrackingTime = TrackingTime(context: context)
        newTrackingTime.startTime = todaySecondsToString()
        
        // 3. 트래킹 데이터 업데이트 및 저장
        newTrackingDate.addToTrackingTimeList(newTrackingTime)
        blockData.focusEntity().addToTrackingDateList(newTrackingDate)
        groupData.saveContext()
    }
    
    /// 온보딩의 "첫번째 블럭 만들기" 트래킹 데이터를 생성합니다.
    func createOnboardingData() {
        
        let newTrackingDate = TrackingDate(context: context)
        let newTrackingTime = TrackingTime(context: context)
        
        // 30분 전이 오늘일 경우
        if todaySecondsToInt() >= 1800 {
            print("트래킹 시작일이 금일입니다.")
            
            // 날짜 데이터 생성
            newTrackingDate.year = formatter("yyyy")
            newTrackingDate.month = formatter("MM")
            newTrackingDate.day = formatter("dd")
            newTrackingDate.dayOfWeek = formatter("E")
            
            // 시간 데이터 생성
            // 시작 시간 = 현재 시간 - 1800초
            newTrackingTime.startTime = "\(todaySecondsToInt() - 1800)"
            newTrackingTime.endTime = todaySecondsToString()
            
            // 트래킹 데이터 저장
            newTrackingDate.addToTrackingTimeList(newTrackingTime)
            blockData.focusEntity().addToTrackingDateList(newTrackingDate)
        }
        
        // 30분 전이 어제일 경우
        else if todaySecondsToInt() < 1800 {
            print("트래킹 시작일이 전일입니다.")
            
            // 날짜 데이터 생성
            let previousDate = Date().previousDay(from: Date())
            newTrackingDate.year = formatter("yyyy", to: previousDate)
            newTrackingDate.month = formatter("MM", to: previousDate)
            newTrackingDate.day = formatter("dd", to: previousDate)
            newTrackingDate.dayOfWeek = formatter("E", to: previousDate)
            
            // 시간 데이터 생성
            let timeValue = 1800 - todaySecondsToInt()
            newTrackingTime.startTime = "\(86400 - timeValue)"
            newTrackingTime.endTime = todaySecondsToString()
        }
        
        newTrackingDate.addToTrackingTimeList(newTrackingTime)
        blockData.focusEntity().addToTrackingDateList(newTrackingDate)
        groupData.saveContext()
    }
    
    /// 블럭 0.5개를 생산할 때마다 추가하는 새로운 trackingTime 데이터
    func appendDataInProgress() {
        
        // 현재 세션 종료 및 저장
        focusTime().endTime = todaySecondsToString()
        
        // 새로운 세션 시작
        let trackingTime = TrackingTime(context: context)
        trackingTime.startTime = todaySecondsToString()
        focusDate().addToTrackingTimeList(trackingTime)
        
        // 코어데이터 저장
        groupData.saveContext()
    }
    
    /// 앱이 종료되어있을 동안 추가된 트래킹 데이터를 추가합니다.
    func appendDataBetweenBackground() {
        
        // 1. 현재 트래킹 중인 세션의 마지막 시간 = 시작 시간 + 한 세션의 시간 + 일시정지 시간
        let initialStartTime = Int(focusTime().startTime)!
        let pausedTime = TimerManager.shared.pausedTime
        let endTime = initialStartTime + targetSecond + pausedTime
        focusTime().endTime = String(endTime)
        
        // 일시정지 시간 초기화
        TimerManager.shared.pausedTime = 0
        
        // 2-1. 앱이 종료되어있을 동안, 하루가 지나지 않음.
        if endTime < 86400 {
            print("endTime: \(endTime), 하루가 지나지 않음.")
            let trackingTime = TrackingTime(context: context)
            trackingTime.startTime = String(endTime)
            focusDate().addToTrackingTimeList(trackingTime)
        }
        
        // 2-2. 만약 endTime이 86400(하루의 끝) 이상이라면,
        // 앱이 종료되어있을 동안, 하루가 지난 것으로 설정.
        else {
            let newEndTime = endTime - 86400
            print("endTime: \(endTime), 하루가 지남. 새로운 endTime: \(newEndTime)")
            
            // 트래킹 보드 초기화
            TrackingBoardService.shared.resetAllData()
            
            // 원래 포커스 날짜의 다음 날짜로 생성
            let nextDate = Date().nextDay(from: focusDateToDate())
            
            // Date 생성
            let newTrackingDate = TrackingDate(context: context)
            newTrackingDate.year = formatter("yyyy", to: nextDate)
            newTrackingDate.month = formatter("MM", to: nextDate)
            newTrackingDate.day = formatter("dd", to: nextDate)
            newTrackingDate.dayOfWeek = formatter("E", to: nextDate)
            print("다음 날짜로 생성: \(formatter("yyyy-MM-dd", to: nextDate))")
            
            // Time 생성
            let trackingTime = TrackingTime(context: context)
            let newStartTime = String(newEndTime)
            print("newStartTime: \(newStartTime)")
            trackingTime.startTime = newStartTime
            
            newTrackingDate.addToTrackingTimeList(trackingTime)
            blockData.focusEntity().addToTrackingDateList(newTrackingDate)
        }
        
        // 3. 코어데이터 저장
        groupData.saveContext()
    }
    
    /// 트래킹을 종료함과 동시에 데이터를 저장합니다.
    func finishData() {
        
        print("최종 트래킹 데이터 저장")
        
        // 현재 세션 종료(삭제)
        focusDate().removeFromTrackingTimeList(focusTime())
        
        // 마지막 트래킹 시간이 전일인지 체크
        let focusTimeList = focusDate().trackingTimeList?.array as! [TrackingTime]
        if focusTimeList.isEmpty {
            print("현재 세션 삭제로 인해 focusDate가 비었습니다.")
            blockData.focusEntity().removeFromTrackingDateList(focusDate())
        }
        
        // 마지막 트래킹 종료 시간 업데이트
        focusTime().endTime = todaySecondsToString()
        
        // 코어데이터 저장
        groupData.saveContext()
    }
    
    /// 트래킹 중단 시 데이터를 삭제합니다.
    func removeStopData() {
        if let safeList = blockData.focusEntity().trackingDateList {
            blockData.focusEntity().removeFromTrackingDateList(at: safeList.count - 1)
            groupData.saveContext()
        }
    }
}
