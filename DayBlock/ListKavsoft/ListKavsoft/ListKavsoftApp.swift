//
//  ListKavsoftApp.swift
//  ListKavsoft
//
//  Created by 김민준 on 1/29/26.
//

import SwiftUI

@main
struct ListKavsoftApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
