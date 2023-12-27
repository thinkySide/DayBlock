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
    
    private var currentIndex = 38 /// 기본값 BLUE
    
    private let colorList: [Int] = [
        
        /// Pink
        0xEE719E,
        0xE63B7A,
        0xB92D5D,
        0x99244F,
        0x791A3D,
        
        /// Red
       0xFF8C82,
       0xFE6250,
       0xFE6250,
       0xE22400,
       0xB51A00,
        
        /// Orange
        0xFEA57D,
        0xFE8648,
        0xFF6A00,
        0xDA5100,
        0xAD3E00,
        
        /// Yellow
       0xFED977,
       0xFECB3E,
       0xFCC700,
       0xD19D01,
       0xA67B01,
        
        /// Yellowish-Green
        0xEAF28F,
        0xE4EF65,
        0xD9EC37,
        0xC3D117,
        0x9BA50E,
        
        /// Green
        0xB1DD8B,
        0x96D35F,
        0x76BB40,
        0x669D34,
        0x4E7A27,
        
        /// SkyBlue
       0x52D6FC,
       0x01C7FC,
       0x00A1D8,
       0x008CB4,
       0x008CB4,
        
        /// Blue
       0x74A7FF,
       0x3A87FD,
       0x0061FD,
       0x0056D6,
       0x0042A9,
        
        /// Navy
        0x864FFD,
        0x5E30EB,
        0x4D22B2,
        0x371A94,
        0x2C0977,
        
        /// Purple
        0xD357FE,
        0xBE38F3,
        0x982ABC,
        0x7A219E,
        0x61187C
    ]
    
    // MARK: - Method
    
    /// 컬러리스트 받아오기
    func getColorList() -> [UIColor] {
        return colorList.map { UIColor(rgb: $0) }
    }
    
    /// 선택된 컬러 받아오기
    func getSelectColor() -> Int {
        return colorList[currentIndex]
    }
    
    /// 현재 선택된 컬러의 인덱스 받아오기
    func getCurrentIndex() -> Int {
        return currentIndex
    }
    
    /// 인덱스 업데이트
    func updateCurrentIndex(to index: Int) {
        currentIndex = index
    }
    
    /// 파라미터로 받은 Color에 매칭될 수 있게 currentIndex 업데이트
    func updateCurrentColor(_ color: Int) {
        for (index, num) in colorList.enumerated() where color == num {
            currentIndex = index
            return
        }
    }
}
