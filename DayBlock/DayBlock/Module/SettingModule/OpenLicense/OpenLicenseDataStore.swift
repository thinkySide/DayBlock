//
//  OpenLicenseDataStore.swift
//  DayBlock
//
//  Created by 김민준 on 12/19/23.
//

import Foundation

struct OpenLicense {
    let name: String
    let url: String
}

struct OpenLicenseDataStore {
    
    private let licenses = [
        OpenLicense(name: "FSCalendar", url: "https://github.com/WenchaoD/FSCalendar")
    ]
    
    /// 오픈 라이센스 배열을 반환합니다.
    func list() -> [OpenLicense] {
        return licenses
    }
    
    /// 지정한 인덱스의 URL을 반환합니다.
    func fetchURL(to index: Int) -> URL? {
        guard let url = URL(string: licenses[index].url) else { return nil }
        return url
    }
}
