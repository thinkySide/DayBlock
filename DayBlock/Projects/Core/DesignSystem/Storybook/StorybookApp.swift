//
//  StorybookApp.swift
//  DesignSystem
//
//  Created by 김민준 on 12/7/25.
//

import SwiftUI
import DesignSystem

@main
struct StorybookApp: App {
    
    init() {
        DesignSystemFontFamily.registerAllCustomFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
