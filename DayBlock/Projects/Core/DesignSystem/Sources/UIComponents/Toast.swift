//
//  Toast.swift
//  DesignSystem
//
//  Created by Claude on 1/11/26.
//

import SwiftUI

public struct Toast: View {

    let icon: String
    let iconColor: Color
    let message: String

    public init(
        icon: String,
        iconColor: Color,
        message: String
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.message = message
    }

    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(iconColor)

            Text(message)
                .brandFont(.pretendard(.bold), 16)
                .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(DesignSystem.Colors.gray100.swiftUIColor)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 20)
    }
}
