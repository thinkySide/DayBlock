//
//  SFSymbol.swift
//  DesignSystem
//
//  Created by 김민준 on 12/14/25.
//

import SwiftUI

public struct SFSymbol: View {

    let symbol: String
    let size: CGFloat
    let color: Color
    let isAnimating: Bool

    public init(
        symbol: String,
        size: CGFloat,
        color: Color,
        isAnimating: Bool = false
    ) {
        self.symbol = symbol
        self.size = size
        self.color = color
        self.isAnimating = isAnimating
    }

    public var body: some View {
        Image(systemName: symbol)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .foregroundStyle(color)
            .symbolEffect(
                .bounce.byLayer,
                options: .repeating.speed(0.4),
                isActive: isAnimating
            )
    }
}
