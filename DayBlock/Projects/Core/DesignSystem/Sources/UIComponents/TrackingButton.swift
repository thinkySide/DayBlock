//
//  TrackingButton.swift
//  DesignSystem
//
//  Created by 김민준 on 12/14/25.
//

import SwiftUI

public struct TrackingButton: View {
    
    public enum State: Equatable {
        case play
        case pause
    }
    
    let state: State
    let isDisabled: Bool
    let tapAction: () -> Void

    public init(
        state: State,
        isDisabled: Bool,
        tapAction: @escaping () -> Void
    ) {
        self.state = state
        self.isDisabled = isDisabled
        self.tapAction = tapAction
    }
    
    public var body: some View {
        Button {
            tapAction()
        } label: {
            Circle()
                .frame(width: 64, height: 64)
                .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor.opacity(
                    isDisabled ? 0.4 : 1
                ))
                .overlay(
                    SFSymbol(
                        symbol: state == .play
                        ? Symbol.play_fill.symbolName : Symbol.pause_fill.symbolName,
                        size: 24,
                        color: DesignSystem.Colors.gray0.swiftUIColor
                    )
                    .padding(.leading, state == .play ? 6 : 0)
                    .animation(nil, value: state)
                )
        }
        .disabled(isDisabled)
        .buttonStyle(ScaleButtonStyle())
    }
}
