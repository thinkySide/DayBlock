//
//  Group+CoreDataProperties.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/21.
//
//

import Foundation
import CoreData

extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var color: Int
    @NSManaged public var name: String
    @NSManaged public var blockList: NSOrderedSet?

}

// MARK: Generated accessors for blockList
extension Group {

    @objc(insertObject:inBlockListAtIndex:)
    @NSManaged public func insertIntoBlockList(_ value: Block, at idx: Int)

    @objc(removeObjectFromBlockListAtIndex:)
    @NSManaged public func removeFromBlockList(at idx: Int)

    @objc(insertBlockList:atIndexes:)
    @NSManaged public func insertIntoBlockList(_ values: [Block], at indexes: NSIndexSet)

    @objc(removeBlockListAtIndexes:)
    @NSManaged public func removeFromBlockList(at indexes: NSIndexSet)

    @objc(replaceObjectInBlockListAtIndex:withObject:)
    @NSManaged public func replaceBlockList(at idx: Int, with value: Block)

    @objc(replaceBlockListAtIndexes:withBlockList:)
    @NSManaged public func replaceBlockList(at indexes: NSIndexSet, with values: [Block])

    @objc(addBlockListObject:)
    @NSManaged public func addToBlockList(_ value: Block)

    @objc(removeBlockListObject:)
    @NSManaged public func removeFromBlockList(_ value: Block)

    @objc(addBlockList:)
    @NSManaged public func addToBlockList(_ values: NSOrderedSet)

    @objc(removeBlockList:)
    @NSManaged public func removeFromBlockList(_ values: NSOrderedSet)

}

extension Group: Identifiable {

}
