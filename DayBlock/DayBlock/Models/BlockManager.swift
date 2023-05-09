//
//  BlockManager.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/04.
//

import UIKit

final class BlockManager {
    
    static let shared = BlockManager()
    private init() {}

    // 테스트용 그룹 리스트
    private var testGroupList: [Group] = [
        Group(name: "그룹 없음", color: UIColor(rgb: 0x323232), list: [
            Block(taskLabel: "코딩테스트 문제 풀이", output: 32.0,
                  icon: UIImage(systemName: "testtube.2")!),
            Block(taskLabel: "프로젝트 진행", output: 27.5,
                  icon: UIImage(systemName: "videoprojector.fill")!),
            Block(taskLabel: "iOS 개발팀 스탠드업", output: 8.0,
                  icon: UIImage(systemName: "iphone.gen2")!),
            Block(taskLabel: "Github 브랜치 관리", output: 124.5,
                  icon: UIImage(systemName: "folder.fill")!),
            Block(taskLabel: "Swift 문법 공부", output: 85.0,
                  icon: UIImage(systemName: "pencil")!),
        ]),
        
        Group(name: "청소", color: UIColor(rgb: 0xEE719E), list: [
            Block(taskLabel: "빗자루질", output: 32.0,
                  icon: UIImage(systemName: "sailboat.fill")!),
            Block(taskLabel: "물걸레질", output: 27.5,
                  icon: UIImage(systemName: "key.horizontal.fill")!),
            Block(taskLabel: "환기시키기", output: 8.0,
                  icon: UIImage(systemName: "signpost.right.fill")!),
            Block(taskLabel: "청소기 돌리기", output: 8.0,
                  icon: UIImage(systemName: "tent.fill")!),
        ]),
        
        Group(name: "자기계발", color: UIColor(rgb: 0x0061FD), list: [
            Block(taskLabel: "웨이트 트레이닝", output: 32.0,
                  icon: UIImage(systemName: "figure.strengthtraining.traditional")!),
            Block(taskLabel: "독서하기", output: 27.5,
                  icon: UIImage(systemName: "text.book.closed.fill")!),
            Block(taskLabel: "조깅하기", output: 8.0,
                  icon: UIImage(systemName: "figure.highintensity.intervaltraining")!),
            Block(taskLabel: "물 많이 마시기", output: 8.0,
                  icon: UIImage(systemName: "tent.fill")!),
            Block(taskLabel: "영어 공부하기", output: 8.0,
                  icon: UIImage(systemName: "lifepreserver.fill")!),
        ]),
        
        Group(name: "민톨이 키우기", color: UIColor(rgb: 0x96D35F), list: [
            Block(taskLabel: "쓰다듬어 주기", output: 32.0,
                  icon: UIImage(systemName: "camera.macro")!),
            Block(taskLabel: "사료 채우기", output: 27.5,
                  icon: UIImage(systemName: "fish.fill")!),
            Block(taskLabel: "산책 시키기", output: 8.0,
                  icon: UIImage(systemName: "pawprint.fill")!),
        ]),
        
        Group(name: "코딩", color: UIColor(rgb: 0xFEB43F), list: [
            Block(taskLabel: "1일 1커밋", output: 32.0,
                  icon: UIImage(systemName: "hourglass.circle.fill")!),
            Block(taskLabel: "오토 레이아웃 점검", output: 27.5,
                  icon: UIImage(systemName: "box.truck.fill")!),
        ]),
        
        Group(name: "인간관계", color: UIColor(rgb: 0xFF4015), list: [
            Block(taskLabel: "생일 챙기기", output: 32.0,
                  icon: UIImage(systemName: "tree.fill")!),
        ]),
    ]
    
    /// 현재 그룹 인덱스
    private var currentGroupIndex = 0
    
    /// 생성, 스위칭용 블럭
    private var remoteBlock = Group(name: "그룹 없음", color: UIColor(rgb: 0x323232), list: [Block(taskLabel: "블럭 쌓기", output: 0.0, icon: UIImage(systemName: "batteryblock.fill")!)])
    
    
    
    // MARK: - Remote Block
    
    /// 리모트 블럭(그룹) 받아오기
    func getRemoteBlock() -> Group {
        return remoteBlock
    }
    
    
    
    // MARK: - Get

    /// 전체 그룹 리스트 받아오기
    func getGroupList() -> [Group] {
        return testGroupList
    }
    
    /// 지정한 그룹에 속한 블럭 리스트 받아오기
    func getBlockList(_ index: Int) -> [Block] {
        return testGroupList[index].list
    }
    
    /// 현재 그룹 받아오기
    func getCurrentGroup() -> Group {
        return testGroupList[currentGroupIndex]
    }
    
    /// 현재 그룹 인덱스 받아오기
    func getCurrentGroupIndex() -> Int {
        return currentGroupIndex
    }
    
    /// 현재 그룹 컬러 받아오기
    func getCurrentGroupColor() -> UIColor {
        return testGroupList[currentGroupIndex].color
    }
    
    /// 현재 그룹에 속한 블럭 리스트 받아오기
    func getCurrentBlockList() -> [Block] {
        return testGroupList[currentGroupIndex].list
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
    
    
    
    // MARK: - Update
    
    /// 현재 그룹 업데이트
    func updateCurrentGroup(index: Int) {
        currentGroupIndex = index
    }
    
    /// 리모트 블럭 그룹 업데이트
    func updateRemoteBlock(group: Group) {
        remoteBlock.name = group.name
        remoteBlock.color = group.color
    }
    
    /// 리모트 블럭 라벨 업데이트
    func updateRemoteBlock(label: String) {
        remoteBlock.list[0].taskLabel = label
    }
    
    /// 리모트 블럭 아이콘 업데이트
    func updateRemoteBlock(icon: UIImage) {
        remoteBlock.list[0].icon = icon
    }
    
    /// 리모트 블럭 생산량 업데이트
    func updateRemoteBlock(output: Double) {
        remoteBlock.list[0].output = output
    }
    
    
    
    // MARK: - Create

    /// 그룹 생성
    func createGroup(name: String, color: UIColor) {
        let newGroup = Group(name: name, color: color, list: [])
        testGroupList.append(newGroup)
    }
    
    
    // MARK: - Reset

    /// 리모트 블럭 초기화
    func resetRemoteBlock() {
        let group = testGroupList[currentGroupIndex]
        
        remoteBlock = Group(name: group.name, color: group.color, list: [Block(taskLabel: "블럭 쌓기", output: 0.0, icon: UIImage(systemName: "batteryblock.fill")!)])
    }
}
