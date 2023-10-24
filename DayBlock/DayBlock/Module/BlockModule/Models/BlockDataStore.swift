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
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /// 블럭 엔티티
    private var entities: [Block] = []
    
    /// 리모트 객체
    private var remoteObject = RemoteGroup()
    
    /// 리모트 객체 인덱스
    var remoteIndex = 0
    
    /// 현재 포커스 중인 블럭 인덱스
    private var focusIndexValue = 0
    
    /// 현재 관리 중인 블럭 인덱스
    private var manageIndexValue = 0
    
    /// 그룹 데이터 객체
    /// ⚠️ 결합도가 높아지지만 구현을 위해 우선 이렇게 사용해보기
    private let groupData = GroupDataStore.shared
}

// MARK: - CRUD Block Method
extension BlockDataStore {
    
    // MARK: - 1. CREATE
    
    /// 현재 리모트 객체의 정보로 새 블럭을 생성합니다.
    func create() {
        for (index, groups) in groupData.list().enumerated() where remoteObject.name == groups.name {
            
            // 1. 블럭 엔티티 생성
            let newBlock = Block(context: context)
            newBlock.taskLabel = remoteBlock().taskLabel
            newBlock.todayOutput = remoteBlock().todayOutput
            newBlock.icon = remoteBlock().icon
            newBlock.order = listInSelectedGroup(at: groupData.focusIndex()).count
            
            // 2. 그룹 데이터 업데이트 및 저장
            groupData.updateFocusIndex(to: index)
            groupData.focusEntity().addToBlockList(newBlock)
            groupData.saveContext()
        }
    }
    
    /// 현재 리모트 객체의 정보로 새 블럭을 생성합니다. (관리 모드)
    func createForManageMode() {
        for (index, groups) in groupData.list().enumerated() where remoteObject.name == groups.name {
            
            // 1. 블럭 엔티티 생성
            let newBlock = Block(context: context)
            newBlock.taskLabel = remoteBlock().taskLabel
            newBlock.todayOutput = remoteBlock().todayOutput
            newBlock.icon = remoteBlock().icon
            newBlock.order = listInSelectedGroup(at: groupData.manageIndex()).count
            
            // 2. 그룹 데이터 업데이트 및 저장
            groupData.list()[index].addToBlockList(newBlock)
            groupData.saveContext()
        }
    }
    
    // MARK: - 2. READ
    
    /// 블럭 리스트를 반환합니다.
    func list() -> [Block] {
        
        // 현재 그룹 인덱스값을 이용해 그룹 엔티티에서 블럭 엔티티값 반환
        if let entity = groupData.focusEntity().blockList?.array as? [Block] {
            entities = entity.sorted { $0.order < $1.order }
            return entities
        }
        
        fatalError("Error: block Entity 반환 실패")
    }
    
    /// 관리 중인 블럭 리스트를 반환합니다.
    func manageList() -> [Block] {
        
        if let manageEntities = groupData.manageEntity().blockList?.array as? [Block] {
            return manageEntities.sorted { $0.order < $1.order }
        }
        
        fatalError("Manage Block Entity 반환 실패")
    }
    
    /// 지정한 인덱스와 일치하는 그룹에 속한 블럭 리스트를 반환합니다.
    ///
    /// - Parameter index: 지정할 그룹 인덱스
    func listInSelectedGroup(at index: Int) -> [Block] {
        let group = groupData.list()[index]
        if let blockList = group.blockList?.array as? [Block] {
            return blockList.sorted { $0.order < $1.order }
        }
        
        print("\(#function): 인덱스에 일치하는 블럭 리스트가 없습니다.")
        return []
    }
    
    /// 지정한 그룹명과 일치하는 블럭 리스트를 반환합니다.
    ///
    /// - Parameter groupName: 지정할 그룹명
    func listInSelectedGroup(with groupName: String) -> [Block] {
        for group in groupData.list() where group.name == groupName {
            if let blockList = group.blockList?.array as? [Block] {
                return blockList.sorted { $0.order < $1.order }
            }
        }
        
        print("\(#function): 그룹명에 일치하는 블럭 리스트가 없습니다.")
        return []
    }
    
    // MARK: - 3. UPDATE
    
