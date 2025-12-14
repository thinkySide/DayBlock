//
//  DayBlockApp.swift
//  App
//
//  Created by 김민준 on 12/14/25.
//

import SwiftUI
import DesignSystem

@main
struct DayBlockApp: App {
    
    init() {
        DesignSystemFontFamily.registerAllCustomFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
