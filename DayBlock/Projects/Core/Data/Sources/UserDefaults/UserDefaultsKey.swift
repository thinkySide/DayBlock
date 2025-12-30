//
//  UserDefaultsKey.swift
//  PersistentData
//
//  Created by 김민준 on 12/30/25.
//

import Foundation

/// UserDefaults Key 및 기본값을 나타내는 구조체
public struct UserDefaultsKeyValue<T> {

    /// UserDefaults Key값으로 사용될 문자열
    public let key: String

    /// UserDefaults에 값이 없을 때 사용할 기본값
    public let defaultValue: T

    public init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
