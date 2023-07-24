//
//  Block.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/03.
//

import UIKit

// CoreData를 위한 커스텀 클래스 정의
class Block: NSObject, NSCoding {
    
    var taskLabel: String
    var output: Double
    var icon: String
    
    init(taskLabel: String, output: Double, icon: String) {
        self.taskLabel = taskLabel
        self.output = output
        self.icon = icon
    }
    
    // NSCoding 프로토콜 준수
    func encode(with coder: NSCoder) {
        coder.encode(taskLabel, forKey: "taskLabel")
        coder.encode(output, forKey: "output")
        coder.encode(icon, forKey: "icon")
    }
    
    required init?(coder: NSCoder) {
        taskLabel = coder.decodeObject(forKey: "taskLabel") as? String ?? ""
        output = coder.decodeObject(forKey: "output") as? Double ?? 0
        icon = coder.decodeObject(forKey: "icon") as? String ?? ""
    }
}
