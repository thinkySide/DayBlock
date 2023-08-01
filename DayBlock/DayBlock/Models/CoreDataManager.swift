//
//  CoreDataManager.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/01.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    /// Singleton
    static let shared = CoreDataManager()
    private init() {}
    
    /// container context
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    // MARK: - Method
    
    func fetchData() {
        do {
            let data = try context.fetch(GroupEntity.fetchRequest())
        } catch {
            // error
        }
    }
    
    
    
    /// Core Data Setup
    func setup() {
        
        
        
        
        
        
//        // 2. ViewController에 생성한 Persistent Container 전달
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        container = appDelegate.persistentContainer
//
//        // 3. Entity 가지고 오기
//        let entity = NSEntityDescription.entity(forEntityName: "GroupEntity", in: container.viewContext)!

//        // 4. NSManagedObject 만들기
//        let group = NSManagedObject(entity: entity, insertInto: container.viewContext)
//        group.setValue(19980825, forKey: "color")
//        group.setValue("테스트 그룹", forKey: "name")
//        group.setValue([Block(taskLabel: "테스트 블럭", output: 17, icon: "circle.fill")], forKey: "list")
//
//        // 5. NSManagedObjectContext에 저장
//        do {
//            try container.viewContext.save()
//        } catch {
//            print(error.localizedDescription)
//        }
//
//        // 6. 데이터 저장 테스트
//        do {
//            let group = try container.viewContext.fetch(GroupEntity.fetchRequest())
//            group.forEach {
//                print($0.name!)
//                print($0.color)
//                let block = $0.list![0] as! Block
//                print(block.taskLabel)
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
    }
}
