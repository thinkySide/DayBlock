//
//  CarouselAddBlock.swift
//  DesignSystem
//
//  Created by 김민준 on 12/21/25.
//

import SwiftUI

public struct CarouselAddBlock: View {
    
    let onTap: () -> Void
    
    public init(onTap: @escaping () -> Void) {
        self.onTap = onTap
    }
    
    public var body: some View {
        Button {
            onTap()
        } label: {
            RoundedRectangle(cornerRadius: 26)
                .strokeBorder(style: StrokeStyle(lineWidth: 4, dash: [6, 6]))
                .foregroundStyle(DesignSystem.Colors.gray300.swiftUIColor)
                .frame(width: 180, height: 180)
                .overlay(
                    SFSymbol(
                        symbol: Symbol.plus_circle_fill.symbolName,
                        size: 48,
                        color: DesignSystem.Colors.gray500.swiftUIColor
                    )
                )
        }
    }
}
