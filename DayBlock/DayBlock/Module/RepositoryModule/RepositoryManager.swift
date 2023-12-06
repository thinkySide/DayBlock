//
//  RepositoryManager.swift
//  DayBlock
//
//  Created by 김민준 on 12/5/23.
//

import Foundation

final class RepositoryManager {
    
    /// 싱글톤
    static let shared = RepositoryManager()
    private init() {}
    
    /// 저장소 아이템 배열
    private var items: [RepositoryItem] = []
    
    // MARK: - Method
    
    /// 저장소 아이템 배열을 반환합니다.
    func currentItems() -> [RepositoryItem] {
        return items
    }
    
    /// 저장소 아이템 배열을 업데이트 합니다.
    func updateCurrentItems(_ items: [RepositoryItem]) {
        self.items = items
    }
}
