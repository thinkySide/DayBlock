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
    
    /// 싱글톤
    static let shared = GroupDataStore()
    private init() {}
    
    /// CoreData Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /// 그룹 엔티티
    private var entities: [Group] = []
    
    /// 리모트 그룹
    private var remoteObject = RemoteGroup(name: "", color: 0x0061FD, list: [])
    
    /// 현재 그룹 인덱스
    private var focusIndexValue = 0
    
    /// 현재 편집중인 그룹 인덱스
    private var editIndexValue = 0
    
    /// 콘텍스트 저장 및 그룹 엔티티를 패치합니다.
    func saveContext() {
        do {
            try context.save()
            fetchRequestEntity()
        } catch {
            print(error.localizedDescription)
        }
    }
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
    
    /// 그룹이 없을 시, 기본 그룹을 생성합니다.
    func initDefaultGroup() {
        
        // 그룹 엔티티의 값이 비어있다면
        if entities.isEmpty {
            
            // 기본 그룹 생성
            let newGroup = Group(context: context)
            newGroup.name = "기본 그룹"
            newGroup.color = 0x323232
            
            // 콘텍스트 저장
            saveContext()
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
    
    /// 현재 포커스된 그룹의 컬러를 반환합니다.
    func focusColor() -> UIColor {
        return UIColor(rgb: entities[focusIndexValue].color)
    }
    
    
    
    
    /// 편집 중인 그룹의 인덱스를 반환합니다.
    func editIndex() -> Int {
        return editIndexValue
    }
    
    /// 지정한 인덱스로 편집 중인 그룹 인덱스를 업데이트합니다.
    func updateEditIndex(to index: Int) {
        editIndexValue = index
    }
    
    /// 현재 편집 중인 그룹을 삭제합니다.
    func delete() {
        context.delete(entities[editIndexValue])
        saveContext()
    }
    
    /// Remote 그룹을 통해 새 그룹을 생성합니다.
    func create() {
        
        // 리모트 그룹을 통한 그룹 엔티티 생성
        let newGroup = Group(context: context)
        newGroup.name = remoteObject.name
        newGroup.color = remoteObject.color
        
        // 콘텍스트 저장 및 리모트 그룹 초기화
        saveContext()
        resetRemote()
    }
    
    /// 그룹의 이름을 업데이트합니다.
    func update(name: String) {
        let group = entities[editIndexValue]
        group.name = name
        group.color = remoteObject.color
        saveContext()
    }
}


// MARK: - Remote Group
extension GroupDataStore {
    
    /// READ - 리모트 그룹 받아오기
    func remote() -> RemoteGroup {
        return remoteObject
    }
    
    /// UPDATE - 리모트 그룹 그룹명 업데이트
    func updateRemote(name: String) {
        remoteObject.name = name
    }
    
    /// UPDATE - 리모트 그룹 컬러 업데이트
    func updateRemote(color: Int) {
        remoteObject.color = color
    }
    
    /// RESET - 리모트 그룹 초기화
    func resetRemote() {
        remoteObject = RemoteGroup(name: "", color: 0x0061FD, list: [])
    }
}
