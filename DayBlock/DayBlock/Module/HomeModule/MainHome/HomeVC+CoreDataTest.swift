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
    @objc func testCoreData() {
        // insertTrackingTestData()
        // printCoreData()
        Vibration.warning.vibrate()
    }
    
    /// 테스트 트래킹 데이터를 생성하고, CoreData를 업데이트합니다.
    func insertTrackingTestData() {
        let block = blockData.focusEntity()
        
        let trackingDate = TrackingDate(context: groupData.context)
        trackingDate.year = "2023"
        trackingDate.month = "10"
        trackingDate.day = "04"
        trackingDate.dayOfWeek = "수"
        
        let trackingTime1 = TrackingTime(context: groupData.context)
        trackingTime1.startTime = "1500"
        trackingTime1.endTime = "1700"
        
        trackingDate.addToTrackingTimeList(trackingTime1)
        block.addToTrackingDateList(trackingDate)
        
        groupData.saveContext()
    }
    
    /// CoreData를 프린트합니다.
    func printCoreData() {
        let groupList = groupData.list()
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
                    print("   • order: \(block.order)")
                    print("   • icon: \(block.icon)")
                    print("   • todayOutput: \(block.todayOutput)")
                    print("")
                    
                    if let focusDateList = block.trackingDateList?.array as? [TrackingDate] {
                        for date in focusDateList {
                            print("      [TrackingDate]")
                            print("      • superBlock: \(date.superBlock.taskLabel)")
                            print("      • year: \(date.year)")
                            print("      • month: \(date.month)")
                            print("      • day: \(date.day)")
                            print("      • dayOfWeek: \(date.dayOfWeek)")
                            print("")
                            
                            if let focusTimeList = date.trackingTimeList?.array as? [TrackingTime] {
                                for time in focusTimeList {
                                    print("         [TrackingTime]")
                                    print("         • superDate: \(time.superDate.month) \(time.superDate.day)")
                                    print("         • startTime: \(time.startTime)")
                                    print("         • endTime: \(String(describing: time.endTime))")
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
