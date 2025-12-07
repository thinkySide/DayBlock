//
//  ColorView.swift
//  Storybook
//
//  Created by 김민준 on 12/7/25.
//

import SwiftUI
import DesignSystem

struct ColorView: View {
    
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(colors, id: \.name) { color in
                    ColorBox(color)
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private func ColorBox(_ color: DesignSystemColors) -> some View {
        VStack {
            RoundedRectangle(cornerRadius: 16)
                .frame(height: 80)
                .foregroundStyle(color.swiftUIColor)
            
            Text(color.name)
                .brandFont(.poppins(.semiBold), 16)
        }
    }
    
    private let colors: [DesignSystemColors] = [
        DesignSystem.Colors.gray111111,
        DesignSystem.Colors.gray323232,
        DesignSystem.Colors.gray616161,
        DesignSystem.Colors.gray757575,
        DesignSystem.Colors.grayAAAAAA,
        DesignSystem.Colors.grayB2B5BD,
        DesignSystem.Colors.grayC5C5C5,
        DesignSystem.Colors.grayE8E8E8,
        DesignSystem.Colors.grayEEEEEE,
        DesignSystem.Colors.grayF4F5F7,
        DesignSystem.Colors.grayFFFFFF
    ]
}

#Preview {
    DesignSystemPreview {
        ColorView()
    }
}
