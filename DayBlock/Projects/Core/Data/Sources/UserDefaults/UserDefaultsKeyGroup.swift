//
//  UserDefaultsKeyGroup.swift
//  PersistentData
//
//  Created by 김민준 on 12/30/25.
//

import Domain

public typealias KeyValue<T> = UserDefaultsKeyValue<T>

public struct UserDefaultsKeyGroup {
    
    /// 선택된 그룹
    public var selectedGroup: KeyValue<BlockGroup?> {
        .init("selectedGroup", defaultValue: nil)
    }
}
