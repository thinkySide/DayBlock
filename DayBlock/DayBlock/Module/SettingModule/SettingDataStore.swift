//
//  SettingDataStore.swift
//  DayBlock
//
//  Created by 김민준 on 12/13/23.
//

import UIKit

struct Setting {
    let name: String
}

struct SettingDataStore {
    
    private let usages: [Setting] = [
        Setting(name: "도움말"),
        // Setting(name: "APP 공유"),
        // Setting(name: "앱스토어 리뷰"),
        Setting(name: "이메일 문의"),
        Setting(name: "초기화")
    ]
    
    private let developers: [Setting] = [
        Setting(name: "개발자 정보"),
        Setting(name: "오픈소스")
    ]
    
    // MARK: - Method
    
    /// 일반 설정 데이터를 반환합니다.
    func usageData() -> [Setting] {
        return usages
    }
    
    /// 개발자 설정 데이터를 반환합니다.
    func developerData() -> [Setting] {
        return developers
    }
}
