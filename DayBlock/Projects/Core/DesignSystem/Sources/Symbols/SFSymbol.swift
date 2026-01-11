//
//  SFSymbol.swift
//  DesignSystem
//
//  Created by 김민준 on 12/14/25.
//

import SwiftUI

public struct SFSymbol: View {

    public enum AnimationType {
        case none
        case bounce
        case pulse
    }

    let symbol: String
    let size: CGFloat
    let color: Color
    let isAnimating: Bool
    let animationType: AnimationType

    public init(
        symbol: String,
        size: CGFloat,
        color: Color,
        isAnimating: Bool = false,
        animationType: AnimationType = .none
    ) {
        self.symbol = symbol
        self.size = size
        self.color = color
        self.isAnimating = isAnimating
        self.animationType = animationType
    }

    public var body: some View {
        Group {
            switch animationType {
            case .none:
                Image(systemName: symbol)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .foregroundStyle(color)

            case .bounce:
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

            case .pulse:
                Image(systemName: symbol)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .foregroundStyle(color)
                    .symbolEffect(
                        .pulse,
                        options: .repeating,
                        isActive: isAnimating
                    )
            }
        }
    }
}
