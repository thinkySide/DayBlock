//
//  UserDefaultsKeyGroup.swift
//  PersistentData
//
//  Created by 김민준 on 12/30/25.
//

import Foundation

public typealias KeyValue<T> = UserDefaultsKeyValue<T>

public struct UserDefaultsKeyGroup {
    
    /// 마지막으로 선택된 그룹의 ID
    public var selectedGroupId: KeyValue<UUID?> {
        .init("selectedGroupId", defaultValue: nil)
    }
    
    /// 마지막으로 선택된 블럭의 ID
    public var selectedBlockId: KeyValue<UUID?> {
        .init("selectedBlockId", defaultValue: nil)
    }
}
