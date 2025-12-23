//
//  Block.swift
//  Domain
//
//  Created by 김민준 on 12/23/25.
//

import Foundation

public struct Block: Equatable {
    
    /// 블럭 이름
    public let name: String
    
    /// Symbol 이름
    public let symbol: String
    
    /// 생산량
    public let output: Double
    
    public init(
        name: String,
        symbol: String,
        output: Double
    ) {
        self.name = name
        self.symbol = symbol
        self.output = output
    }
}

// MARK: - Helper
extension Block {
    
    /// 기본 블럭을 반환합니다.
    public static var defaultValue: Block {
        Block(
            name: "블럭 쌓기",
            symbol: "batteryblock.fill",
            output: 0
        )
    }
}
