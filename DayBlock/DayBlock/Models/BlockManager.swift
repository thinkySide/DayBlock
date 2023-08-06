//
//  BlockManager.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/04.
//

import UIKit
import CoreData

final class BlockManager {
    
    static let shared = BlockManager()
    private init() {}
    
    /// CoreData Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var groupEntity: [GroupEntity] = []
    
    var blockEntity: [BlockEntity] {
        if let entity = groupEntity[currentGroupIndex].blockList?.array as? [BlockEntity] {
            return entity
        }
        
        print("blockEntity 반환 실패")
        return []
    }
    
    // private var groupList = [Group(name: "그룹 없음", color: 0x323232, list: [])]
    
    
    // MARK: - CoreData
    
    func initialSetupForCoreData() {
        if groupEntity.count == 0 {
            let newGroup = GroupEntity(context: context)
            newGroup.name = "그룹 없음"
            newGroup.color = 0x323232
            
            do {
                try context.save()
                getAllItems()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getAllItems() {
        do {
            groupEntity = try context.fetch(GroupEntity.fetchRequest())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    // MARK: - GroupList (그룹 리스트)
    
    /// 현재 그룹 인덱스
    private var currentGroupIndex = 0
    
    /// CREAT - 현재 리모트 블럭으로 새 그룹 생성
    func createNewGroup() {
        let newGroup = GroupEntity(context: context)
        newGroup.name = remoteGroup.name
        newGroup.color = remoteGroup.color
        
        do {
            try context.save()
            getAllItems()
        } catch {
            print(error.localizedDescription)
        }
        
        resetRemoteGroup()
    }
    
    /// READ - 전체 그룹 리스트 받아오기
    func getGroupList() -> [GroupEntity] {
        return groupEntity
    }
    
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
    
    /// UPDATE - 현재 그룹 업데이트
    func updateCurrentGroup(index: Int) {
        currentGroupIndex = index
    }
    
    // MARK: - Remote Block (블럭 생성, 스위치용)
    
    /// 리모트 블럭
    private var remoteBlock = Group(name: "그룹 없음", color: 0x323232, list: [Block(taskLabel: "블럭 쌓기", output: 0.0, icon: "batteryblock.fill")])
    
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
                
                do {
                    try context.save()
                    getAllItems()
                    break
                } catch {
                    print(error.localizedDescription)
                }
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
