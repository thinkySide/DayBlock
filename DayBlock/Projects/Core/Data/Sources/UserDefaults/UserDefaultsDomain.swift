//
//  UserDefaultsDomain.swift
//  PersistentData
//
//  Created by 김민준 on 12/30/25.
//

import Foundation

/// UserDefaults 분기를 위한 도메인(데이터베이스)
public enum UserDefaultsDomain: String {

    /// 메인 앱
    case app
}

// MARK: - Helper
extension UserDefaultsDomain {

    /// Locale에 맞는 UserDefaults 인스턴스를 반환합니다.
    public var userDefaults: UserDefaults? {
        switch self {
        case .app: UserDefaults.standard
        }
    }

    /// 도메인 이름을 반환합니다.
    public var name: String {
        self.rawValue.uppercased()
    }
}
