//
//  ScaleButtonStyleViewModifier.swift
//  DesignSystem
//
//  Created by 김민준 on 1/6/26.
//

import SwiftUI

extension View {

    /// 버튼을 누르면 살짝 커지는 애니메이션을 적용합니다.
    /// - Parameter scale: 눌렀을 때 확대 비율 (기본값: 1.05)
    public func scaleButton(scale: CGFloat = 1.05) -> some View {
        self.buttonStyle(ScaleButtonStyle(pressedScale: scale))
    }
}

public struct ScaleButtonStyle: ButtonStyle {
    let pressedScale: CGFloat

    public init(pressedScale: CGFloat = 1.05) {
        self.pressedScale = pressedScale
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? pressedScale : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
