//
//  HomeVC+CoreDataTest.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/21.
//

import UIKit

#if DEBUG
extension HomeViewController {
    
    /// CoreData 테스트용 메서드입니다.
    func testCoreData() {
        // insertTrackingTestData()
        printCoreData()
    }
    
    /// 테스트 트래킹 데이터를 생성하고, CoreData를 업데이트합니다.
    func insertTrackingTestData() {
        let block = blockManager.getBlockList(0)[0]
        
        let trackingDate = TrackingDate(context: blockManager.context)
        trackingDate.year = "2023년"
        trackingDate.month = "09월"
        trackingDate.day = "21일"
        trackingDate.dayOfWeek = "목요일"
        
        let trackingTime1 = TrackingTime(context: blockManager.context)
        trackingTime1.startTime = "15:00"
        trackingTime1.endTime = "17:00"
        
        let trackingTime2 = TrackingTime(context: blockManager.context)
        trackingTime2.startTime = "20:00"
        trackingTime2.endTime = "22:30"
        
        trackingDate.addToTrackingTimeList(trackingTime1)
        trackingDate.addToTrackingTimeList(trackingTime2)
        block.addToTrackingDateList(trackingDate)
        
        blockManager.saveContext()
    }
    
    /// CoreData를 프린트합니다.
    func printCoreData() {
        let groupList = blockManager.getGroupList()
        for group in groupList {
            
            print("[\(group.name) Group]")
            // print("• id: \(group.id)")
            print("• color: \(group.color)")
            print("")
            
            if let blockList = group.blockList?.array as? [Block] {
                for block in blockList {
                    print("   [\(block.taskLabel) Block]")
                    print("   • superGroup: \(block.superGroup.name)")
                    // print("   • id: \(block.id)")
                    print("   • icon: \(block.icon)")
                    print("   • todayOutput: \(block.todayOutput)")
                    print("")
                    
                    if let dateList = block.trackingDateList?.array as? [TrackingDate] {
                        for date in dateList {
                            print("      [TrackingDate]")
                            print("      • superBlock: \(date.superBlock.taskLabel)")
                            print("      • year: \(date.year)")
                            print("      • month: \(date.month)")
                            print("      • dayOfWeek: \(date.dayOfWeek)")
                            print("      • day: \(date.day)")
                            print("")
                            
                            if let timeList = date.trackingTimeList?.array as? [TrackingTime] {
                                for time in timeList {
                                    print("         [TrackingTime]")
                                    print("         • superDate: \(time.superDate.month) \(time.superDate.day)")
                                    print("         • startTime: \(time.startTime)")
                                    print("         • endTime: \(time.endTime)")
                                    print("")
                                }
                            }
                        }
                    }
                }
            }
            print("------------------------------------------\n")
        }
    }
}
#endif
