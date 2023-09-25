//
//  GroupDataStore.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/25.
//

import UIKit
import CoreData

// MARK: - Properties
final class GroupDataStore {
    
    /// CoreData Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /// 그룹 엔티티
    private var entities: [Group] = []
    
    /// 현재 그룹 인덱스
    private var focusIndexValue = 0
}

// MARK: - Method
extension GroupDataStore {
    
    /// 그룹 엔티티 패치를 요청합니다.
    func fetchRequestEntity() {
        do {
            entities = try context.fetch(Group.fetchRequest())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// 그룹 리스트를 반환합니다.
    func list() -> [Group] {
        return entities
    }
    
    /// 현재 포커스된 그룹 인덱스를 반환합니다.
    func focusIndex() -> Int {
        return focusIndexValue
    }
    
    /// 지정한 인덱스로 포커스된 그룹 인덱스를 업데이트합니다.
    func updateFocusIndex(to index: Int) {
        focusIndexValue = index
    }
    
    /// 현재 포커스된 그룹을 반환합니다.
    func focusEntity() -> Group {
        return entities[focusIndexValue]
    }
}
