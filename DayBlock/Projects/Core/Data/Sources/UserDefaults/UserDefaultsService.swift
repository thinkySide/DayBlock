//
//  UserDefaultsServiceDependencies.swift
//  PersistentData
//
//  Created by 김민준 on 12/30/25.
//

import Foundation
import Dependencies

public protocol UserDefaultsServiceProtocol {
    func get<T>(_ keyPath: UserDefaultsKeyPath<T>, domain: UserDefaultsDomain) -> T
    func set<T>(_ keyPath: UserDefaultsKeyPath<T>, _ value: T, domain: UserDefaultsDomain)
    func remove<T>(_ keyPath: UserDefaultsKeyPath<T>, domain: UserDefaultsDomain)
    func clear(domain: UserDefaultsDomain)
}

// MARK: - Default Domain Overload
public extension UserDefaultsServiceProtocol {
    func get<T>(_ keyPath: UserDefaultsKeyPath<T>) -> T {
        get(keyPath, domain: .app)
    }

    func set<T>(_ keyPath: UserDefaultsKeyPath<T>, _ value: T) {
        set(keyPath, value, domain: .app)
    }

    func remove<T>(_ keyPath: UserDefaultsKeyPath<T>) {
        remove(keyPath, domain: .app)
    }

    func clear() {
        clear(domain: .app)
    }
}

// MARK: - LiveValue
public struct UserDefaultsService: UserDefaultsServiceProtocol {
    public func get<T>(_ keyPath: UserDefaultsKeyPath<T>, domain: UserDefaultsDomain) -> T {
        UserDefaultsClient.get(keyPath, domain: domain)
    }

    public func set<T>(_ keyPath: UserDefaultsKeyPath<T>, _ value: T, domain: UserDefaultsDomain) {
        UserDefaultsClient.set(keyPath, value, domain: domain)
    }

    public func remove<T>(_ keyPath: UserDefaultsKeyPath<T>, domain: UserDefaultsDomain) {
        UserDefaultsClient.remove(keyPath, domain: domain)
    }

    public func clear(domain: UserDefaultsDomain) {
        UserDefaultsClient.clear(domain: domain)
    }
}

// MARK: - DependencyKey
public enum UserDefaultsServiceDependencyKey: DependencyKey {
    public static var liveValue: UserDefaultsServiceProtocol {
        UserDefaultsService()
    }
}

// MARK: - DependencyValues
public extension DependencyValues {
    var userDefaultsService: UserDefaultsServiceProtocol {
        get { self[UserDefaultsServiceDependencyKey.self] }
        set { self[UserDefaultsServiceDependencyKey.self] = newValue }
    }
}
