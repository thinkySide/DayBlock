//
//  Block+CoreDataProperties.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/21.
//
//

import Foundation
import CoreData

extension Block {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Block> {
        return NSFetchRequest<Block>(entityName: "Block")
    }

    @NSManaged public var icon: String
    @NSManaged public var taskLabel: String
    @NSManaged public var todayOutput: Double
    @NSManaged public var superGroup: Group
    @NSManaged public var trackingDateList: NSOrderedSet?

}

// MARK: Generated accessors for trackingDateList
extension Block {

    @objc(insertObject:inTrackingDateListAtIndex:)
    @NSManaged public func insertIntoTrackingDateList(_ value: TrackingDate, at idx: Int)

    @objc(removeObjectFromTrackingDateListAtIndex:)
    @NSManaged public func removeFromTrackingDateList(at idx: Int)

    @objc(insertTrackingDateList:atIndexes:)
    @NSManaged public func insertIntoTrackingDateList(_ values: [TrackingDate], at indexes: NSIndexSet)

    @objc(removeTrackingDateListAtIndexes:)
    @NSManaged public func removeFromTrackingDateList(at indexes: NSIndexSet)

    @objc(replaceObjectInTrackingDateListAtIndex:withObject:)
    @NSManaged public func replaceTrackingDateList(at idx: Int, with value: TrackingDate)

    @objc(replaceTrackingDateListAtIndexes:withTrackingDateList:)
    @NSManaged public func replaceTrackingDateList(at indexes: NSIndexSet, with values: [TrackingDate])

    @objc(addTrackingDateListObject:)
    @NSManaged public func addToTrackingDateList(_ value: TrackingDate)

    @objc(removeTrackingDateListObject:)
    @NSManaged public func removeFromTrackingDateList(_ value: TrackingDate)

    @objc(addTrackingDateList:)
    @NSManaged public func addToTrackingDateList(_ values: NSOrderedSet)

    @objc(removeTrackingDateList:)
    @NSManaged public func removeFromTrackingDateList(_ values: NSOrderedSet)

}

extension Block: Identifiable {

}
