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
    
    // MARK: - CoreData Properties
    
    /// CoreData Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /// 그룹 엔티티
    private var groupEntity: [Group] = []
    
    /// 블럭 엔티티
    private var blockEntity: [Block] {
        
        // 현재 그룹 인덱스값을 이용해 그룹 엔티티에서 블럭 엔티티값 반환
        if let entity = groupEntity[currentGroupIndex].blockList?.array as? [Block] {
            return entity
        }
        
        // 엔티티 반환 실패 케이스
        print("Error: block Entity 반환 실패")
        return []
    }
    
    /// 현재 그룹 인덱스
    private var currentGroupIndex = 0
    
    /// 현재 블럭 인덱스
    private var currentBlockIndex = 0
    
    /// 현재 편집중인 그룹 인덱스
    private var currentEditGroupIndex = 0
    
    /// 리모트 블럭
    private var remoteBlock = RemoteGroup(name: "기본 그룹",
                                    color: 0x323232,
                                    list: [RemoteBlock(taskLabel: "블럭 쌓기", todayOutput: 0.0, icon: "batteryblock.fill")])
    
    /// 리모트 블럭 그룹 인덱스
    var remoteBlockGroupIndex = 0
    
    /// 리모트 그룹
    private var remoteGroup = RemoteGroup(name: "", color: 0x0061FD, list: [])
}

// MARK: - CoreData Method
extension DayBlockManager {
    
