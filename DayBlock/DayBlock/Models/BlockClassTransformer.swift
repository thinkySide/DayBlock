//
//  BlockClassTransformer.swift
//  DayBlock
//
//  Created by 김민준 on 2023/07/24.
//

import CoreData

class BlockClassTransformer: NSSecureUnarchiveFromDataTransformer {
    static let name = NSValueTransformerName(rawValue: String(describing: BlockClassTransformer.self))
    
    override class var allowedTopLevelClasses: [AnyClass] {
        return [Block.self]
    }
    
    static func register() {
        let transformer = BlockClassTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
