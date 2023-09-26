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
    
    /// 타이머 매니저
    private let timerManager = TimerManager.shared
    
    /// 트래킹 날짜 엔티티
    var dateList: [TrackingDate] {
        if let entity = blockData.focusEntity().trackingDateList?.array as? [TrackingDate] {
            return entity
        }
        
        fatalError("Error: trackingDateList Entity 반환 실패")
    }
    
    /// 트래킹 시간 엔티티
    var timeList: [TrackingTime] {
        if let entity = focusDate().trackingTimeList?.array as? [TrackingTime] {
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
}

// MARK: - CRUD Method
extension TrackingDataStore {
    
    /// 현재 포커스된(트래킹 중인) 날짜 데이터를 반환합니다.
    /// ⚠️ 트래킹 날짜 데이터의 가장 마지막 데이터를 트래킹 중인 것으로 간주
    func focusDate() -> TrackingDate {
        if let lastDate = dateList.last {
            return lastDate
        }
        
        print("Error: focusDate 반환 실패")
        return TrackingDate()
    }
    
    /// 트래킹 시작 데이터를 생성합니다.
    func createStartData() {
        
        // 1. 현재 날짜를 기준으로 트래킹 날짜 엔티티 생성
        let newTrackingDate = TrackingDate(context: context)
        newTrackingDate.year = formatter("yyyy년")
        newTrackingDate.month = formatter("MM월")
        newTrackingDate.day = formatter("dd일")
        newTrackingDate.dayOfWeek = formatter("E요일")
        
        // 2. 현재 시작 시간을 기준으로 트래킹 시간 엔티티 생성
        let newTrackingTime = TrackingTime(context: context)
        newTrackingTime.startTime = todaySeconds()
        
        // 3. 트래킹 데이터 업데이트 및 저장
        newTrackingDate.addToTrackingTimeList(newTrackingTime)
        blockData.focusEntity().addToTrackingDateList(newTrackingDate)
        groupData.saveContext()
    }
}

// MARK: - Tracking Blocks Method
extension TrackingDataStore {
    
    /// 현재 트래킹 되고 있는 블럭 리스트를 반환합니다.
    func trackingBlocks() -> [String] {
        return currentTrackingBlocks
    }
    
    /// 현재 시간에 맞는 블럭을 트래킹 블럭리스트에 추가합니다.
    func appendCurrentTimeInTrackingBlocks() {
        if let safeTodaySeconds = Int(todaySeconds()) {
            let focusBlock = safeTodaySeconds / 1800
            let hour = String(focusBlock / 2)
            let minute = focusBlock % 2 == 0 ? "00" : "30"
            currentTrackingBlocks.append("\(hour):\(minute)")
        }
    }
    
    /// 현재 트래킹 되고 있는 블럭 리스트를 초기화합니다.
    func resetTrackingBlocks() {
        currentTrackingBlocks.removeAll()
    }
}
