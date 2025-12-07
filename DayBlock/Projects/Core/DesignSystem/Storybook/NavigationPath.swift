//
//  NavigationPath.swift
//  DesignSystem
//
//  Created by 김민준 on 12/7/25.
//

import Foundation

enum Path: String, Identifiable, CaseIterable {
    case font
}

// MARK: - Helper
extension Path {
    var id: String {
        self.rawValue
    }
    
    var title: String {
        let text = self.rawValue
        return text.prefix(1).uppercased() + text.dropFirst()
    }
}
