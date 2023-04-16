//
//  BlockManager.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/04.
//

import UIKit

final class BlockManager {
    
    private var testGroupList: [Int:Group] = [
        Group(name: "그룹 없음"),
        Group(name: "자기 계발"),
        Group(name: "청소 빨래 "),
        Group(name: "iOS 개발 공부"),
        Group(name: "일상생활"),
        Group(name: "민톨이"),
    ]
    
    private lazy var testBlockList: [Group:[Block]] = [
       testGroupList[0] : [
        Block(taskLabel: "코딩테스트 문제 풀이", icon: UIImage(systemName: "testtube.2")!, output: 32, color: Color.testBlue)],
    ]
    
//    private var oldTestBlockList: [BlockGroup] = [
//
//        BlockGroup(name: "그룹 없음", list: [
//            Block(taskLabel: "코딩테스트 문제 풀이", icon: UIImage(systemName: "testtube.2")!, output: 32, color: Color.testBlue),
//            Block(taskLabel: "프로젝트 진행", icon: UIImage(systemName: "videoprojector.fill")!, output: 27.5, color: Color.testPink),
//            Block(taskLabel: "iOS 개발팀 스탠드업", icon: UIImage(systemName: "iphone.gen2")!, output: 8, color: Color.testGreen),
//            Block(taskLabel: "Github 브랜치 관리", icon: UIImage(systemName: "folder.fill")!, output: 124.5, color: Color.testYellow),
//            Block(taskLabel: "Swift 문법 공부", icon: UIImage(systemName: "pencil")!, output: 85, color: Color.testBlue),
//        ]),
//    ]
    
    /// 블럭 생성용 더미
//    var createBlock = BlockGroup(name: "기본 그룹", list: [
//        Block(taskLabel: "블럭 쌓기",icon: UIImage(systemName: "batteryblock.fill")!, output: 0, color: Color.testBlue)
//    ])
    
    func getBlockList(_ groupName: String) -> [Block] {
        return testBlockList
    }
    
    func getBlockGroupList() -> [Group] {
        return testGroupList
    }
}
