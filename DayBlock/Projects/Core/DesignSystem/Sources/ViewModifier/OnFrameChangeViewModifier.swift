//
//  OnFrameChangeViewModifier.swift
//  DesignSystem
//
//  Created by 김민준 on 1/25/26.
//

import SwiftUI

public extension View {
    
    /// Frame 사이즈 변화를 감지 후 반환합니다.
    func onFrameChange(
        in space: CoordinateSpace = .global,
        onChange: @escaping (CGRect) -> Void
    ) -> some View {
        self.modifier(FrameModifier(space: space, onChange: onChange))
    }
}

struct FrameModifier: ViewModifier {
    let space: CoordinateSpace
    let onChange: (CGRect) -> Void

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geo in
                    let frame = geo.frame(in: space)
                    Color.clear
                        .onAppear { onChange(frame) }
                        .preference(key: FramePreferenceKey.self, value: frame)
                }
            )
            .onPreferenceChange(FramePreferenceKey.self, perform: onChange)
    }
}

struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
