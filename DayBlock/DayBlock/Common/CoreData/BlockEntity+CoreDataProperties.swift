//
//  BlockEntity+CoreDataProperties.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/05.
//
//

import Foundation
import CoreData

extension BlockEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BlockEntity> {
        return NSFetchRequest<BlockEntity>(entityName: "BlockEntity")
    }

    @NSManaged public var icon: String
    @NSManaged public var output: Double
    @NSManaged public var taskLabel: String

}

extension BlockEntity: Identifiable {

}
