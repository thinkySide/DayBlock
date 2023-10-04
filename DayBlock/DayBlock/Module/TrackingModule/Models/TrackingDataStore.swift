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
    private var currentTrackingBlocks: [String] = []
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
    
    /// 오늘 날짜가 00:00분을 기준으로 몇 초가 경과되었는지 반환합니다.
    func todaySeconds() -> String {
        let currentTime = formatter("HH/mm/ss")
        let timeArray = currentTime.components(separatedBy: "/")
        
        guard let hour = Int(timeArray[0]),
              let minute = Int(timeArray[1]),
              let second = Int(timeArray[2]) else { return "" }
        
        return String((hour * 3600) + (minute * 60) + second)
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
        
        print("Error: focusTime 반환 실패")
        return TrackingTime()
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
            return "Error"
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
        newTrackingTime.startTime = todaySeconds()
        
        // 3. 트래킹 데이터 업데이트 및 저장
        newTrackingDate.addToTrackingTimeList(newTrackingTime)
        blockData.focusEntity().addToTrackingDateList(newTrackingDate)
        groupData.saveContext()
    }
    
    /// 블럭 0.5개를 생산할 때마다 추가하는 새로운 trackingTime 데이터
    func appendDataInProgress() {
        
        // 현재 세션 종료 및 저장
        focusTime().endTime = todaySeconds()
        
        // 새로운 세션 시작
        let trackingTime = TrackingTime(context: context)
        trackingTime.startTime = todaySeconds()
        focusDate().addToTrackingTimeList(trackingTime)
        
        // 코어데이터 저장
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

// MARK: - Tracking Preview Blocks Method
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
        if let safeTodaySeconds = Int(todaySeconds()) {
            let focusBlock = safeTodaySeconds / 1800
            let hour = String(focusBlock / 2)
            let minute = focusBlock % 2 == 0 ? "00" : "30"
            let time = "\(hour):\(minute)"
            
            // 중복 블럭 거르기
            if !currentTrackingBlocks.contains(time) {
                currentTrackingBlocks.append(time)
            }
            
            print("트래킹 데이터 추가: \(time)")
            print("추가 후 currentTrackingBlocks: \(currentTrackingBlocks)")
        }
    }
    
    /// 현재 트래킹 되고 있는 블럭 리스트를 초기화합니다.
    func resetTrackingBlocks() {
        currentTrackingBlocks.removeAll()
    }
}