    /// 콘텍스트 저장 및 그룹 엔티티를 패치합니다.
    func saveContext() {
        do {
            try context.save()
            fetchRequestGroupEntitiy()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// 그룹 엔티티 패치를 요청합니다.
    func fetchRequestGroupEntitiy() {
        do {
            groupEntity = try context.fetch(Group.fetchRequest())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// 코어데이터 기본값을 설정합니다. (기본 그룹 생성)
    func initialSetupForCoreData() {
        
        // 그룹 엔티티의 값이 비어있다면
        if groupEntity.isEmpty {
            
            // 기본 그룹 생성
            let newGroup = Group(context: context)
            newGroup.name = "기본 그룹"
            newGroup.color = 0x323232
            
            // 콘텍스트 저장
            saveContext()
        }
    }
}

// MARK: - Group Method
extension DayBlockManager {
    
    /// READ - 전체 그룹 리스트 받아오기
    func getGroupList() -> [Group] {
        return groupEntity
    }
    
    /// 새 그룹 엔티티를 생성합니다.
    func createNewGroup() {
        
        // 리모트 그룹을 통한 그룹 엔티티 생성
        let newGroup = Group(context: context)
        newGroup.name = remoteGroup.name
        newGroup.color = remoteGroup.color
        
        // 콘텍스트 저장 및 리모트 그룹 초기화
        saveContext()
        resetRemoteGroup()
    }
    
    /// READ - 현재 그룹 인덱스 받아오기
    func getCurrentGroupIndex() -> Int {
        return currentGroupIndex
    }
    
    /// READ - 현재 그룹 받아오기
    func getCurrentGroup() -> Group {
        return groupEntity[currentGroupIndex]
    }
    
    /// READ - 현재 그룹 컬러 받아오기
    func getCurrentGroupColor() -> UIColor {
        return UIColor(rgb: groupEntity[currentGroupIndex].color)
    }
    
    /// UPDATE - 현재 그룹 업데이트
    func updateCurrentGroup(index: Int) {
        currentGroupIndex = index
    }
    
    func getCurrentEditGroupIndex() -> Int {
        return currentEditGroupIndex
    }
    
    func updateCurrentEditGroupIndex(_ index: Int) {
        currentEditGroupIndex = index
    }
    
    /// 코어데이터 내 그룹 삭제 메서드
    func deleteGroup() {
        context.delete(groupEntity[currentEditGroupIndex])
        saveContext()
    }
    
    /// 코어데이터 내 그룹 편집 메서드
    func updateGroup(name: String) {
        let group = groupEntity[currentEditGroupIndex]
        group.name = name
        group.color = remoteGroup.color
        saveContext()
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
        if currentGroupIndex == remoteBlockGroupIndex {
            
            // 블럭 엔티티 현재 인덱스에 삽입 후
            groupEntity[currentGroupIndex].insertIntoBlockList(updateBlock, at: currentBlockIndex)
            
            // 다음 인덱스(기존 블럭 엔티티) 삭제
            deleteBlockEntitiy(blockEntity[currentBlockIndex+1])
        }
        
        // 만약 그룹이 이동되었다면
        if currentGroupIndex != remoteBlockGroupIndex {
            
            // 현재 인덱스의 블럭 엔티티 삭제 후
            deleteBlockEntitiy(blockEntity[currentBlockIndex])
            
            if let entity = groupEntity[remoteBlockGroupIndex].blockList?.array as? [Block] {
                
                // 리모트 그룹 인덱스의 가장 마지막 인덱스에 블럭 엔티티 삽입
                groupEntity[remoteBlockGroupIndex].insertIntoBlockList(updateBlock, at: entity.count)
                
                // 현재 블럭 인덱스 업데이트(화면 이동용)
                currentBlockIndex = entity.count
            }
            
            // 현재 그룹 인덱스 업데이트(화면 이동용)
            currentGroupIndex = remoteBlockGroupIndex
        }

        saveContext()
    }
    
    /// 지정한 블럭엔티티를 삭제합니다.
    func deleteBlockEntitiy(_ blockEntity: Block) {
        
        // 현재 그룹 엔티티에서 지정한 블럭 에티티 삭제 및 콘텍스트에 반영
        groupEntity[currentGroupIndex].removeFromBlockList(blockEntity)
        context.delete(blockEntity)
        saveContext()
    }
    
    func getLastBlockIndex() -> Int {
        return blockEntity.count - 1
    }
    
    /// READ - 현재 그룹에 속한 블럭 리스트 받아오기
    func getCurrentBlockList() -> [Block] {
        if groupEntity.count == 0 { return [] }
        return blockEntity
    }
    
    /// READ - 지정한 그룹에 속한 블럭 리스트 받아오기
    func getBlockList(_ index: Int) -> [Block] {
        let group = groupEntity[index]
        if let blockList = group.blockList?.array as? [Block] {
            return blockList
        }
        return []
    }
    
    /// READ - 지정한 그룹명에 속한 블럭 리스트 받아오기
    func getBlockList(_ groupName: String) -> [Block] {
        for group in groupEntity where group.name == groupName {
            if let blockList = group.blockList?.array as? [Block] {
                return blockList
            }
        }
        return [Block]()
    }
    
    func getCurrentBlockIndex() -> Int {
        return currentBlockIndex
    }
    
    func updateCurrentBlockIndex(_ index: Int) {
        currentBlockIndex = index
    }
    
    /// CREATE - 현재 리모트 블럭 정보로 새 블럭 생성
    func createNewBlock() {
        
        /// 리모트 블럭이 포함된 그룹 검색
        for (index, group) in groupEntity.enumerated() where remoteBlock.name == group.name {
            currentGroupIndex = index
            
            let newBlock = Block(context: context)
            newBlock.taskLabel = remoteBlock.list[0].taskLabel
            newBlock.todayOutput = remoteBlock.list[0].todayOutput
            newBlock.icon = remoteBlock.list[0].icon
            groupEntity[currentGroupIndex].addToBlockList(newBlock)
            
            saveContext()
        }
    }
}

// MARK: - Remote Group (그룹 생성, 스위칭용)
extension DayBlockManager {
    
    /// READ - 리모트 그룹 받아오기
    func getRemoteGroup() -> RemoteGroup {
        return remoteGroup
    }
    
    /// UPDATE - 리모트 그룹 그룹명 업데이트
    func updateRemoteGroup(name: String) {
        remoteGroup.name = name
    }
    
    /// UPDATE - 리모트 그룹 컬러 업데이트
    func updateRemoteGroup(color: Int) {
        remoteGroup.color = color
    }
    
    /// RESET - 리모트 그룹 초기화
    func resetRemoteGroup() {
        remoteGroup = RemoteGroup(name: "", color: 0x0061FD, list: [])
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
        let group = groupEntity[currentGroupIndex]
        remoteBlock = RemoteGroup(name: group.name,
                            color: group.color,
                            list: [RemoteBlock(taskLabel: "블럭 쌓기", todayOutput: 0.0, icon: "batteryblock.fill")])
        remoteBlockGroupIndex = currentGroupIndex
    }
}
