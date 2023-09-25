//
//  DayBlockManager.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/04.
//

import UIKit
import CoreData

/// 블럭 매니저
final class DayBlockManager {
    
    /// 싱글톤
    static let shared = DayBlockManager()
    private init() {}
    
    let groupData = GroupDataStore.shared
    let blockData = BlockDataStore.shared
    
    // MARK: - CoreData Properties
    
    /// CoreData Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
}

// MARK: - CoreData Method
extension DayBlockManager {
    
    /// 콘텍스트 저장 및 그룹 엔티티를 패치합니다.
    func saveContext() {
        do {
            try context.save()
            groupData.fetchRequestEntity()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// 코어데이터 기본값을 설정합니다. (기본 그룹 생성)
    func initialSetupForCoreData() {
        
        // 그룹 엔티티의 값이 비어있다면
        if groupData.list().isEmpty {
            
            // 기본 그룹 생성
            let newGroup = Group(context: context)
            newGroup.name = "기본 그룹"
            newGroup.color = 0x323232
            
            // 콘텍스트 저장
            saveContext()
        }
    }
}
