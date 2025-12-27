//
//  BlockGroup.swift
//  Domain
//
//  Created by 김민준 on 12/26/25.
//

import SwiftUI

public struct BlockGroup: Identifiable, Equatable {
    
    public var id: String { name }
    
    /// 그룹 이름
    public var name: String
    
    /// 그룹 색상 인덱스
    public var colorIndex: Int
    
    public init(
        name: String,
        colorIndex: Int
    ) {
        self.name = name
        self.colorIndex = colorIndex
    }
}

// MARK: - Helper
extension BlockGroup {
    
    /// 기본 그룹을 반환합니다.
    public static var defaultValue: BlockGroup {
        BlockGroup(
            name: "기본 그룹",
            colorIndex: 4
        )
    }
}
