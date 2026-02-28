//
//  AppInfoClient.swift
//  Util
//
//  Created by 김민준 on 2/28/26.
//

import Foundation
import Dependencies

// MARK: - Protocol
public protocol AppInfoClientProtocol {
    var version: String { get }
    var build: String { get }
}

// MARK: - LiveValue
public struct AppInfoClient: AppInfoClientProtocol {
    public var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    }

    public var build: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
    }
}

// MARK: - DependencyKey
public enum AppInfoClientDependencyKey: DependencyKey {
    public static var liveValue: AppInfoClientProtocol {
        AppInfoClient()
    }
}

// MARK: - DependencyValues
public extension DependencyValues {
    var appInfoClient: AppInfoClientProtocol {
        get { self[AppInfoClientDependencyKey.self] }
        set { self[AppInfoClientDependencyKey.self] = newValue }
    }
}
