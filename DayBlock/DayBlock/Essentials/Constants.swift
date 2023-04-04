//
//  Constants.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/01.
//

import UIKit

// MARK: - Colors

enum GrayScale {
    
    /// Text Color
    static let mainText = UIColor(rgb: 0x323232)
    static let subText = UIColor(rgb: 0x5B5B5B)
    
    /// Block Background Color
    static let entireBlock = UIColor(rgb: 0xE8E8E8)
    static let contentsBlock = UIColor(rgb: 0xF4F5F7)
}



// MARK: - Fonts

enum Pretendard {
    static let thin = "Pretendard-Thin"
    static let extraLight = "Pretendard-ExtraLight"
    static let light = "Pretendard-Light"
    static let regular = "Pretendard-Regular"
    static let medium = "Pretendard-Medium"
    static let semiBold = "Pretendard-SemiBold"
    static let bold = "Pretendard-Bold"
    static let extraBold = "Pretendard-ExtraBold"
    static let black = "Pretendard-Black"
}

enum Poppins {
    static let bold = "Poppins-Bold"
}



// MARK: - Icon

enum Icon {
    static let home = "home"
    static let schedule = "schedule"
    static let storage = "storage"
    static let trackingStartButton = "trackingStartButton"
}



// MARK: - Size

enum Size {
    static let margin: CGFloat = 20
    static let blockSize = CGSize(width: 180, height: 180)
    static let blockSpacing: CGFloat = 32
}



// MARK: - Cell

enum Cell {
    static let block = "BlockCell"
}
