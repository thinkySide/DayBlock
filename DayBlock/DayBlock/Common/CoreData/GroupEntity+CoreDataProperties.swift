//
//  GroupEntity+CoreDataProperties.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/05.
//
//

import Foundation
import CoreData

extension GroupEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GroupEntity> {
        return NSFetchRequest<GroupEntity>(entityName: "GroupEntity")
    }

    @NSManaged public var color: Int
    @NSManaged public var name: String
    @NSManaged public var blockList: NSOrderedSet?

}

// MARK: Generated accessors for blockList
extension GroupEntity {

    @objc(insertObject:inBlockListAtIndex:)
    @NSManaged public func insertIntoBlockList(_ value: BlockEntity, at idx: Int)

    @objc(removeObjectFromBlockListAtIndex:)
    @NSManaged public func removeFromBlockList(at idx: Int)

    @objc(insertBlockList:atIndexes:)
    @NSManaged public func insertIntoBlockList(_ values: [BlockEntity], at indexes: NSIndexSet)

    @objc(removeBlockListAtIndexes:)
    @NSManaged public func removeFromBlockList(at indexes: NSIndexSet)

    @objc(replaceObjectInBlockListAtIndex:withObject:)
    @NSManaged public func replaceBlockList(at idx: Int, with value: BlockEntity)

    @objc(replaceBlockListAtIndexes:withBlockList:)
    @NSManaged public func replaceBlockList(at indexes: NSIndexSet, with values: [BlockEntity])

    @objc(addBlockListObject:)
    @NSManaged public func addToBlockList(_ value: BlockEntity)

    @objc(removeBlockListObject:)
    @NSManaged public func removeFromBlockList(_ value: BlockEntity)

    @objc(addBlockList:)
    @NSManaged public func addToBlockList(_ values: NSOrderedSet)

    @objc(removeBlockList:)
    @NSManaged public func removeFromBlockList(_ values: NSOrderedSet)

}

extension GroupEntity: Identifiable {

}
