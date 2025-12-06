//
//  TrackingBoardBlockInfo.swift
//  DayBlock
//
//  Created by 김민준 on 12/27/23.
//

import UIKit

struct TrackingBoardBlockInfo {
    
    /// 보드 색상
    var color: UIColor
    
    /// 애니메이션 되고 있는지 여부
    var isAnimated: Bool
    
    /// 이니셜라이져
    init(
        color: UIColor = Color.entireBlock,
        isAnimated: Bool = false
    ) {
        self.color = color
        self.isAnimated = isAnimated
    }
}
