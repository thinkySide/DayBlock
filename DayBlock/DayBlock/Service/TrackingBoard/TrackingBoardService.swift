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
    }
    
    /// 모든 데이터셋을 초기화합니다.
    func resetAllData() {
        
        // infos 초기화
        infos = Array(repeating: TrackingBoardBlockInfo(), count: 48)
        
        // trackings 초기화
        trackings.removeAll()
    }
    
    /// 트래킹 시간을 초기화합니다.
    func resetTrackingSecods() {
        
        // trackings 배열 순회하며 infos 초기화
        for second in trackings {
            self.updateColor(to: second, color: Color.entireBlock)
            self.updateAnimated(to: second, isAnimated: false)
        }
        
        // 전체 초기화
        trackings.removeAll()
    }
}
