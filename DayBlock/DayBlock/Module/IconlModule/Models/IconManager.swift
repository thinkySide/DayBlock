//
//  IconManager.swift
//  DayBlock
//
//  Created by 김민준 on 2023/05/09.
//

import UIKit

/// 아이콘(SFSymbol) 관리 매니저
final class IconManager {

    /// 싱글톤 패턴
    static let shared = IconManager()
    private init() { icons = symbols }

    /// 현재 아이콘의 인덱스 값
    private var index = 0

    /// 아이콘 리스트
    private var icons: [String]

    // MARK: - Method

    /// 아이콘 리스트를 리턴합니다.
    func list() -> [String] {
        return icons
    }

    /// 현재 선택된 아이콘을 리턴합니다.
    func selected() -> String {
        return icons[index]
    }

    /// 현재 선택된 아이콘의 인덱스를 리턴합니다.
    func selectedIndex() -> Int {
        return index
    }

    /// 현재 선택된 아이콘의 인덱스를 업데이트합니다.
    ///
    /// - Parameter index: 업데이트 할 인덱스
    func updateSelectedIndex(to index: Int) {
        self.index = index
    }

    /// 현재 선택된 아이콘의 인덱스를 현재 아이콘을 기준으로 업데이트합니다.
    ///
    /// - Parameter currentIcon: 현재 아이콘 문자열
    func updateSelectedIndex(as currentIcon: String) {
        for (index, icon) in (icons.enumerated()) where currentIcon == icon {
            self.index = index
        }
    }
}
