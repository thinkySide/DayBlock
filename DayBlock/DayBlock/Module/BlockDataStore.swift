//
//  BlockDataStore.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/25.
//

import UIKit
import CoreData

final class BlockDataStore {
    
    /// 싱글톤
    static let shared = BlockDataStore()
    private init() {}
    
    /// CoreData Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /// 블럭 엔티티
    var entities: [Block] = []
    
    /// 리모트 블럭
    private var remoteObject = RemoteGroup(name: "기본 그룹",
                                    color: 0x323232,
                                    list: [RemoteBlock(taskLabel: "블럭 쌓기", todayOutput: 0.0, icon: "batteryblock.fill")])
    
    /// 리모트 블럭 그룹 인덱스
    var remoteIndex = 0
    
    /// 현재 블럭 인덱스
    private var focusIndexValue = 0
    
    /// 그룹 데이터 객체
    private let groupData = GroupDataStore.shared
}

// MARK: - Method
extension BlockDataStore {
    
    /// 블럭 리스트를 반환합니다.
    func list() -> [Block] {
        // 현재 그룹 인덱스값을 이용해 그룹 엔티티에서 블럭 엔티티값 반환
        if let entity = groupData.focusEntity().blockList?.array as? [Block] {
            entities = entity
            return entities
        }
        
        // 엔티티 반환 실패 케이스
        print("Error: block Entity 반환 실패")
        return entities
    }
    
    /// 현재 포커스 된 블럭 인덱스를 반환합니다.
    func focusIndex() -> Int {
        return focusIndexValue
    }
    
    /// 지정된 인덱스로 블럭 인덱스를 업데이트합니다.
    func updateFocusIndex(to index: Int) {
        focusIndexValue = index
    }
    
    /// 현재 포커스 된 블럭을 반환합니다.
    func focusEntity() -> Block {
        return list()[focusIndexValue]
    }
    
    /// 블럭 수정 완료 후 블럭 엔티티를 업데이트합니다.
    func update() {
        
        // 리모트 블럭을 통한 블럭 엔티티 생성
        let updateBlock = Block(context: context)
        updateBlock.taskLabel = remoteObject.list[0].taskLabel
        updateBlock.icon = remoteObject.list[0].icon

        // 만약 그룹이 동일하다면
        if groupData.focusIndex() == remoteIndex {
            
            // 블럭 엔티티 현재 인덱스에 삽입 후
            groupData.focusEntity().insertIntoBlockList(updateBlock, at: focusIndexValue)
            
            // 다음 인덱스(기존 블럭 엔티티) 삭제
            delete(list()[focusIndexValue + 1])
        }
        
        // 만약 그룹이 이동되었다면
        if groupData.focusIndex() != remoteIndex {
            
            // 현재 인덱스의 블럭 엔티티 삭제 후
            delete(focusEntity())
            
            if let entity = groupData.list()[remoteIndex].blockList?.array as? [Block] {
                
                // 리모트 그룹 인덱스의 가장 마지막 인덱스에 블럭 엔티티 삽입
                groupData.list()[remoteIndex].insertIntoBlockList(updateBlock, at: entity.count)
                
                // 현재 블럭 인덱스 업데이트(화면 이동용)
                updateFocusIndex(to: entity.count)
            }
            
            // 현재 그룹 인덱스 업데이트(화면 이동용)
            groupData.updateFocusIndex(to: remoteIndex)
        }

        groupData.saveContext()
    }
    
    /// 지정한 블럭엔티티를 삭제합니다.
    func delete(_ blockEntity: Block) {
        
        // 현재 그룹 엔티티에서 지정한 블럭 에티티 삭제 및 콘텍스트에 반영
        groupData.focusEntity().removeFromBlockList(blockEntity)
        context.delete(blockEntity)
        groupData.saveContext()
    }
    
    func lastIndex() -> Int {
        return list().count - 1
    }
    
    /// READ - 현재 그룹에 속한 블럭 리스트 받아오기
    func listInFocusGroup() -> [Block] {
        if groupData.list().count == 0 { return [] }
        return list()
    }
    
    /// READ - 지정한 그룹에 속한 블럭 리스트 받아오기
    func listInSelectedGroup(at index: Int) -> [Block] {
        let group = groupData.list()[index]
        if let blockList = group.blockList?.array as? [Block] {
            return blockList
        }
        return []
    }
    
    /// READ - 지정한 그룹명에 속한 블럭 리스트 받아오기
    func listInSelectedGroup(with groupName: String) -> [Block] {
        for group in groupData.list() where group.name == groupName {
            if let blockList = group.blockList?.array as? [Block] {
                return blockList
            }
        }
        return [Block]()
    }
    
    /// CREATE - 현재 리모트 블럭 정보로 새 블럭 생성
    func create() {
        
        /// 리모트 블럭이 포함된 그룹 검색
        for (index, groups) in groupData.list().enumerated() where remoteObject.name == groups.name {
            groupData.updateFocusIndex(to: index)

            let newBlock = Block(context: context)
            newBlock.taskLabel = remoteObject.list[0].taskLabel
            newBlock.todayOutput = remoteObject.list[0].todayOutput
            newBlock.icon = remoteObject.list[0].icon
            groupData.focusEntity().addToBlockList(newBlock)
            
            groupData.saveContext()
        }
    }
}

// MARK: - Remote Block (블럭 생성, 스위치용)
extension BlockDataStore {
    
    /// READ - 리모트 블럭 받아오기
    func remote() -> RemoteGroup {
        return remoteObject
    }
    
    /// READ - 리모트 블럭 그룹명 받아오기
    func remoteName() -> String {
        return remoteObject.name
    }
    
    /// READ - 리모트 블럭 그룹 컬러 받아오기
    func remoteColor() -> UIColor {
        return UIColor(rgb: remoteObject.color)
    }
    
    /// READ - 리모트 블럭 아이콘 받아오기
    func remoteIcon() -> UIImage {
        return UIImage(systemName: remoteObject.list[0].icon)!
    }
    
    /// UPDATE - 리모트 블럭 그룹 업데이트
    func updateRemote(group: Group) {
        remoteObject.name = group.name
        remoteObject.color = group.color
    }
    
    /// UPDATE - 리모트 블럭 라벨 업데이트
    func updateRemote(label: String) {
        remoteObject.list[0].taskLabel = label
    }
    
    /// UPDATE - 리모트 블럭 아이콘 업데이트
    func updateRemote(icon: String) {
        remoteObject.list[0].icon = icon
    }
    
    /// UPDATE - 리모트 블럭 생산량 업데이트
    func updateRemote(output: Double) {
        remoteObject.list[0].todayOutput = output
    }
    
    /// RESET - 리모트 블럭 초기화
    func resetRemote() {
        let group = groupData.focusEntity()
        remoteObject = RemoteGroup(name: group.name,
                            color: group.color,
                            list: [RemoteBlock(taskLabel: "블럭 쌓기", todayOutput: 0.0, icon: "batteryblock.fill")])
        remoteIndex = groupData.focusIndex()
    }
}
