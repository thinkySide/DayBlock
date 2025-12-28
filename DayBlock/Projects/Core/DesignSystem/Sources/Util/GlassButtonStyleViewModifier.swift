//
//  GlassButtonStyleViewModifier.swift
//  DesignSystem
//
//  Created by 김민준 on 12/28/25.
//

import SwiftUI

extension View {
    
    /// Glass 버튼 스타일을 적용합니다.
    ///
    /// - Note: iOS 26 이상 버전에서만 적용됩니다.
    public func glassButtonStyle() -> some View {
        modifier(GlassButtonStyleViewModifier())
    }
}

public struct GlassButtonStyleViewModifier: ViewModifier {

    public func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .buttonStyle(GlassButtonStyle())
        } else {
            content
        }
    }
}
