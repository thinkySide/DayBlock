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
    
    /// 리모트 블럭
    private var remoteBlock = RemoteGroup(name: "기본 그룹",
                                    color: 0x323232,
                                    list: [RemoteBlock(taskLabel: "블럭 쌓기", todayOutput: 0.0, icon: "batteryblock.fill")])
    
    /// 리모트 블럭 그룹 인덱스
    var remoteBlockGroupIndex = 0
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

// MARK: - Block Method
extension DayBlockManager {
    
    /// 블럭 수정 완료 후 블럭 엔티티를 업데이트합니다.
    func updateBlock() {
        
        // 리모트 블럭을 통한 블럭 엔티티 생성
        let updateBlock = Block(context: context)
        updateBlock.taskLabel = remoteBlock.list[0].taskLabel
        updateBlock.icon = remoteBlock.list[0].icon

        // 만약 그룹이 동일하다면
        if groupData.focusIndex() == remoteBlockGroupIndex {
            
            // 블럭 엔티티 현재 인덱스에 삽입 후
            groupData.focusEntity().insertIntoBlockList(updateBlock, at: blockData.focusIndex())
            
            // 다음 인덱스(기존 블럭 엔티티) 삭제
            deleteBlockEntitiy(blockData.list()[blockData.focusIndex() + 1])
        }
        
        // 만약 그룹이 이동되었다면
        if groupData.focusIndex() != remoteBlockGroupIndex {
            
            // 현재 인덱스의 블럭 엔티티 삭제 후
            deleteBlockEntitiy(blockData.focusEntity())
            
            if let entity = groupData.list()[remoteBlockGroupIndex].blockList?.array as? [Block] {
                
                // 리모트 그룹 인덱스의 가장 마지막 인덱스에 블럭 엔티티 삽입
                groupData.list()[remoteBlockGroupIndex].insertIntoBlockList(updateBlock, at: entity.count)
                
                // 현재 블럭 인덱스 업데이트(화면 이동용)
                blockData.updateFocusIndex(to: entity.count)
            }
            
            // 현재 그룹 인덱스 업데이트(화면 이동용)
            groupData.updateFocusIndex(to: remoteBlockGroupIndex)
        }

        saveContext()
    }
    
    /// 지정한 블럭엔티티를 삭제합니다.
    func deleteBlockEntitiy(_ blockEntity: Block) {
        
        // 현재 그룹 엔티티에서 지정한 블럭 에티티 삭제 및 콘텍스트에 반영
        groupData.focusEntity().removeFromBlockList(blockEntity)
        context.delete(blockEntity)
        saveContext()
    }
    
    func getLastBlockIndex() -> Int {
        return blockData.list().count - 1
    }
    
    /// READ - 현재 그룹에 속한 블럭 리스트 받아오기
    func getCurrentBlockList() -> [Block] {
        if groupData.list().count == 0 { return [] }
        return blockData.list()
    }
    
    /// READ - 지정한 그룹에 속한 블럭 리스트 받아오기
    func getBlockList(_ index: Int) -> [Block] {
        let group = groupData.list()[index]
        if let blockList = group.blockList?.array as? [Block] {
            return blockList
        }
        return []
    }
    
    /// READ - 지정한 그룹명에 속한 블럭 리스트 받아오기
    func getBlockList(_ groupName: String) -> [Block] {
        for group in groupData.list() where group.name == groupName {
            if let blockList = group.blockList?.array as? [Block] {
                return blockList
            }
        }
        return [Block]()
    }
    
    func getCurrentBlockIndex() -> Int {
        return blockData.focusIndex()
    }
    
    func updateCurrentBlockIndex(_ index: Int) {
        blockData.updateFocusIndex(to: index)
    }
    
    /// CREATE - 현재 리모트 블럭 정보로 새 블럭 생성
    func createNewBlock() {
        
        /// 리모트 블럭이 포함된 그룹 검색
        for (index, groups) in groupData.list().enumerated() where remoteBlock.name == groups.name {
            groupData.updateFocusIndex(to: index)

            let newBlock = Block(context: context)
            newBlock.taskLabel = remoteBlock.list[0].taskLabel
            newBlock.todayOutput = remoteBlock.list[0].todayOutput
            newBlock.icon = remoteBlock.list[0].icon
            groupData.focusEntity().addToBlockList(newBlock)
            
            saveContext()
        }
    }
}

// MARK: - Remote Block (블럭 생성, 스위치용)
extension DayBlockManager {
    
    /// READ - 리모트 블럭 받아오기
    func getRemoteBlock() -> RemoteGroup {
        return remoteBlock
    }
    
    /// READ - 리모트 블럭 그룹명 받아오기
    func getRemoteBlockGroupName() -> String {
        return remoteBlock.name
    }
    
    /// READ - 리모트 블럭 그룹 컬러 받아오기
    func getRemoteBlockGroupColor() -> UIColor {
        return UIColor(rgb: remoteBlock.color)
    }
    
    /// READ - 리모트 블럭 아이콘 받아오기
    func getRemoteBlockIcon() -> UIImage {
        return UIImage(systemName: remoteBlock.list[0].icon)!
    }
    
    /// UPDATE - 리모트 블럭 그룹 업데이트
    func updateRemoteBlock(group: Group) {
        remoteBlock.name = group.name
        remoteBlock.color = group.color
    }
    
    /// UPDATE - 리모트 블럭 라벨 업데이트
    func updateRemoteBlock(label: String) {
        remoteBlock.list[0].taskLabel = label
    }
    
    /// UPDATE - 리모트 블럭 아이콘 업데이트
    func updateRemoteBlock(icon: String) {
        remoteBlock.list[0].icon = icon
    }
    
    /// UPDATE - 리모트 블럭 생산량 업데이트
    func updateRemoteBlock(output: Double) {
        remoteBlock.list[0].todayOutput = output
    }
    
    /// RESET - 리모트 블럭 초기화
    func resetRemoteBlock() {
        let group = groupData.focusEntity()
        remoteBlock = RemoteGroup(name: group.name,
                            color: group.color,
                            list: [RemoteBlock(taskLabel: "블럭 쌓기", todayOutput: 0.0, icon: "batteryblock.fill")])
        remoteBlockGroupIndex = groupData.focusIndex()
    }
}
