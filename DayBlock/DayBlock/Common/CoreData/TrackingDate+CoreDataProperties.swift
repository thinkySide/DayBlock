//
//  TrackingDate+CoreDataProperties.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/21.
//
//

import Foundation
import CoreData

extension TrackingDate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackingDate> {
        return NSFetchRequest<TrackingDate>(entityName: "TrackingDate")
    }

    @NSManaged public var year: String
    @NSManaged public var month: String
    @NSManaged public var day: String
    @NSManaged public var dayOfWeek: String
    @NSManaged public var superBlock: Block
    @NSManaged public var trackingTimeList: NSOrderedSet?

}

// MARK: Generated accessors for trackingTimeList
extension TrackingDate {

    @objc(insertObject:inTrackingTimeListAtIndex:)
    @NSManaged public func insertIntoTrackingTimeList(_ value: TrackingTime, at idx: Int)

    @objc(removeObjectFromTrackingTimeListAtIndex:)
    @NSManaged public func removeFromTrackingTimeList(at idx: Int)

    @objc(insertTrackingTimeList:atIndexes:)
    @NSManaged public func insertIntoTrackingTimeList(_ values: [TrackingTime], at indexes: NSIndexSet)

    @objc(removeTrackingTimeListAtIndexes:)
    @NSManaged public func removeFromTrackingTimeList(at indexes: NSIndexSet)

    @objc(replaceObjectInTrackingTimeListAtIndex:withObject:)
    @NSManaged public func replaceTrackingTimeList(at idx: Int, with value: TrackingTime)

    @objc(replaceTrackingTimeListAtIndexes:withTrackingTimeList:)
    @NSManaged public func replaceTrackingTimeList(at indexes: NSIndexSet, with values: [TrackingTime])

    @objc(addTrackingTimeListObject:)
    @NSManaged public func addToTrackingTimeList(_ value: TrackingTime)

    @objc(removeTrackingTimeListObject:)
    @NSManaged public func removeFromTrackingTimeList(_ value: TrackingTime)

    @objc(addTrackingTimeList:)
    @NSManaged public func addToTrackingTimeList(_ values: NSOrderedSet)

    @objc(removeTrackingTimeList:)
    @NSManaged public func removeFromTrackingTimeList(_ values: NSOrderedSet)

}

extension TrackingDate: Identifiable {

}
