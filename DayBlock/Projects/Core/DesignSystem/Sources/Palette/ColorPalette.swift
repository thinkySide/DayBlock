//
//  ColorPalette.swift
//  DesignSystem
//
//  Created by 김민준 on 12/26/25.
//

import SwiftUI

public enum ColorPalette {
    
    /// 컬러 인덱스에 일치하는 컬러를 반환합니다.
    public static func toColor(from index: Int) -> Color {
        guard index < colors.count else {
            return DesignSystem.ColorPalette.grayscaleBlock5.swiftUIColor
        }
        return colors[index]
    }
    
    /// 선택 가능한 컬러 팔레트 배열을 반환합니다.
    public static let colors: [Color] = [
        DesignSystem.ColorPalette.grayscaleBlock1.swiftUIColor,
        DesignSystem.ColorPalette.grayscaleBlock2.swiftUIColor,
        DesignSystem.ColorPalette.grayscaleBlock3.swiftUIColor,
        DesignSystem.ColorPalette.grayscaleBlock4.swiftUIColor,
        DesignSystem.ColorPalette.grayscaleBlock5.swiftUIColor,
        
        DesignSystem.ColorPalette.pinkBlock1.swiftUIColor,
        DesignSystem.ColorPalette.pinkBlock2.swiftUIColor,
        DesignSystem.ColorPalette.pinkBlock3.swiftUIColor,
        DesignSystem.ColorPalette.pinkBlock4.swiftUIColor,
        DesignSystem.ColorPalette.pinkBlock5.swiftUIColor,
        
        DesignSystem.ColorPalette.redBlock1.swiftUIColor,
        DesignSystem.ColorPalette.redBlock2.swiftUIColor,
        DesignSystem.ColorPalette.redBlock3.swiftUIColor,
        DesignSystem.ColorPalette.redBlock4.swiftUIColor,
        DesignSystem.ColorPalette.redBlock5.swiftUIColor,
        
        DesignSystem.ColorPalette.orangeBlock1.swiftUIColor,
        DesignSystem.ColorPalette.orangeBlock2.swiftUIColor,
        DesignSystem.ColorPalette.orangeBlock3.swiftUIColor,
        DesignSystem.ColorPalette.orangeBlock4.swiftUIColor,
        DesignSystem.ColorPalette.orangeBlock5.swiftUIColor,
        
        DesignSystem.ColorPalette.yellowBlock1.swiftUIColor,
        DesignSystem.ColorPalette.yellowBlock2.swiftUIColor,
        DesignSystem.ColorPalette.yellowBlock3.swiftUIColor,
        DesignSystem.ColorPalette.yellowBlock4.swiftUIColor,
        DesignSystem.ColorPalette.yellowBlock5.swiftUIColor,
        
        DesignSystem.ColorPalette.limeBlock1.swiftUIColor,
        DesignSystem.ColorPalette.limeBlock2.swiftUIColor,
        DesignSystem.ColorPalette.limeBlock3.swiftUIColor,
        DesignSystem.ColorPalette.limeBlock4.swiftUIColor,
        DesignSystem.ColorPalette.limeBlock5.swiftUIColor,
        
        DesignSystem.ColorPalette.greenBlock1.swiftUIColor,
        DesignSystem.ColorPalette.greenBlock2.swiftUIColor,
        DesignSystem.ColorPalette.greenBlock3.swiftUIColor,
        DesignSystem.ColorPalette.greenBlock4.swiftUIColor,
        DesignSystem.ColorPalette.greenBlock5.swiftUIColor,
        
        DesignSystem.ColorPalette.skyblueBlock1.swiftUIColor,
        DesignSystem.ColorPalette.skyblueBlock2.swiftUIColor,
        DesignSystem.ColorPalette.skyblueBlock3.swiftUIColor,
        DesignSystem.ColorPalette.skyblueBlock4.swiftUIColor,
        DesignSystem.ColorPalette.skyblueBlock5.swiftUIColor,
        
        DesignSystem.ColorPalette.blueBlock1.swiftUIColor,
        DesignSystem.ColorPalette.blueBlock2.swiftUIColor,
        DesignSystem.ColorPalette.blueBlock3.swiftUIColor,
        DesignSystem.ColorPalette.blueBlock4.swiftUIColor,
        DesignSystem.ColorPalette.blueBlock5.swiftUIColor,
        
        DesignSystem.ColorPalette.navyBlock1.swiftUIColor,
        DesignSystem.ColorPalette.navyBlock2.swiftUIColor,
        DesignSystem.ColorPalette.navyBlock3.swiftUIColor,
        DesignSystem.ColorPalette.navyBlock4.swiftUIColor,
        DesignSystem.ColorPalette.navyBlock5.swiftUIColor,
        
        DesignSystem.ColorPalette.purpleBlock1.swiftUIColor,
        DesignSystem.ColorPalette.purpleBlock2.swiftUIColor,
        DesignSystem.ColorPalette.purpleBlock3.swiftUIColor,
        DesignSystem.ColorPalette.purpleBlock4.swiftUIColor,
        DesignSystem.ColorPalette.purpleBlock5.swiftUIColor
    ]
}
