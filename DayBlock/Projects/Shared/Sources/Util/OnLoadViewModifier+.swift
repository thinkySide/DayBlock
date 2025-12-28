//
//  OnLoadViewModifier+.swift
//  Util
//
//  Created by 김민준 on 12/28/25.
//

import SwiftUI

public extension View {
    
    /// 최초 1회 실행됩니다.
    func onLoad(_ action: @escaping () -> Void) -> some View {
        modifier(OnLoadViewModifier(action: action))
    }
}

struct OnLoadViewModifier: ViewModifier {
    
    @State private var isFirstAppear = true
    
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if isFirstAppear {
                    isFirstAppear = false
                    action()
                }
            }
    }
}
