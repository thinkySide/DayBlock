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
    
    public init(
        symbol: String,
        size: CGFloat,
        color: Color
    ) {
        self.symbol = symbol
        self.size = size
        self.color = color
    }
    
    public var body: some View {
        Image(systemName: symbol)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .foregroundStyle(color)
    }
}
