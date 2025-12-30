//
//  UserDefaultsClient.swift
//  PersistentData
//
//  Created by 김민준 on 12/30/25.
//

import Foundation
import Util

public typealias UserDefaultsKeyPath<T> = KeyPath<UserDefaultsKeyGroup, UserDefaultsKeyValue<T>>

/// UserDefaults에 접근하기 위한 객체
public final class UserDefaultsClient {
    private static let keys = UserDefaultsKeyGroup()
    private init() {}
}

// MARK: - Use Case
extension UserDefaultsClient {

    /// UserDefaults 값을 가져옵니다.
    ///
    /// - Parameters:
    ///   - keyPath: UserDefaultsKeys의 KeyPath
    ///   - domain: UserDefaults 도메인(데이터베이스)
    ///
    /// - Returns: 저장된 값 또는 기본값
    ///
    /// - Note: `Decodable` 타입의 값을 자동으로 디코딩 후 반환합니다.
    public static func get<T>(_ keyPath: UserDefaultsKeyPath<T>, domain: UserDefaultsDomain) -> T {
        let keyValue = keys[keyPath: keyPath]
        let key = keyValue.key

        guard let userDefaults = domain.userDefaults else { return keyValue.defaultValue }

        if let storedValue = userDefaults.object(forKey: key) as? T {
            Debug.log("🗳️: \(key)(\(domain.name)) 값 반환 / \(storedValue)")
            return storedValue
        }

        if let data = userDefaults.data(forKey: key),
           let decodableType = T.self as? any Decodable.Type,
           let decoded = try? JSONDecoder().decode(decodableType, from: data) as? T {
            Debug.log("🗳️: \(key)(\(domain.name)) 값 반환 / \(decoded)")
            return decoded
        }

        Debug.log("🗳️: \(key)(\(domain.name)) 저장된 값이 없어 기본값 반환 / \(keyValue.defaultValue)")
        return keyValue.defaultValue
    }

    /// UserDefaults 값을 설정합니다.
    ///
    /// - Parameters:
    ///   - keyPath: UserDefaultsKeys의 KeyPath
    ///   - value: 설정할 값
    ///   - domain: UserDefaults 도메인(데이터베이스)
    ///
    /// - Note: `Encodable` 타입의 값을 자동으로 인코딩 후 저장합니다.
    public static func set<T>(_ keyPath: UserDefaultsKeyPath<T>, _ value: T, domain: UserDefaultsDomain) {
        let keyValue = keys[keyPath: keyPath]
        let key = keyValue.key

        guard let userDefaults = domain.userDefaults else { return }

        if let encodableValue = value as? any Encodable,
           let data = try? JSONEncoder().encode(encodableValue) {
            userDefaults.set(data, forKey: key)
        } else {
            userDefaults.set(value, forKey: key)
        }

        Debug.log("🗳️: \(key)(\(domain.name)) 값 설정 / \(value)")
    }

    /// UserDefaults 값을 제거합니다.
    ///
    /// - Parameters:
    ///  - keyPath: UserDefaultsKeys의 KeyPath
    ///  - domain: UserDefaults 도메인(데이터베이스)
    public static func remove<T>(_ keyPath: UserDefaultsKeyPath<T>, domain: UserDefaultsDomain) {
        guard let userDefaults = domain.userDefaults else { return }
        let keyValue = keys[keyPath: keyPath]
        let key = keyValue.key
        userDefaults.removeObject(forKey: key)
        Debug.log("🗳️: \(key)(\(domain.name)) 값 삭제")
    }

    /// UserDefaults의 모든 값을 제거합니다.
    ///
    /// - Parameters:
    ///  - domain: UserDefaults 도메인(데이터베이스)
    public static func clear(domain: UserDefaultsDomain) {
        guard let userDefaults = domain.userDefaults else { return }
        let keys = userDefaults.dictionaryRepresentation().keys
        keys.forEach { userDefaults.removeObject(forKey: $0) }
        Debug.log("🗳️: (\(domain.name)) 초기화")
    }
}
