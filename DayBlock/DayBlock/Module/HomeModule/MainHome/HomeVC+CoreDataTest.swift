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
        
        trackingData.testData.append("17:00")
        viewManager.blockPreview.refreshAnimation(trackingData.trackingBlocks(), color: groupData.focusColor())
    }
    
    /// 테스트 트래킹 데이터를 생성하고, CoreData를 업데이트합니다.
    func insertTrackingTestData() {
        let block = blockData.list()[0]
        
        let trackingDate = TrackingDate(context: groupData.context)
        trackingDate.year = "2023년"
        trackingDate.month = "09월"
        trackingDate.day = "21일"
        trackingDate.dayOfWeek = "목요일"
        
        let trackingTime1 = TrackingTime(context: groupData.context)
        trackingTime1.startTime = "1500"
        trackingTime1.endTime = "1700"
        
        let trackingTime2 = TrackingTime(context: groupData.context)
        trackingTime2.startTime = "2000"
        // trackingTime2.endTime = "2230"
        
        trackingDate.addToTrackingTimeList(trackingTime1)
        trackingDate.addToTrackingTimeList(trackingTime2)
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
                    print("   • icon: \(block.icon)")
                    print("   • todayOutput: \(block.todayOutput)")
                    print("")
                    
                    if let dateList = block.trackingDateList?.array as? [TrackingDate] {
                        for date in dateList {
                            print("      [TrackingDate]")
                            print("      • superBlock: \(date.superBlock.taskLabel)")
                            print("      • year: \(date.year)")
                            print("      • month: \(date.month)")
                            print("      • day: \(date.day)")
                            print("      • dayOfWeek: \(date.dayOfWeek)")
                            print("")
                            
                            if let timeList = date.trackingTimeList?.array as? [TrackingTime] {
                                for time in timeList {
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
