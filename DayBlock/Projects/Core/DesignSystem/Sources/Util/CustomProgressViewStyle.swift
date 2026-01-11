//
//  CustomProgressViewStyle.swift
//  DesignSystem
//
//  Created by 김민준 on 1/11/26.
//

import SwiftUI

public struct CustomProgressViewStyle: ProgressViewStyle {

    let tint: Color
    let background: Color
    let height: CGFloat
    
    public init(
        tint: Color,
        background: Color,
        height: CGFloat
    ) {
        self.tint = tint
        self.background = background
        self.height = height
    }

    public func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(DesignSystem.Colors.gray100.swiftUIColor)
                
                UnevenRoundedRectangle(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: height,
                    topTrailingRadius: height
                )
                .fill(tint)
                .frame(width: geometry.size.width * CGFloat(configuration.fractionCompleted ?? 0))
            }
            .frame(height: height)
        }
    }
}
