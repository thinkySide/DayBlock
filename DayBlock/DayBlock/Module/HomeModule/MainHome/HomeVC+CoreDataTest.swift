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
        printCoreData()
    }
    
    /// CoreData를 프린트합니다.
    func printCoreData() {
        let groupList = blockManager.getGroupList()
        for group in groupList {
            
            print("[\(group.name) Group]")
            print("• id: \(group.id)")
            print("• color: \(group.color)")
            print("")
            
            if let blockList = group.blockList?.array as? [Block] {
                for block in blockList {
                    print("   [\(block.taskLabel) Block]")
                    print("   • superGroup: \(block.superGroup.name)")
                    print("   • id: \(block.id)")
                    print("   • icon: \(block.icon)")
                    print("   • todayOutput: \(block.todayOutput)")
                    print("")
                    
                    if let dateList = block.trackingDateList?.array as? [TrackingDate] {
                        for date in dateList {
                            print("      [\(date.date) TrackingDate]")
                            print("      • superBlock: \(date.superBlock.taskLabel)")
                            print("")
                            
                            if let timeList = date.trackingTimeList?.array as? [TrackingTime] {
                                for time in timeList {
                                    print("         [\(time.time) TrackingTime]")
                                    print("         • superDate: \(time.superDate)")
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
