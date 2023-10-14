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
    
    /// 0.5개의 블럭을 생산하는 주기
    let targetSecond = 10
    
    /// 그룹 & 블럭 데이터
    private let groupData = GroupDataStore.shared
    private let blockData = BlockDataStore.shared
    
    /// 트래킹 날짜 엔티티
    var dateList: [TrackingDate] {
        if let entity = blockData.focusEntity().trackingDateList?.array as? [TrackingDate] {
            return entity
        }
        
        fatalError("Error: trackingDateList Entity 반환 실패")
    }
    
    /// 트래킹 시간 엔티티
    var timeList: [TrackingTime] {
        
        guard !dateList.isEmpty else { return [] }
        
        if let entity = dateList.last?.trackingTimeList?.array as? [TrackingTime] {
            return entity
        }
        
        fatalError("Error: trackingTimeList Entity 반환 실패")
    }
    
    /// 현재 트래킹 되고 있는 블럭
    var currentTrackingBlocks: [String] = []
}

// MARK: - Format Method
extension TrackingDataStore {
    
    /// 커스텀 날짜 포맷을 지정하고 문자열을 반환합니다.
    func formatter(_ dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = dateFormat
        return formatter.string(from: Date())
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
        return formatter("M월 d일 E요일")
    }
    
    /// 현재 시간 라벨 문자열을 반환합니다.
    func timeLabel() -> String {
        return formatter("HH:mm")
    }
}

// MARK: - READ Method
extension TrackingDataStore {
    
    /// 현재 트래킹 데이터를 출력합니다.
    func printData() {
        if let lastTime = timeList.last {
            print("\(lastTime.startTime) ~ \(String(describing: lastTime.endTime))")
        }
    }
    
    /// 현재 포커스된(트래킹 중인) 날짜 데이터를 반환합니다.
    /// ⚠️ 트래킹 날짜 데이터의 가장 마지막 데이터를 트래킹 중인 것으로 간주
    func focusDate() -> TrackingDate {
        if let lastDate = dateList.last {
            return lastDate
        }
        
        fatalError("Error: focusDate 반환 실패")
    }
    
    /// 현재 포커스된(트래킹 중인) 시간 데이터를 반환합니다.
    /// ⚠️ 트래킹 시간 데이터의 가장 마지막 데이터를 트래킹 중인 것으로 간주
    func focusTime() -> TrackingTime {
        if let lastTime = timeList.last {
            return lastTime
        }
        
        fatalError("Error: focusTime 반환 실패")
    }
    
    /// 포커스된(트래킹 완료) 날짜를 문자열로 변환 후 반환합니다.
    func focusDateFormat() -> String {
        return "\(focusDate().year)년 \(focusDate().month)월 \(focusDate().day)일 \(focusDate().dayOfWeek)요일"
    }
    
    /// 포커스된(트래킹 완료) 시간을 문자열로 변환 후 반환합니다.
    func focusTrackingTimeFormat() -> String {
        
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
        
        guard let firstTime = timeList.first else {
            return "12:34 ~ 56:78"
        }
        let startTime = secondsToTime(firstTime.startTime)
        let endTime = secondsToTime(focusTime().endTime)
        
        return "\(startTime) ~ \(endTime)"
    }
    
