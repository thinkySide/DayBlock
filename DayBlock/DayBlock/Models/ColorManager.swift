//
//  ColorManager.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/23.
//

import UIKit

final class ColorManager {
    
    /// 싱글톤
    static let shared = ColorManager()
    private init() {}
    
    private var index = 38 /// 기본값 BLUE
    
    private let colorList: [UIColor] = [
        /// Pink
        UIColor(rgb: 0xEE719E),
        UIColor(rgb: 0xE63B7A),
        UIColor(rgb: 0xB92D5D),
        UIColor(rgb: 0x99244F),
        UIColor(rgb: 0x791A3D),
        
        /// Red
        UIColor(rgb: 0xFF8C82),
        UIColor(rgb: 0xFE6250),
        UIColor(rgb: 0xFE6250),
        UIColor(rgb: 0xE22400),
        UIColor(rgb: 0xB51A00),
        
        /// Orange
        UIColor(rgb: 0xFEA57D),
        UIColor(rgb: 0xFE8648),
        UIColor(rgb: 0xFF6A00),
        UIColor(rgb: 0xDA5100),
        UIColor(rgb: 0xAD3E00),
        
        /// Yellow
        UIColor(rgb: 0xFED977),
        UIColor(rgb: 0xFECB3E),
        UIColor(rgb: 0xFCC700),
        UIColor(rgb: 0xD19D01),
        UIColor(rgb: 0xA67B01),
        
        /// Yellowish-Green
        UIColor(rgb: 0xEAF28F),
        UIColor(rgb: 0xE4EF65),
        UIColor(rgb: 0xD9EC37),
        UIColor(rgb: 0xC3D117),
        UIColor(rgb: 0x9BA50E),
        
        /// Green
        UIColor(rgb: 0xB1DD8B),
        UIColor(rgb: 0x96D35F),
        UIColor(rgb: 0x76BB40),
        UIColor(rgb: 0x669D34),
        UIColor(rgb: 0x4E7A27),
        
        /// SkyBlue
        UIColor(rgb: 0x52D6FC),
        UIColor(rgb: 0x01C7FC),
        UIColor(rgb: 0x00A1D8),
        UIColor(rgb: 0x008CB4),
        UIColor(rgb: 0x008CB4),
        
        /// Blue
        UIColor(rgb: 0x74A7FF),
        UIColor(rgb: 0x3A87FD),
        UIColor(rgb: 0x0061FD),
        UIColor(rgb: 0x0056D6),
        UIColor(rgb: 0x0042A9),
        
        /// Navy
        UIColor(rgb: 0x864FFD),
        UIColor(rgb: 0x5E30EB),
        UIColor(rgb: 0x4D22B2),
        UIColor(rgb: 0x371A94),
        UIColor(rgb: 0x2C0977),
        
        /// Purple
        UIColor(rgb: 0xD357FE),
        UIColor(rgb: 0xBE38F3),
        UIColor(rgb: 0x982ABC),
        UIColor(rgb: 0x7A219E),
        UIColor(rgb: 0x61187C),
    ]
    
    
    
    // MARK: - Method
    
    func getColorList() -> [UIColor] {
        return colorList
    }
    
    func getSelectColor() -> UIColor {
        return colorList[index]
    }
    
    func getIndex() -> Int {
        return index
    }
    
    func updateIndex(to index: Int) {
        self.index = index
    }
}
