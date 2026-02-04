//
//  CalendarDemoApp.swift
//  Calendar
//
//  Created by 김민준 on 2/4/26.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture
import Calendar
import PersistentData
import SwiftData

@main
struct CalendarDemoApp: App {
    
    let store = Store(initialState: .init()) {
        CalendarFeature()
    }
    
    @Dependency(\.modelContainer) private var modelContainer
    
    init() {
        DesignSystemFontFamily.registerAllCustomFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            CalendarView(store: store)
        }
        .modelContainer(modelContainer)
    }
}
