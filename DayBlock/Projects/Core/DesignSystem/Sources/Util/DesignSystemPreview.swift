//
//  DesignSystemPreview.swift
//  DesignSystem
//
//  Created by 김민준 on 12/7/25.
//

import SwiftUI

public struct DesignSystemPreview<Content: View>: View {
    let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        Self.setupDesignSystem()
        self.content = content()
    }
    
    public var body: some View {
        content
    }
    
    /// Design System 기본 세팅을 진행합니다.
    private static func setupDesignSystem() {
        DesignSystemFontFamily.registerAllCustomFonts()
    }
}