    /// 블럭 수정 완료 후 블럭 엔티티를 업데이트합니다.
    func update() {
        
        // 1. 리모트 블럭을 통한 블럭 엔티티 생성
        let updateBlock = Block(context: context)
        updateBlock.taskLabel = remoteBlock().taskLabel
        updateBlock.icon = remoteBlock().icon
        
        // 2. 기존 트래킹 데이터 업데이트
        if let trackingDateList = focusEntity().trackingDateList?.array as? [TrackingDate] {
            for trackingDate in trackingDateList {
                updateBlock.addToTrackingDateList(trackingDate)
            }
        }

        // 3-1. 그룹이 동일한 경우
        //      - 블럭 엔티티 현재 인덱스에 삽입 후
        //      - 기존 블럭 엔티티 삭제
        if groupData.focusIndex() == remoteIndex {
            groupData.focusEntity().insertIntoBlockList(updateBlock, at: focusIndexValue)
            delete(list()[focusIndexValue + 1])
        }
        
        // 3-2. 그룹이 이동된 경우
        //      - 현재 인덱스의 블럭 엔티티 삭제 후
        //      - 리모트 그룹 인덱스의 가장 마지막 인덱스에 블럭 엔티티 삽입
        //      - 현재 블럭 인덱스 업데이트(화면 이동용)
        if groupData.focusIndex() != remoteIndex {
            delete(focusEntity())
            if let entity = groupData.list()[remoteIndex].blockList?.array as? [Block] {
                groupData.list()[remoteIndex].insertIntoBlockList(updateBlock, at: entity.count)
                updateFocusIndex(to: entity.count)
                groupData.updateFocusIndex(to: remoteIndex)
            }
        }

        // 3. 그룹 데이터 저장
        groupData.saveContext()
    }
    
    /// 블럭 관리 모드에서 블럭 수정 완료 후 엔티티를 업데이트합니다.
    func updateForManageMode() {
        
        // 1. 리모트 블럭을 통한 블럭 엔티티 생성
        let updateBlock = Block(context: context)
        updateBlock.taskLabel = remoteBlock().taskLabel
        updateBlock.icon = remoteBlock().icon
        
        // 2. 기존 트래킹 데이터 업데이트
        if let trackingDateList = manageEntity().trackingDateList?.array as? [TrackingDate] {
            for trackingDate in trackingDateList {
                updateBlock.addToTrackingDateList(trackingDate)
            }
        }
        
        // 3-1. 그룹이 동일한 경우
        //      - 블럭 엔티티 현재 인덱스에 삽입 후
        //      - 기존 블럭 엔티티 삭제
        if groupData.manageIndex() == remoteIndex {
            groupData.manageEntity().insertIntoBlockList(updateBlock, at: manageIndexValue)
            delete(manageList()[manageIndexValue + 1])
        }
        
        // 3-2. 그룹이 이동된 경우
        //      - 현재 인덱스의 블럭 엔티티 삭제 후
        //      - 리모트 그룹 인덱스의 가장 마지막 인덱스에 블럭 엔티티 삽입
        //      - 현재 블럭 인덱스 업데이트(화면 이동용)
        if groupData.manageIndex() != remoteIndex {
            delete(manageEntity())
            if let entity = groupData.list()[remoteIndex].blockList?.array as? [Block] {
                groupData.list()[remoteIndex].insertIntoBlockList(updateBlock, at: entity.count)
            }
        }
        
        // 3. 그룹 데이터 저장
        groupData.saveContext()
    }
    
    /// 블럭 셀의 위치를 변경합니다.
    func moveCell(_ source: IndexPath, _ destination: IndexPath) {
        
        // 1. 처음, 이동할 위치의 블럭 리스트
        let sourceGroup = groupData.list()[source.section]
        let sourceList = listInSelectedGroup(at: source.section)
        
        let destinationGroup = groupData.list()[destination.section]
        let destinationList = listInSelectedGroup(at: destination.section)
        
        // 2. 이동할 블럭 저장
        let targetBlock = sourceList[source.row]
        let saveBlock = Block(context: context)
        saveBlock.taskLabel = targetBlock.taskLabel
        saveBlock.icon = targetBlock.icon
        saveBlock.todayOutput = targetBlock.todayOutput
        saveBlock.superGroup = targetBlock.superGroup
        saveBlock.trackingDateList = targetBlock.trackingDateList
        
        // 이동할 블럭 삭제
        sourceGroup.removeFromBlockList(sourceList[source.row])
        context.delete(sourceList[source.row])
        
        // 이동할 블럭 해당 인덱스에 끼워넣기
        destinationGroup.insertIntoBlockList(saveBlock, at: destination.row)
        
        // 3-1. 만약 그룹 내 블럭 이동이라면
        if source.section == destination.section {
            print("같은 그룹으로 이동")
            
            for block in destinationList {
                
                // 아래로 셀이 내려갔을 때
                if source.row < destination.row {
                    if block.order > source.row && block.order <= destination.row {
                        block.order -= 1
                    }
                }
                
                // 위로 셀이 올라갔을 때
                else if source.row > destination.row {
                    if block.order < source.row && block.order >= destination.row {
                        block.order += 1
                    }
                }
            }
            
            saveBlock.order = destination.row
        }
        
        // 3-2. 만약 그룹 외 블럭 이동이라면
        else if source.section != destination.section {
            print("다른 그룹으로 이동")
            
            // 그룹 이동에 따른 인덱스 조정
            for block in sourceList where source.row < block.order {
                block.order -= 1
            }
            
            for block in destinationList where destination.row <= block.order {
                block.order += 1
            }
            
            saveBlock.order = destination.row
        }
        
        // 4. 코어데이터 저장
        groupData.saveContext()
    }
    
