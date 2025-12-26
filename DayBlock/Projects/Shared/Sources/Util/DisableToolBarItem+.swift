//
//  DisableToolBarItem+.swift
//  Util
//
//  Created by 김민준 on 12/26/25.
//

import SwiftUI

public extension View {
    
    /// ToolBarItem을 비활성화 합니다.
    func disabledToolBarItem(_ isDisabled: Bool) -> some View {
        modifier(DisableToolBarItemViewModifier(isDisabled: isDisabled))
    }
}

struct DisableToolBarItemViewModifier: ViewModifier {
    
    let isDisabled: Bool
    
    func body(content: Content) -> some View {
        content
            .opacity(isDisabled ? 0.3 : 1)
            .allowsHitTesting(!isDisabled)
    }
}
