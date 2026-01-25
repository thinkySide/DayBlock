//
//  DashedDivider.swift
//  DesignSystem
//
//  Created by 김민준 on 1/24/26.
//

import SwiftUI

public struct DashedDivider: View {
    
    public init() {}
    
    public var body: some View {
        Line()
            .stroke(style: .init(lineWidth: 3, lineCap: .round, dash: [6]))
            .foregroundStyle(DesignSystem.Colors.gray300.swiftUIColor)
            .frame(height: 3)
    }
}

// MARK: - Line
private struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
