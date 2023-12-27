//
//  TrackingBoardService.swift
//  DayBlock
//
//  Created by 김민준 on 12/27/23.
//

import UIKit

final class TrackingBoardService {
    
    /// 싱글톤
    static let shared = TrackingBoardService()
    private init() {}
    
    /// 트래킹 보드 아이템 배열
    private var infos = Array(repeating: TrackingBoardBlockInfo(), count: 48)
    
    // MARK: - Helper
    
    /// 트래킹 아이템 배열 계산 속성
    var infoItems: [TrackingBoardBlockInfo] {
        return infos
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
}
