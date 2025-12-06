//
//  UIScreen++.swift
//  DayBlock
//
//  Created by 김민준 on 1/5/24.
//

import UIKit

extension UIScreen {
    
    /// 스크린 사이즈 열거형
    enum ScreenSize {
        case small // 아이폰 SE 3세대(667)
        case middle // 아이폰 13 미니(812), 아이폰 15(852), 아이폰 15 Pro(852)
        case large// 아이폰 15 Plus, 아이폰 15 Pro Max(932)
    }
    
    /// 디바이스 높이를 계산해 스크린 사이즈를 결정합니다.
    var deviceHeight: ScreenSize {
        
        let height = self.bounds.size.height
        
        // small인 경우
        switch height {
        case 667...736: return .small
        case 812...852: return .middle
        case 896...932: return .large
        default: return .middle
        }
    }
}
