//
//  BlockGroup.swift
//  Domain
//
//  Created by 김민준 on 12/26/25.
//

import SwiftUI

public struct BlockGroup: Identifiable, Equatable {
    
    /// 그룹 Id
    public var id: UUID
    
    /// 그룹 이름
    public var name: String
    
    /// 그룹 색상 인덱스
    public var colorIndex: Int
    
    public init(
        id: UUID,
        name: String,
        colorIndex: Int
    ) {
        self.id = id
        self.name = name
        self.colorIndex = colorIndex
    }
}
