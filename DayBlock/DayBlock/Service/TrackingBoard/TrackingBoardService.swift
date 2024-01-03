//
//  TrackingBoardService.swift
//  DayBlock
//
//  Created by 김민준 on 12/27/23.
//

import UIKit

final class TrackingBoardService {
    
    // MARK: - Properties
    
    /// 싱글톤
    static let shared = TrackingBoardService()
    private init() {}
    
    /// 트래킹 보드 아이템 배열
    private var infos = Array(repeating: TrackingBoardBlockInfo(), count: 48)
    
    /// 트래킹되고 있는 시간초 배열
    private var trackings: [Int] = []
    
    
    // MARK: - Infos
    
    /// 트래킹 아이템 배열 계산 속성
    var infoItems: [TrackingBoardBlockInfo] {
        return infos
    }
    
    /// 트래킹 보드를 위한 모든 정보를 업데이트합니다.
    func updateAllInfo(time: Int, color: UIColor, isAnimated: Bool) {
        self.appendTrackingSecond(to: time)
        self.updateColor(to: time, color: color)
        self.updateAnimated(to: time, isAnimated: isAnimated)
    }
    
    /// 컬러를 업데이트 합니다.
    func updateColor(to time: Int, color: UIColor) {
        let index = time / 1800
        infos[index].color = color
    }
    
    /// 애니메이션 여부를 업데이트합니다.
    func updateAnimated(to time: Int, isAnimated: Bool) {
        let index = time / 1800
        infos[index].isAnimated = isAnimated
    }
    
    /// 모든 애니메이션을 종료합니다.
    func stopAllAnimation() {
        for index in infos.indices {
            infos[index].isAnimated = false
        }
    }
    
    /// 트래킹 아이템 배열을 초기화합니다.
    func resetInfoItems() {
        infos = Array(repeating: TrackingBoardBlockInfo(), count: 48)
    }
    
    
    // MARK: - Trackings
    
    /// 트래킹 되고 있는 시간초 계산 속성
    var trackingSeconds: [Int] {
        return trackings
    }
    
    /// 트래킹 시간을 추가합니다.
    func appendTrackingSecond(to time: Int) {
        if !trackings.contains(time) {
            trackings.append(time)
        }
        print("트래킹 시간을 추가합니다. \(time) -> \(trackings)")
    }
    
    /// 마지막 트래킹 요소를 삭제합니다.
    func removeLastTrackingSecond() {
        trackings.removeLast()
    }
    
    /// 트래킹 시간 배열을 교체합니다.
    func replaceTrackingSeconds(to times: [Int]) {
        trackings = times
    }
    
    /// 지정한 날짜에 맞게 트래킹 보드 데이터를 업데이트합니다.
    func updateTrackingBoard(to date: Date) {
        
        // MARK: - 1. 코어 데이터 받아오기
        
        // 모든 데이터 초기화
        resetInfoItems()
        
        // 1. 그룹 반복
        for group in GroupDataStore.shared.list() {
            guard let blockList = group.blockList?.array as? [Block] else {
                fatalError("블럭 리스트 반환 실패")
            }
            
            // 2. 블럭 반복
            for block in blockList {
                guard let dateList = block.trackingDateList?.array as? [TrackingDate] else {
                    fatalError("날짜 리스트 반환 실패")
                }
                
                // 지정한 날짜 리스트
                let todayDateList = dateList.filter {
                    $0.year == TrackingDataStore.shared.formatter("yyyy", to: date) &&
                    $0.month == TrackingDataStore.shared.formatter("MM", to: date) &&
                    $0.day == TrackingDataStore.shared.formatter("dd", to: date)
                }
                
                // 3. 날짜 반복
                for date in todayDateList {
                    guard let timeList = date.trackingTimeList?.array as? [TrackingTime] else {
                        fatalError("시간 리스트 반환 실패")
                    }
                    
                    // 4. 시간 반복
                    for time in timeList {
                        guard let _ = time.endTime,
                              let startTime = Int(time.startTime) else { break }
                        updateColor(to: startTime, color: group.color.uicolor)
                    }
                }
            }
        }
        
        // MARK: - 2. trackingSeconds 업데이트하기
        for second in trackingSeconds {
            self.updateColor(to: second, color: GroupDataStore.shared.focusColor())
            self.updateAnimated(to: second, isAnimated: true)
        }
    }
    
    /// 지정한 날짜와 블럭에 맞게 트래킹 데이터를 업데이트합니다.
    func updateTrackingBoard(to date: Date, block: Block, trackingTimes: [Int]) {
        
        // 데이터 리셋
        resetAllData()
        
        guard let dateList = block.trackingDateList?.array as? [TrackingDate] else {
            fatalError("TrackingDate 반환에 실패했습니다.")
        }
        
        // 지정한 날짜 리스트
        let todayDateList = dateList.filter {
            $0.year == TrackingDataStore.shared.formatter("yyyy", to: date) &&
            $0.month == TrackingDataStore.shared.formatter("MM", to: date) &&
            $0.day == TrackingDataStore.shared.formatter("dd", to: date)
        }
        
        // 날짜 반복
        for date in todayDateList {
            guard let timeList = date.trackingTimeList?.array as? [TrackingTime] else {
                fatalError("시간 리스트 반환 실패")
            }
            
            // 4. 시간 반복
            for time in timeList {
                guard let _ = time.endTime,
                      let startTime = Int(time.startTime) else { break }
                
                // 트래킹 타임에 포함되어 있을 때만 컬러 업데이트
                if trackingTimes.contains(startTime) {
                    let color = block.superGroup.color
                    updateColor(to: startTime, color: color.uicolor)
                }
            }
        }
    }
    
    /// 모든 데이터셋을 초기화합니다.
    func resetAllData() {
        
        // infos 초기화
        infos = Array(repeating: TrackingBoardBlockInfo(), count: 48)
        
        // trackings 초기화
        trackings.removeAll()
    }
    
    /// 트래킹 시간을 초기화합니다.
    func resetTrackingSeconds() {
        
        // trackings 배열 순회하며 infos 초기화
        for second in trackings {
            self.updateColor(to: second, color: Color.entireBlock)
            self.updateAnimated(to: second, isAnimated: false)
        }
        
        // 전체 초기화
        trackings.removeAll()
    }
}
