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
    
    /// Request
    let fetchReQuest = Group.fetchRequest()
    
    /// 그룹 엔티티
    private var entities: [Group] = []
    
    /// 리모트 그룹 (그룹 생성, 편집 용도의 객체)
    private var remoteObject = RemoteGroup(name: "", color: 0x0061FD, list: [])
    
    /// 현재 포커스된 그룹 인덱스
    private var focusIndexValue = 0
    
    /// 현재 편집중인 그룹 인덱스
    private var editIndexValue = 0
    
    /// 관리 중인 그룹 인덱스
    private var manageIndexValue = 0
}

// MARK: - Core Data Method
extension GroupDataStore {
    
    /// 콘텍스트 저장 및 그룹 엔티티를 패치합니다.
    func saveContext() {
        do {
            try context.save()
            fetchRequestEntity()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// 그룹 엔티티 패치를 요청합니다.
    private func fetchRequestEntity() {
        
        // order 속성 기준 오름차순 정렬
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        fetchReQuest.sortDescriptors = [sortDescriptor]
        
        do {
            entities = try context.fetch(fetchReQuest)
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
    
    /// 지정한 월에 속하는 모든 코어 데이터를 반환합니다.
    func fetchAllMonthDateItem(for date: Date) -> [RepositoryItem] {
        
        // 1. 날짜 변환
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.dateFormat = "yyyy MM"
        let dateFormat = formatter.string(from: date).components(separatedBy: " ")
        let year = dateFormat[0]
        let month = dateFormat[1]
        
        // 반환할 빈배열 생성
        var items: [RepositoryItem] = []
        
        // 2. 코어데이터에서 해당 날짜와 일치하는 데이터 반환
        for group in entities {
            guard let blockList = group.blockList?.array as? [Block] else {
                print("블럭 리스트 반환 실패")
                return []
            }
            
            for block in blockList {
                guard let trackingDateList = block.trackingDateList?.array as? [TrackingDate] else {
                    print("트래킹 날짜 리스트 반환 실패")
                    return []
                }
                
                for trackingDate in trackingDateList {
                    if trackingDate.year == year && trackingDate.month == month {
                        guard let trackingTimeList = trackingDate.trackingTimeList?.array as? [TrackingTime] else {
                            print("트래킹 시간 리스트 반환 실패")
                            return []
                        }
                        
                        let repositoryItem = RepositoryItem(
                            groupName: group.name,
                            groupColor: group.color,
                            blockTaskLabel: block.taskLabel,
                            blockIcon: block.icon,
                            trackingDate: trackingDate,
                            trackingTimes: trackingTimeList
                        )
                        
                        items.append(repositoryItem)
                    }
                }
            }
        }
        
        return items
    }
    
    /// 전체 코어데이터를 프린트합니다.
    func printCoreData() {
        
        // 1. 그룹 엔티티
        for group in entities {
            print("[\(group.name)] 그룹")
            
            // 2. 블럭 엔티티
            guard let blockList = group.blockList?.array as? [Block] else {
                print("블럭 엔티티 반환 실패")
                return
            }
            
            for block in blockList {
                print("  ㄴ[\(block.taskLabel)] 블럭")
                
                // 3. 트래킹 날짜 엔티티
                guard let trackingDateList = block.trackingDateList?.array as? [TrackingDate] else {
                    print("트래킹 날짜 엔티티 반환 실패")
                    return
                }
                
                for trackingDate in trackingDateList {
                    print("    ㄴ\(trackingDate.year)년 \(trackingDate.month)월 \(trackingDate.day)일(\(trackingDate.dayOfWeek))")
                    
                    // 4. 트래킹 시간 엔티티
                    guard let trackingTimeList = trackingDate.trackingTimeList?.array as? [TrackingTime] else {
                        print("트래킹 시간 엔티티 반환 실패")
                        return
                    }
                    
                    for trackingTime in trackingTimeList {
                        print("      ㄴ\(trackingTime.startTime)~\(String(describing: trackingTime.endTime))")
                    }
                }
            }
            
            print("\n----------------------------------\n")
        }
    }
}

// MARK: - CRUD Method
extension GroupDataStore {
    
    /// Remote 그룹을 통해 새 그룹을 생성합니다.
    func create() {
        
        // 리모트 그룹을 통한 그룹 엔티티 생성
        let newGroup = Group(context: context)
        newGroup.name = remoteObject.name
        newGroup.color = remoteObject.color
        newGroup.order = entities.count
        
        // 콘텍스트 저장 및 리모트 그룹 초기화
        saveContext()
        resetRemote()
    }
    
    /// 그룹 리스트를 반환합니다.
    func list() -> [Group] {
        return entities
    }
    
    /// 그룹의 이름을 업데이트합니다.
    func update(name: String) {
        let group = entities[editIndexValue]
        group.name = name
        group.color = remoteObject.color
        saveContext()
    }
    
    /// 현재 편집 중인 그룹을 삭제합니다.
    func delete() {
        context.delete(entities[editIndexValue])
        saveContext()
    }
    
    /// 그룹 셀의 위치를 변경합니다.
    func moveCell(_ sourceRow: Int, _ destinationRow: Int) {
        
        // 이동할 그룹 삭제 후 insert
        let moveGroup = entities.remove(at: sourceRow)
        entities.insert(moveGroup, at: destinationRow)
        
        for (index, group) in entities.enumerated() {
            group.order = index
        }
        
        saveContext()
    }
    
    /// 모든 코어데이터를 초기화합니다.
    func resetAllData() {
        
        // 1. 전체 엔티티 삭제
        for entity in self.entities {
            context.delete(entity)
        }
        
        // 2. 기본 그룹 재생성
        let newGroup = Group(context: context)
        newGroup.name = "기본 그룹"
        newGroup.color = 0x323232
        
        saveContext()
    }
}

// MARK: - Focus Group Method
extension GroupDataStore {
    
    /// 현재 포커스된 그룹을 반환합니다.
    func focusEntity() -> Group {
        return entities[focusIndexValue]
    }
    
    /// 현재 포커스된 그룹 인덱스를 반환합니다.
    func focusIndex() -> Int {
        return focusIndexValue
    }
    
    /// 지정한 인덱스로 포커스된 그룹 인덱스를 업데이트합니다.
    ///
    /// - Parameter index: 업데이트 할 인덱스 값
    func updateFocusIndex(to index: Int) {
        focusIndexValue = index
    }
    
    /// 현재 포커스된 그룹의 컬러를 반환합니다.
    func focusColor() -> UIColor {
        return UIColor(rgb: entities[focusIndexValue].color)
    }
}

// MARK: - Edit Group Method
extension GroupDataStore {
    
    /// 편집 중인 그룹의 인덱스를 반환합니다.
    func editIndex() -> Int {
        return editIndexValue
    }
    
    /// 지정한 인덱스로 편집 중인 그룹 인덱스를 업데이트합니다.
    ///
    /// - Parameter index: 업데이트 할 인덱스 값
    func updateEditIndex(to index: Int) {
        editIndexValue = index
    }
}

// MARK: - Remote Group
extension GroupDataStore {
    
    /// 리모트 그룹을 반환합니다.
    func remote() -> RemoteGroup {
        return remoteObject
    }
    
    /// 리모트 그룹의 그룹명을 업데이트합니다.
    ///
    /// - Parameter name: 업데이트 할 그룹명
    func updateRemote(name: String) {
        remoteObject.name = name
    }
    
    /// 리모트 그룹의 컬러를 업데이트합니다.
    ///
    /// - Parameter color: 업데이트 할 색상값
    func updateRemote(color: Int) {
        remoteObject.color = color
    }
    
    /// 리모트 그룹을 기본값으로 초기화합니다.
    func resetRemote() {
        remoteObject = RemoteGroup(name: "", color: 0x0061FD, list: [])
    }
}

// MARK: - Manage Group Index
extension GroupDataStore {
    
    /// 현재 관리 중인 그룹을 반환합니다.
    func manageEntity() -> Group {
        return entities[manageIndexValue]
    }
    
    /// 관리 중인 그룹의 인덱스를 반환합니다.
    func manageIndex() -> Int {
        return manageIndexValue
    }
    
    /// 지정한 인덱스로 관리  중인 그룹 인덱스를 업데이트합니다.
    ///
    /// - Parameter index: 업데이트 할 인덱스 값
    func updateManageIndex(to index: Int) {
        manageIndexValue = index
    }
}
