//
//  NavigationPath.swift
//  DesignSystem
//
//  Created by 김민준 on 12/7/25.
//

import Foundation

enum Path: String, Identifiable, CaseIterable {
    case font
    case color
    case components
}

// MARK: - Path Helper
extension Path {
    var id: String {
        self.rawValue
    }
    
    var title: String {
        let text = self.rawValue
        return text.prefix(1).uppercased() + text.dropFirst()
    }
}

// MARK: - ComponentsPath
enum ComponentsPath: String, Identifiable, CaseIterable {
    case navigationBar
    case trackingBoard
    case trackingBoardBlock
}

// MARK: - ComponentsPath Helper
extension ComponentsPath {
    var id: String {
        self.rawValue
    }
    
    var title: String {
        let text = self.rawValue
        return text.prefix(1).uppercased() + text.dropFirst()
    }
}