    /// 일반 편집 모드에서 블럭의 order값을 일괄적으로 업데이트합니다.
    func updateOrder() {
        let blockList = listInSelectedGroup(at: groupData.focusIndex())
        
        // 현재 선택한 블럭의 인덱스보다 큰 order값을 가진 블럭들만 업데이트
        for block in blockList where block.order > focusIndexValue {
            block.order -= 1
        }
    }
    
    /// 관리 편집 모드에서 블럭의 order 값을 일괄적으로 업데이트합니다.
    func updateOrderForManageMode() {
        let blockList = listInSelectedGroup(at: groupData.manageIndex())
        
        // 현재 선택한 블럭의 인덱스보다 큰 order값을 가진 블럭들만 업데이트
        for block in blockList where block.order > manageIndexValue {
            block.order -= 1
        }
    }
    
    // MARK: - 4. DELETE
    
    /// 지정한 블럭엔티티를 삭제합니다.
    ///
    /// - Parameter blockEntity: 삭제할 블럭 엔티티
    func delete(_ blockEntity: Block) {
        groupData.focusEntity().removeFromBlockList(blockEntity)
        context.delete(blockEntity)
        groupData.saveContext()
    }
}

// MARK: - Focus Block Method
extension BlockDataStore {
    
    /// 현재 포커스 된 블럭을 반환합니다.
    func focusEntity() -> Block {
        return list()[focusIndexValue]
    }
    
    /// 현재 포커스 된 블럭 인덱스를 반환합니다.
    func focusIndex() -> Int {
        return focusIndexValue
    }
    
    /// 지정된 인덱스로 블럭 인덱스를 업데이트합니다.
    ///
    /// - Parameter index: 업데이트 할 인덱스 값
    func updateFocusIndex(to index: Int) {
        focusIndexValue = index
    }
}

// MARK: - Remote Block (블럭 생성, 스위치용)
extension BlockDataStore {
    
    /// 리모트 객체를 반환합니다.
    func remote() -> RemoteGroup {
        return remoteObject
    }
    
    /// 리모트 블럭(리모트 객체의 블럭)을 반환합니다.
    func remoteBlock() -> RemoteBlock {
        return remoteObject.list[0]
    }
    
    /// 리모트 객체의 그룹명을 반환합니다.
    func remoteName() -> String {
        return remoteObject.name
    }
    
    /// 리모트 객체의 그룹 컬러를 반환합니다.
    func remoteColor() -> UIColor {
        return UIColor(rgb: remoteObject.color)
    }
    
    /// 리모트 블럭의 아이콘을 반환합니다.
    func remoteBlockIcon() -> UIImage {
        return UIImage(systemName: remoteBlock().icon)!
    }
    
    /// 지정한 그룹으로 리모트 객체를 업데이트합니다.
    ///
    /// - Parameter group: 업데이트 할 그룹
    func updateRemote(group: Group) {
        remoteObject.name = group.name
        remoteObject.color = group.color
    }
    
    /// 리모트 블럭의 라벨을 업데이트합니다.
    ///
    /// - Parameter label: 업데이트 할 라벨 문자열
    func updateRemoteBlock(label: String) {
        remoteObject.list[0].taskLabel = label
    }
    
    /// 리모트 블럭의 아이콘을 업데이트합니다.
    ///
    /// - Parameter icon: 업데이트 할 아이콘 문자열
    func updateRemoteBlock(icon: String) {
        remoteObject.list[0].icon = icon
    }
    
    /// 리모트 블럭의 오늘의 생산량을 업데이트합니다.
    ///
    /// - Parameter todayOutput: 업데이트 할 오늘의 생산량 값
    func updateRemoteBlock(todayOutput: Double) {
        remoteObject.list[0].todayOutput = todayOutput
    }
    
    /// 리모트 객체를 기본값으로 초기화합니다.
    func resetRemote() {
        let group = groupData.focusEntity()
        remoteObject = RemoteGroup(name: group.name, color: group.color)
        remoteIndex = groupData.focusIndex()
    }
}

// MARK: - Manage Index
extension BlockDataStore {
    
    /// 현재 관리 중인 블럭을 반환합니다.
    func manageEntity() -> Block {
        return manageList()[manageIndexValue]
    }
    
    /// 관리 중인 블럭 인덱스를 반환합니다.
    func manageIndex() -> Int {
        return manageIndexValue
    }
    
    /// 지정된 인덱스로 관리 블럭 인덱스를 업데이트합니다.
    ///
    /// - Parameter index: 업데이트 할 인덱스 값
    func updateManageIndex(to index: Int) {
        manageIndexValue = index
    }
}
