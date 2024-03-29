//
//  NameSpace.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/01.
//

import UIKit

// MARK: - Noti

enum Version {
    static let current = "1.0.1"
}

// MARK: - Colors

enum Color {

    /// Text Color
    static let mainText = UIColor(rgb: 0x323232)
    static let subText = UIColor(rgb: 0x616161)
    static let subText2 = UIColor(rgb: 0x828282)
    static let countText = UIColor(rgb: 0x676767)
    static let disabledText = UIColor(rgb: 0xB2B5BD)

    /// Block Background Color
    static let entireBlock = UIColor(rgb: 0xE8E8E8)
    static let contentsBlock = UIColor(rgb: 0xF4F5F7)

    /// Component Color
    static let seperator = UIColor(rgb: 0xE8E8E8)
    static let seperator2 = UIColor(rgb: 0xDADADA)
    static let addBlockButton = UIColor(rgb: 0xC5C5C5)
    static let cancelButton = UIColor(rgb: 0xF3F3F3)
    
    /// EventColor
    static let danger = UIColor(rgb: 0xD23939)
    
    static let defaultBlue = UIColor(rgb: 0x1673FF)
    static let defaultPink = UIColor(rgb: 0xFF16A2)
    static let defaultGreen = UIColor(rgb: 0x43D662)
    static let defaultYellow = UIColor(rgb: 0xFFA216)
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
    static let semiBold = "Poppins-SemiBold"
}

// MARK: - Icon

enum Icon {
    static let home = "home"
    static let schedule = "schedule"
    static let storage = "storage"
    static let myPage = "myPage"
    
    static let trackingStart = "trackingStartButton"
    static let trackingPause = "trackingPauseButton"
    static let trackingStop = "trackingStopBarButtonItem"
    static let help = "helpBarButtonItem"
    static let menuIcon = "menuIcon"
    static let selectIcon = "selectIcon"
}

enum StartImage {
    static let startImage = "StartImage"
    static let appIconSVG = "AppIconSVG"
}

enum OnboardingImage {
    static let first = "FirstOnboardingContent"
    static let second = "SecondOnboardingContent"
    static let third = "ThirdOnboardingContent"
}

// MARK: - Size

enum Size {
    static let margin: CGFloat = 20
    static let blockSize = CGSize(width: 180, height: 180)
    static let blockSpacing: CGFloat = 32
    static let seperator: CGFloat = 1
    static let selectFormSpacing: CGFloat = 24
}

// MARK: - Cell

enum Cell {
    static let block = "BlockCell"
    static let groupSelect = "GroupSelectTableViewCell"
    static let colorSelect = "ColorCollectionViewSelectCell"
    static let iconSelect = "IconCollectionViewCell"
}
