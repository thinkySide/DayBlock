//
//  BlockManager.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/04.
//

import UIKit

final class BlockManager {
    private var testBlockList: [BlockGroup] = [
        
        BlockGroup(name: "그룹 없음", list: [
            Block(taskLabel: "코딩테스트 문제 풀이", icon: UIImage(systemName: "testtube.2")!, output: 32, color: Color.testBlue),
            Block(taskLabel: "프로젝트 진행", icon: UIImage(systemName: "videoprojector.fill")!, output: 27.5, color: Color.testPink),
            Block(taskLabel: "iOS 개발팀 스탠드업", icon: UIImage(systemName: "iphone.gen2")!, output: 8, color: Color.testGreen),
            Block(taskLabel: "Github 브랜치 관리", icon: UIImage(systemName: "folder.fill")!, output: 124.5, color: Color.testYellow),
            Block(taskLabel: "Swift 문법 공부", icon: UIImage(systemName: "pencil")!, output: 85, color: Color.testBlue),
        ]),
        
        BlockGroup(name: "자기계발", list: [
            Block(taskLabel: "코딩테스트 문제 풀이", icon: UIImage(systemName: "testtube.2")!, output: 32, color: Color.testBlue),
            Block(taskLabel: "프로젝트 진행", icon: UIImage(systemName: "videoprojector.fill")!, output: 27.5, color: Color.testPink),
            Block(taskLabel: "iOS 개발팀 스탠드업", icon: UIImage(systemName: "iphone.gen2")!, output: 8, color: Color.testGreen),
            Block(taskLabel: "Github 브랜치 관리", icon: UIImage(systemName: "folder.fill")!, output: 124.5, color: Color.testYellow),
            Block(taskLabel: "Swift 문법 공부", icon: UIImage(systemName: "pencil")!, output: 85, color: Color.testBlue),
        ]),
        
        BlockGroup(name: "청소 빨래", list: [
            Block(taskLabel: "코딩테스트 문제 풀이", icon: UIImage(systemName: "testtube.2")!, output: 32, color: Color.testBlue),
            Block(taskLabel: "프로젝트 진행", icon: UIImage(systemName: "videoprojector.fill")!, output: 27.5, color: Color.testPink),
            Block(taskLabel: "iOS 개발팀 스탠드업", icon: UIImage(systemName: "iphone.gen2")!, output: 8, color: Color.testGreen),
            Block(taskLabel: "Github 브랜치 관리", icon: UIImage(systemName: "folder.fill")!, output: 124.5, color: Color.testYellow),
            Block(taskLabel: "Swift 문법 공부", icon: UIImage(systemName: "pencil")!, output: 85, color: Color.testBlue),
        ]),
        
        BlockGroup(name: "iOS 개발 공부", list: [
            Block(taskLabel: "코딩테스트 문제 풀이", icon: UIImage(systemName: "testtube.2")!, output: 32, color: Color.testBlue),
            Block(taskLabel: "프로젝트 진행", icon: UIImage(systemName: "videoprojector.fill")!, output: 27.5, color: Color.testPink),
            Block(taskLabel: "iOS 개발팀 스탠드업", icon: UIImage(systemName: "iphone.gen2")!, output: 8, color: Color.testGreen),
            Block(taskLabel: "Github 브랜치 관리", icon: UIImage(systemName: "folder.fill")!, output: 124.5, color: Color.testYellow),
            Block(taskLabel: "Swift 문법 공부", icon: UIImage(systemName: "pencil")!, output: 85, color: Color.testBlue),
        ]),
        
        BlockGroup(name: "일상생활", list: [
            Block(taskLabel: "코딩테스트 문제 풀이", icon: UIImage(systemName: "testtube.2")!, output: 32, color: Color.testBlue),
            Block(taskLabel: "프로젝트 진행", icon: UIImage(systemName: "videoprojector.fill")!, output: 27.5, color: Color.testPink),
            Block(taskLabel: "iOS 개발팀 스탠드업", icon: UIImage(systemName: "iphone.gen2")!, output: 8, color: Color.testGreen),
            Block(taskLabel: "Github 브랜치 관리", icon: UIImage(systemName: "folder.fill")!, output: 124.5, color: Color.testYellow),
            Block(taskLabel: "Swift 문법 공부", icon: UIImage(systemName: "pencil")!, output: 85, color: Color.testBlue),
        ]),
        
        BlockGroup(name: "민톨이", list: [
            Block(taskLabel: "코딩테스트 문제 풀이", icon: UIImage(systemName: "testtube.2")!, output: 32, color: Color.testBlue),
            Block(taskLabel: "프로젝트 진행", icon: UIImage(systemName: "videoprojector.fill")!, output: 27.5, color: Color.testPink),
            Block(taskLabel: "iOS 개발팀 스탠드업", icon: UIImage(systemName: "iphone.gen2")!, output: 8, color: Color.testGreen),
            Block(taskLabel: "Github 브랜치 관리", icon: UIImage(systemName: "folder.fill")!, output: 124.5, color: Color.testYellow),
            Block(taskLabel: "Swift 문법 공부", icon: UIImage(systemName: "pencil")!, output: 85, color: Color.testBlue),
        ]),
    ]
    
    /// 블럭 생성용 더미
    var createBlock = BlockGroup(name: "기본 그룹", list: [
        Block(taskLabel: "블럭 쌓기",icon: UIImage(systemName: "batteryblock.fill")!, output: 0, color: Color.testBlue)
    ])
    
    func getBlockList(_ groupName: String) -> BlockGroup {
        
        /// 그룹 이름과 일치하면 반환
        for blockGroup in testBlockList {
            if blockGroup.name == groupName { return blockGroup }
        }
        
        return BlockGroup(name: "그룹 없음")
    }
    
    func getBlockGroupList() -> [BlockGroup] {
        return testBlockList
    }
}
