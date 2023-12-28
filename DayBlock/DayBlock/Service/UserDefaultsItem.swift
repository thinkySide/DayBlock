//
//  UserDefaultsItem.swift
//  DayBlock
//
//  Created by 김민준 on 12/27/23.
//

import Foundation

final class UserDefaultsItem {
    
    /// 싱글톤
    static let shared = UserDefaultsItem()
    private init() {}
    
    /// UserDefaults 키 저장용
    private enum UserDefaultsKey {
        
        // 인덱스
        static let groupIndex = "groupIndex"
        static let blockIndex = "blockIndex"
        
        // 트래킹 확인용
        static let isFirstLaunch = "isFirstLaunch"
        static let isTracking = "isTracking"
        static let isPaused = "isPause"
        
        // 시간 초
        static let trackingSecondBeforeAppTermination = "trackingSecondBeforeAppTermination"
        static let latestAccessSecond = "latestAccessSecond"
        static let pausedSecond = "pausedSecond"
        
        // 날짜
        static let lastAccessDate = "lastAccessDate"
        
        // 트래킹 데이터
        static let trackingSeconds = "trackingSeconds"
    }
    
    // MARK: - Get UserDefaults
    
    /// 현재 그룹 인덱스를 저장하는 변수
    var groupIndex: Int {
        UserDefaults.standard.object(forKey: UserDefaultsKey.groupIndex) as? Int ?? 0
    }
    
    /// 현재 블럭 인덱스를 저장하는 변수
    var blockIndex: Int {
        UserDefaults.standard.object(forKey: UserDefaultsKey.blockIndex) as? Int ?? 0
    }
    
    /// APP이 최초 실행되었는지 확인용 변수
    var isFirstLaunch: Bool {
        UserDefaults.standard.object(forKey: UserDefaultsKey.isFirstLaunch) as? Bool ?? true
    }
    
    /// 트래킹중이었는지 확인용 변수
    var isTracking: Bool {
        UserDefaults.standard.object(forKey: UserDefaultsKey.isTracking) as? Bool ?? false
    }
    
    /// 트래킹이 일시정지되었었는지 확인용 변수
    var isPaused: Bool {
        UserDefaults.standard.object(forKey: UserDefaultsKey.isPaused) as? Bool ?? false
    }
    
    /// 마지막으로 접속했던 시간 초를 저장하는 변수
    var lastAccessSecond: Int {
        UserDefaults.standard.object(forKey: UserDefaultsKey.latestAccessSecond) as? Int ?? 0
    }
    
    /// 앱 종료 전 기존 트래킹 시간 초를 저장하는 변수
    var trackingSecondBeforeAppTermination: Int {
        UserDefaults.standard.object(forKey: UserDefaultsKey.trackingSecondBeforeAppTermination) as? Int ?? 0
    }
    
    /// 마지막 접속 날짜를 저장하는 변수
    var lastAccessDate: Date {
        UserDefaults.standard.object(forKey: UserDefaultsKey.lastAccessDate) as? Date ?? Date()
    }
    
    /// 마지막으로 트래킹 중이던 시간 초 데이터를 받아옵니다.
    var trackingSeconds: [Int] {
        UserDefaults.standard.object(forKey: UserDefaultsKey.trackingSeconds) as? [Int] ?? []
    }
    
    // MARK: - Set UserDefaults
    
    /// 그룹 인덱스를 저장합니다.
    func setGroupIndex(to index: Int) {
        UserDefaults.standard.set(index, forKey: UserDefaultsKey.groupIndex)
    }
    
    /// 블럭 인덱스를 저장합니다.
    func setBlockIndex(to index: Int) {
        UserDefaults.standard.set(index, forKey: UserDefaultsKey.blockIndex)
    }
    
    /// APP이 최초로 실행되었는지 확인하는 변수를 저장합니다.
    func setIsFirstLaunch(to bool: Bool) {
        UserDefaults.standard.set(bool, forKey: UserDefaultsKey.isFirstLaunch)
    }
    
    /// APP이 최초로 실행되었는지 확인하는 변수를 저장합니다.
    func setIsTracking(to bool: Bool) {
        UserDefaults.standard.set(bool, forKey: UserDefaultsKey.isTracking)
    }
    
    /// APP이 최초로 실행되었는지 확인하는 변수를 저장합니다.
    func setIsPaused(to bool: Bool) {
        UserDefaults.standard.set(bool, forKey: UserDefaultsKey.isPaused)
    }
    
    /// 마지막으로 접속했던 시간 초를 저장합니다.
    func setLastAccessSecond(to second: Int) {
        UserDefaults.standard.set(second, forKey: UserDefaultsKey.latestAccessSecond)
    }
    
    /// 앱 종료 전 트래킹 시간 초를 저장합니다.
    func setTrackingSecondBeforeAppTermination(to second: Int) {
        UserDefaults.standard.set(second, forKey: UserDefaultsKey.trackingSecondBeforeAppTermination)
    }
    
    /// 트래킹이 일시정지 된 시간 초를 젖아합니다.
    func setPausedSecond(to second: Int) {
        UserDefaults.standard.set(second, forKey: UserDefaultsKey.pausedSecond)
    }
    
    /// 마지막으로 접속했던 날짜를 저장합니다.
    func setLastAccessDate(to date: Date) {
        UserDefaults.standard.set(date, forKey: UserDefaultsKey.lastAccessDate)
    }
    
    /// 마지막으로 접속했던 날짜를 저장합니다.
    func setTrackingSeconds(to seconds: [Int]) {
        UserDefaults.standard.set(seconds, forKey: UserDefaultsKey.trackingSeconds)
    }
}
