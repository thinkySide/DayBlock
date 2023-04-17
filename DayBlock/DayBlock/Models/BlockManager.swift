//
//  BlockManager.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/04.
//

import UIKit

final class BlockManager {

    // 테스트용 그룹 리스트
    var testGroupList: [Group] = [
        Group(name: "그룹 없음", list: [
            Block(taskLabel: "코딩테스트 문제 풀이",
                  icon: UIImage(systemName: "testtube.2")!, output: 32.0, color: Color.testBlue),
            Block(taskLabel: "프로젝트 진행",
                  icon: UIImage(systemName: "videoprojector.fill")!, output: 27.5, color: Color.testPink),
            Block(taskLabel: "iOS 개발팀 스탠드업",
                  icon: UIImage(systemName: "iphone.gen2")!, output: 8.0, color: Color.testGreen),
            Block(taskLabel: "Github 브랜치 관리",
                  icon: UIImage(systemName: "folder.fill")!, output: 124.5, color: Color.testYellow),
            Block(taskLabel: "Swift 문법 공부",
                  icon: UIImage(systemName: "pencil")!, output: 85.0, color: Color.testBlue),
        ]),
        
        Group(name: "운동", list: [
            Block(taskLabel: "팔굽혀펴기",
                  icon: UIImage(systemName: "testtube.2")!, output: 32.0, color: Color.testBlue),
            Block(taskLabel: "윗몸 일으키기",
                  icon: UIImage(systemName: "videoprojector.fill")!, output: 27.5, color: Color.testPink),
            Block(taskLabel: "조깅하기",
                  icon: UIImage(systemName: "iphone.gen2")!, output: 8.0, color: Color.testGreen),
        ]),
        
        Group(name: "민톨이", list: [
            Block(taskLabel: "산책시키기",
                  icon: UIImage(systemName: "testtube.2")!, output: 32.0, color: Color.testBlue),
            Block(taskLabel: "사료 채워넣기",
                  icon: UIImage(systemName: "videoprojector.fill")!, output: 27.5, color: Color.testPink),
            Block(taskLabel: "장난감으로 놀아주기",
                  icon: UIImage(systemName: "iphone.gen2")!, output: 8.0, color: Color.testGreen),
            Block(taskLabel: "간식으로 훈련시키기",
                  icon: UIImage(systemName: "iphone.gen2")!, output: 8.0, color: Color.testGreen),
        ]),
    ]
    
    /// 블럭 생성용
    var creation = Group(name: "그룹 없음", list: [Block(taskLabel: "블럭 쌓기", icon: UIImage(systemName: "batteryblock.fill")!, output: 0.0, color: Color.testBlue)])
    
    
    
    // MARK: - Get Method

    /// 그룹 리스트 받아오기
    func getGroupList() -> [Group] {
        return testGroupList
    }
    
    /// 그룹 리스트 개수 받아오기
    func getGroupListCount() -> Int {
        return testGroupList.count
    }
    
    /// 그룹에 속한 블럭 리스트 받아오기
    func getBlockList(_ groupName: String) -> [Block] {
        let group = testGroupList.filter { $0.name == groupName }
        return group[0].list
    }
    
    /// 그룹에 속한 블럭 리스트 개수 받아오기
    func getBlockListCount(_ groupName: String) -> Int {
        let group = testGroupList.filter { $0.name == groupName }
        return group[0].list.count
    }
    
    /// taskLabel로 블럭 가져오기
    func getBlock(_ taskLabel: String) -> Block? {
        for group in testGroupList {
            let block = group.list.filter { $0.taskLabel == taskLabel }
            return block[0]
        }
        print("블럭을 찾을 수 없습니다.")
        return nil
    }
}
