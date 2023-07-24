//
//  GroupEntity+CoreDataProperties.swift
//  DayBlock
//
//  Created by 김민준 on 2023/07/24.
//
//

import Foundation
import CoreData


extension GroupEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GroupEntity> {
        return NSFetchRequest<GroupEntity>(entityName: "GroupEntity")
    }

    @NSManaged public var color: Int64
    @NSManaged public var list: [NSObject]?
    @NSManaged public var name: String?

}

extension GroupEntity : Identifiable {

}
