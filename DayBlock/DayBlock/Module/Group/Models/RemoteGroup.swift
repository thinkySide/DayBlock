//
//  RemoteGroup.swift
//  DayBlock
//
//  Created by 김민준ㅏ기 on 2023/04/03.
//

import UIKit

struct RemoteGroup {
    var name: String
    var color: Int
    var list: [RemoteBlock]
    
    /// 기본값 생성자
    init(name: String = "기본 그룹",
         color: Int = 0x323232,
         list: [RemoteBlock] = [RemoteBlock(taskLabel: "블럭 쌓기", todayOutput: 0.0, icon: "batteryblock.fill")]) {
        self.name = name
        self.color = color
        self.list = list
    }
}
