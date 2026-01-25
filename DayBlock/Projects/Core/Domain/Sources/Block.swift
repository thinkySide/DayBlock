//
//  Block.swift
//  Domain
//
//  Created by 김민준 on 12/23/25.
//

import Foundation

public struct Block: Identifiable, Equatable, Codable {
    
    /// 블럭 ID
    public let id: UUID
    
    /// 블럭 이름
    public var name: String
    
    /// 아이콘 인덱스
    public var iconIndex: Int
    
    /// 색상 인덱스
    public var colorIndex: Int
    
    /// 생산량
    public var output: Double
    
    /// 순서
    public var order: Int
    
    public init(
        id: UUID,
        name: String,
        iconIndex: Int,
        colorIndex: Int,
        output: Double,
        order: Int
    ) {
        self.id = id
        self.name = name
        self.iconIndex = iconIndex
        self.colorIndex = colorIndex
        self.output = output
        self.order = order
    }
}
