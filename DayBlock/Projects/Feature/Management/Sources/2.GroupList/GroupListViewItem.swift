//
//  GroupListViewItem.swift
//  ManagementDemoApp
//
//  Created by 김민준 on 1/26/26.
//

import Foundation

public struct GroupListViewItem: Identifiable, Equatable {

    public let id: UUID
    public var name: String
    public var blockCount: Int
    public var isDefault: Bool
    
    public init(
        id: UUID,
        name: String,
        blockCount: Int,
        isDefault: Bool
    ) {
        self.id = id
        self.name = name
        self.blockCount = blockCount
        self.isDefault = isDefault
    }
}
