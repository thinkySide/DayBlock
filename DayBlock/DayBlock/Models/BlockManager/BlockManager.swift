//
//  BlockManager.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/04.
//

import UIKit
import CoreData

/// 블럭 매니저
final class BlockManager {
    
    /// 싱글톤
    static let shared = BlockManager()
    private init() {}
    
    
    // MARK: - CoreData Properties
    
    /// CoreData Context
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /// 그룹 엔티티
    private var groupEntity: [GroupEntity] = []
    
    /// 블럭 엔티티
    private var blockEntity: [BlockEntity] {
        
        // 현재 그룹 인덱스값을 이용해 그룹 엔티티에서 블럭 엔티티값 반환
        if let entity = groupEntity[currentGroupIndex].blockList?.array as? [BlockEntity] {
            return entity
        }
        
        // 엔티티 반환 실패 케이스
        print("Error: blockEntity 반환 실패")
        return []
    }
    
    
    // MARK: - Initial Method
    
    /// 콘텍스트 저장 및 그룹 엔티티를 패치합니다.
    private func saveContext() {
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
            groupEntity = try context.fetch(GroupEntity.fetchRequest())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// 코어데이터 기본값을 설정합니다. (기본 그룹 생성)
    func initialSetupForCoreData() {
        
        // 그룹 엔티티의 값이 비어있다면
        if groupEntity.isEmpty {
            
            // 기본 그룹 생성
            let newGroup = GroupEntity(context: context)
            newGroup.name = "기본 그룹"
            newGroup.color = 0x323232
            
            // 콘텍스트 저장
            saveContext()
        }
    }
    
    
    // MARK: - Manage GroupEntitiy
    
    /// READ - 전체 그룹 리스트 받아오기
    func getGroupList() -> [GroupEntity] {
        return groupEntity
    }
    
    /// 새 그룹 엔티티를 생성합니다.
    func createNewGroup() {
        
        // 리모트 그룹을 통한 그룹 엔티티 생성
        let newGroup = GroupEntity(context: context)
        newGroup.name = remoteGroup.name
        newGroup.color = remoteGroup.color
        
        // 콘텍스트 저장 및 리모트 그룹 초기화
        saveContext()
        resetRemoteGroup()
    }
    
    
    // MARK: - Manage BlockEntity

    /// 지정한 블럭엔티티를 삭제합니다.
    func deleteBlockEntitiy(_ blockEntity: BlockEntity) {
        
        // 현재 그룹 엔티티에서 지정한 블럭 에티티 삭제 및 콘텍스트에 반영
        groupEntity[currentGroupIndex].removeFromBlockList(blockEntity)
        context.delete(blockEntity)
        saveContext()
    }
    
    /// 블럭 수정 완료 후 블럭 엔티티를 업데이트합니다.
    func updateBlockEntity() {
        
        // 리모트 블럭을 통한 블럭 엔티티 생성
        let updateBlock = BlockEntity(context: context)
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
            
            if let entity = groupEntity[remoteBlockGroupIndex].blockList?.array as? [BlockEntity] {
                
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
    
    
    // MARK: - GroupList (그룹 리스트)
    
    /// 현재 그룹 인덱스
    private var currentGroupIndex = 0
    
    /// READ - 현재 그룹 인덱스 받아오기
    func getCurrentGroupIndex() -> Int {
        return currentGroupIndex
    }
    
    func getLastBlockIndex() -> Int {
        return blockEntity.count - 1
    }
    
    /// READ - 현재 그룹 받아오기
    func getCurrentGroup() -> GroupEntity {
        return groupEntity[currentGroupIndex]
    }
    
    /// READ - 현재 그룹 컬러 받아오기
    func getCurrentGroupColor() -> UIColor {
        return UIColor(rgb: groupEntity[currentGroupIndex].color)
    }
    
    /// READ - 현재 그룹에 속한 블럭 리스트 받아오기
    func getCurrentBlockList() -> [BlockEntity] {
        if groupEntity.count == 0 { return [] }
        return blockEntity
    }
    
    /// READ - 지정한 그룹에 속한 블럭 리스트 받아오기
    func getBlockList(_ index: Int) -> [BlockEntity] {
        let group = groupEntity[index]
        if let blockList = group.blockList?.array as? [BlockEntity] {
            return blockList
        }
        return []
    }
    
    /// READ - 지정한 그룹명에 속한 블럭 리스트 받아오기
    func getBlockList(_ groupName: String) -> [BlockEntity] {
        for group in groupEntity {
            if group.name == groupName {
                if let blockList = group.blockList?.array as? [BlockEntity] {
                    return blockList
                }
            }
        }
        return [BlockEntity]()
    }
    
    /// UPDATE - 현재 그룹 업데이트
    func updateCurrentGroup(index: Int) {
        currentGroupIndex = index
    }
    
    private var currentBlockIndex = 0
    
    func getCurrentBlockIndex() -> Int {
        return currentBlockIndex
    }
    
    func updateCurrentBlockIndex(_ index: Int) {
        currentBlockIndex = index
    }
    
    
    // MARK: - 편집 중인 그룹
    
    /// 현재 편집중인 그룹 인덱스
    private var currentEditGroupIndex = 0
    
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
    
    
    // MARK: - Remote Block (블럭 생성, 스위치용)
    
    /// 리모트 블럭
    private var remoteBlock = Group(name: "기본 그룹", color: 0x323232, list: [Block(taskLabel: "블럭 쌓기", output: 0.0, icon: "batteryblock.fill")])
    
    var remoteBlockGroupIndex = 0
    
    /// CREATE - 현재 리모트 블럭 정보로 새 블럭 생성
    func createNewBlock() {
        
        /// 리모트 블럭이 포함된 그룹 검색
        for (index, group) in groupEntity.enumerated() {
            if remoteBlock.name == group.name {
                currentGroupIndex = index
                
                let newBlock = BlockEntity(context: context)
                newBlock.taskLabel = remoteBlock.list[0].taskLabel
                newBlock.output = remoteBlock.list[0].output
                newBlock.icon = remoteBlock.list[0].icon
                groupEntity[currentGroupIndex].addToBlockList(newBlock)
                
                saveContext()
            }
        }
    }
    
    /// READ - 리모트 블럭 받아오기
    func getRemoteBlock() -> Group {
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
    
    /// READ - 리모트 그룹 받아오기
    func getRemoteGroup() -> Group {
        return remoteGroup
    }
    
    /// UPDATE - 리모트 블럭 그룹 업데이트
    func updateRemoteBlock(group: GroupEntity) {
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
        remoteBlock.list[0].output = output
    }
    
    /// RESET - 리모트 블럭 초기화
    func resetRemoteBlock() {
        let group = groupEntity[currentGroupIndex]
        remoteBlock = Group(name: group.name, color: group.color, list: [Block(taskLabel: "블럭 쌓기", output: 0.0, icon: "batteryblock.fill")])
        remoteBlockGroupIndex = currentGroupIndex
    }
    
    
    
    // MARK: - Remote Group (그룹 생성, 스위칭용)
    
    /// 리모트 그룹
    private var remoteGroup = Group(name: "", color: 0x0061FD, list: [])
    
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
        remoteGroup = Group(name: "", color: 0x0061FD, list: [])
    }
}