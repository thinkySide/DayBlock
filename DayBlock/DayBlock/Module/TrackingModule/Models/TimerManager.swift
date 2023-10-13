//
//  TimerManager.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/31.
//

import Foundation

/// 블럭 트래킹 매니저
final class TimerManager {
    
    // MARK: - Properties
    
    /// 싱글톤
    static let shared = TimerManager()
    private init() {}
    
    /// 트래킹 데이터
    private let trackingData = TrackingDataStore.shared
    
    /// 날짜 타이머
    var dateTimer: Timer!
    
    /// 트래킹 타이머
    var trackingTimer: Timer?
    
    /// 일시정지 타이머
    var pausedTimer: Timer!

    /// 타이머 전체 시간
    var totalTime = 0
    
    /// 현재 생산 블럭 시간 (30초 기준)
    var currentTime: Float = 0
    
    /// 총 생산한 블럭 수량
    var totalBlock: Double = 0
    
    /// 일시정지 된 시간
    var pausedTime = 0

    /// 타이머에 사용되는 포맷
    var format: String {
        let hour = totalTime / 3600
        let minute = (totalTime - (hour * 3600)) / 60
        let second = (totalTime - (hour * 3600)) - (minute * 60)
        return String(format: "%02d:%02d:%02d", hour, minute, second)
    }
}

// MARK: - Method
extension TimerManager {
    
    /// Progress 퍼센트 수치를 반환합니다.
    func progressPercent() -> Float {
        return currentTime / Float(trackingData.targetSecond)
    }
    
    /// 타이머를 기본값(0)으로 초기화합니다.
    func reset() {
        totalTime = 0
        currentTime = 0
        totalBlock = 0
    }
}