    /// 포커스된(트래킹 완료) 블럭의 개수를 반환합니다.
    func focusTrackingBlockCount() -> Double {
        
        // endTime이 nil이 아닌 경우에 0.5개씩 추가
        var count: Double = 0.0
        for time in timeList {
            if let _ = time.endTime {
                count += 0.5
            }
        }
        
        return count
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
    
    /// 백그라운드에 나가있을 동안 생성된 블럭을 코어데이터에 추가합니다.
    ///
    /// 마지막으로 백그라운은드로 진입한 시점 (00:00분 기준 경과 초)
    func appendDataBetweenBackground() {
        
        // 1. 트래킹 마무리 시간 업데이트
        let initialStartTime = Int(focusTime().startTime)!
        let pausedTime = TimerManager.shared.pausedTime
        let endTime = initialStartTime + targetSecond + pausedTime
        focusTime().endTime = String(endTime)
        
        // 2. 일시정시 시간 초기화
        TimerManager.shared.pausedTime = 0
        
        // MARK: - 실제 동작 코드
//        // 3. 트래킹 보드 블럭 리스트 추가
//        let focusBlock = initialStartTime / targetSecond
//        let hour = String(focusBlock / 2)
//        let minute = focusBlock % 2 == 0 ? "00" : "30"
//        let time = "\(hour):\(minute)"
//        
//        // 3-1. 중복 블럭 거르고 추가하기
//        if !currentTrackingBlocks.contains(time) {
//            currentTrackingBlocks.append(time)
//        }
        
        
        
        // MARK: - 테스트 코드
        // 몇번째 트래킹 블럭 활성화 할지 결정하기
         let count = Int(TimerManager.shared.totalBlock / 0.5)
        if !currentTrackingBlocks.contains(testTrackingBoardDatas[count]) {
            currentTrackingBlocks.append(testTrackingBoardDatas[count])
        }
        
        
        
        // 4. 새로운 세션 시작
        let trackingTime = TrackingTime(context: context)
        trackingTime.startTime = String(endTime)
        focusDate().addToTrackingTimeList(trackingTime)
        
        // 5. 코어데이터 저장
        groupData.saveContext()
    }
    
    /// 앱이 종료되어있을 동안 추가된 트래킹 데이터를 추가합니다.
    func appedDataBetweenAppDisconect() {
        
        // 1. 현재 트래킹 중인 세션의 마지막 시간 = 시작 시간 + 한 세션의 시간
        let initialStartTime = Int(focusTime().startTime)!
        let endTime = initialStartTime + targetSecond
        focusTime().endTime = String(endTime)
        
        // 2. 새로운 세션 시작
        let trackingTime = TrackingTime(context: context)
        trackingTime.startTime = String(endTime)
        focusDate().addToTrackingTimeList(trackingTime)
        
        // 3. 코어데이터 저장
        groupData.saveContext()
    }
    
    /// 트래킹을 종료함과 동시에 데이터를 저장합니다.
    func finishData() {
        
        // 현재 세션 종료(삭제)
        focusDate().removeFromTrackingTimeList(focusTime())
        
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

// MARK: - Tracking Board Blocks Method
extension TrackingDataStore {
    
    /// 현재 트래킹 되고 있는 블럭 리스트를 반환합니다.
    func trackingBlocks() -> [String] {
        // return testData
        return currentTrackingBlocks
    }
    
    /// 트래킹 완료된 시점의 블럭 리스트를 반환합니다
    func finishTrackingBlocks() -> [String] {
        var blocks = currentTrackingBlocks
        blocks.removeLast()
        return blocks
    }
    
    /// 현재 시간에 맞는 블럭을 트래킹 블럭리스트에 추가합니다.
    ///
    /// 트래킹이 시작될 때 1번 호출,
    /// 블럭 0.5개가 생산될 때마다 1번씩 호출
    func appendCurrentTimeInTrackingBlocks() {
        
        if let safeTodaySeconds = Int(todaySecondsToString()) {
            let focusBlock = safeTodaySeconds / targetSecond
            let hour = String(focusBlock / 2)
 
            let minute = focusBlock % 2 == 0 ? "00" : "30"
            let time = "\(hour):\(minute)"
            
            // 중복 블럭 거르기
            if !currentTrackingBlocks.contains(time) {
                currentTrackingBlocks.append(time)
            }
            
            print("트래킹 데이터 추가: \(time)")
        }
    }
    
    /// 앱이 종료된 후, 새로 시작할 때 focusDate를 이용해 새로운 currentTrackingBlocks 배열을 생성합니다.
    func regenerationTrackingBlocks() {
        guard let timeList = focusDate().trackingTimeList?.array as? [TrackingTime] else {
            fatalError("시간 리스트 반환 실패")
        }
        
        for time in timeList {
            
            // 마무리 시간 기록 안됐으면 삭제
            // guard let _ = time.endTime else { break }
            
            let targetNumber = Int(time.startTime)! / targetSecond
            var hour = ""
            var minute = ""
            
            // 시간 계산
            
            // 만약 10보다 작다면 앞에 0 붙이기
            if (targetNumber / 2) < 10 {
                hour = "\(targetNumber / 2)"
            } else {
                hour = "\(targetNumber / 2)"
            }
            
            // 분 계산
            if targetNumber % 2 == 0 {
                minute = "00"
            } else {
                minute = "30"
            }
            
            let time = "\(hour):\(minute)"
            if !currentTrackingBlocks.contains(time) {
                currentTrackingBlocks.append(time)
            }
        }
    }
    
    /// 현재 트래킹 되고 있는 블럭 리스트를 초기화합니다.
    func resetTrackingBlocks() {
        currentTrackingBlocks.removeAll()
        print("트래킹 블럭 리셋: \(currentTrackingBlocks)")
    }
}

// MARK: - Test Method
extension TrackingDataStore {
    
    /// 테스트 변수 추가
    func testAppendForBackground() {
        
        // 몇번째 트래킹 블럭 활성화 할지 결정하기
        let count = Int(TimerManager.shared.totalBlock / 0.5)
        
        if !currentTrackingBlocks.contains(testTrackingBoardDatas[count]) {
            currentTrackingBlocks.append(testTrackingBoardDatas[count])
        }
    }
    
    func testAppendForDisconnect() {
        guard let timeList = focusDate().trackingTimeList?.array as? [TrackingTime] else {
            fatalError("시간 리스트 반환 실패")
        }
        
        for index in 0..<timeList.count {
            if !currentTrackingBlocks.contains(testTrackingBoardDatas[index]) {
                currentTrackingBlocks.append(testTrackingBoardDatas[index])
            }
        }
    }
}
