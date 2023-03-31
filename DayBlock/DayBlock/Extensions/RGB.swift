//
//  RGB.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/01.
//

import UIKit

extension UIColor {
    
    // HEX 코드로 Color 생성하기
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
}
