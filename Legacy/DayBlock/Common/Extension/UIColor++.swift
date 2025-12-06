//
//  UIColor++.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/01.
//

import UIKit

extension UIColor {

    /// 16진수를 이용한 UIColor를 생성합니다.
    ///
    /// - Parameter red, green, blue: 0~255 사이의 각 컬러 정수값
    /// - Parameter alpha: 투명도(기본값: 1)
    convenience init(red: Int, green: Int, blue: Int, alpha: Int = 0xFF) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(alpha) / 255.0
        )
    }

    /// 16진수를 이용한 UIColor를 생성합니다.
    ///
    /// - Parameter rgb: 16진수(ex: 0x323232)
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
