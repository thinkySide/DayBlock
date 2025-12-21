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
                .foregroundStyle(DesignSystem.Colors.grayE8E8E8.swiftUIColor)
                .frame(width: 180, height: 180)
                .overlay(
                    SFSymbol(
                        symbol: .plus_circle_fill,
                        size: 48,
                        color: DesignSystem.Colors.grayC5C5C5.swiftUIColor
                    )
                )
        }
    }
}
