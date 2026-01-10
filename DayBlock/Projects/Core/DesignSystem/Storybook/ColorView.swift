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
        DesignSystem.Colors.gray1000,
        DesignSystem.Colors.gray900,
        DesignSystem.Colors.gray800,
        DesignSystem.Colors.gray700,
        DesignSystem.Colors.gray600,
        DesignSystem.Colors.gray400,
        DesignSystem.Colors.gray500,
        DesignSystem.Colors.gray300,
        DesignSystem.Colors.gray200,
        DesignSystem.Colors.gray100,
        DesignSystem.Colors.gray0
    ]
}

#Preview {
    DesignSystemPreview {
        ColorView()
    }
}
