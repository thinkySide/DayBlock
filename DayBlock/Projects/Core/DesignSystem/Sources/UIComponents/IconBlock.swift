//
//  IconBlock.swift
//  DesignSystem
//
//  Created by 김민준 on 1/24/26.
//

import SwiftUI

public struct IconBlock: View {
    
    let symbol: String
    let color: Color
    let size: CGFloat
    
    public init(
        symbol: String,
        color: Color,
        size: CGFloat
    ) {
        self.symbol = symbol
        self.color = color
        self.size = size
    }
    
    public var body: some View {
        SFSymbol(
            symbol: symbol,
            size: size / 2,
            color: .white
        )
        .frame(width: size, height: size)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: size / 3))
    }
}
