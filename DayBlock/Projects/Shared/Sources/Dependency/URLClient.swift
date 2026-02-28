//
//  URLClient.swift
//  Util
//
//  Created by 김민준 on 2/28/26.
//

import UIKit
import Dependencies

// MARK: - AppURL
public enum AppURL {
    case inquiry

    public var url: URL {
        switch self {
        case .inquiry:
            URL(string: "https://open.kakao.com/o/sotwoMii")!
        }
    }
}

// MARK: - Protocol
public protocol URLClientProtocol {
    func open(_ appURL: AppURL)
}

// MARK: - LiveValue
public struct URLClient: URLClientProtocol {
    public func open(_ appURL: AppURL) {
        UIApplication.shared.open(appURL.url)
    }
}

// MARK: - DependencyKey
public enum URLClientDependencyKey: DependencyKey {
    public static var liveValue: URLClientProtocol {
        URLClient()
    }
}

// MARK: - DependencyValues
public extension DependencyValues {
    var urlClient: URLClientProtocol {
        get { self[URLClientDependencyKey.self] }
        set { self[URLClientDependencyKey.self] = newValue }
    }
}
