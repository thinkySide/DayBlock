//
//  Block.swift
//  Domain
//
//  Created by 김민준 on 12/23/25.
//

import Foundation

public struct Block: Identifiable, Equatable {
    
    /// 블럭 ID
    public let id = UUID()
    
    /// 블럭 이름
    public var name: String
    
    /// 아이콘 인덱스
    public var iconIndex: Int
    
    /// 생산량
    public var output: Double
    
    public init(
        name: String,
        iconIndex: Int,
        output: Double
    ) {
        self.name = name
        self.iconIndex = iconIndex
        self.output = output
    }
}

// MARK: - Helper
extension Block {
    
    /// 기본 블럭을 반환합니다.
    public static var defaultValue: Block {
        Block(
            name: "블럭 쌓기",
            iconIndex: 0,
            output: 0
        )
    }
}
