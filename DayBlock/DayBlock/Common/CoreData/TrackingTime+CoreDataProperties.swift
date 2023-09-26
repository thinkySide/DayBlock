//
//  TrackingTime+CoreDataProperties.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/26.
//
//

import Foundation
import CoreData

extension TrackingTime {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackingTime> {
        return NSFetchRequest<TrackingTime>(entityName: "TrackingTime")
    }

    @NSManaged public var endTime: Int
    @NSManaged public var startTime: Int
    @NSManaged public var superDate: TrackingDate

}

extension TrackingTime: Identifiable {

}
