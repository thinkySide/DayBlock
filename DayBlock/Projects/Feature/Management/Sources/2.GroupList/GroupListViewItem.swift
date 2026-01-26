//
//  GroupListViewItem.swift
//  ManagementDemoApp
//
//  Created by 김민준 on 1/26/26.
//

import Foundation
import Domain

public struct GroupListViewItem: Identifiable, Equatable {

    public var id: UUID { group.id }
    public var group: BlockGroup
    public var blockCount: Int
    public var isDefault: Bool
    
    public init(
        group: BlockGroup,
        blockCount: Int,
        isDefault: Bool
    ) {
        self.group = group
        self.blockCount = blockCount
        self.isDefault = isDefault
    }
}
