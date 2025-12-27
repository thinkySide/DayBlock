//
//  NavigationBarButton.swift
//  DesignSystem
//
//  Created by 김민준 on 12/27/25.
//

import SwiftUI

public struct NavigationBarButton: View {
    
    public enum Variation {
        case back
        case text(String)
    }
    
    let variation: Variation
    let onTap: () -> Void
    
    public init(
        _ variation: Variation,
        onTap: @escaping () -> Void
    ) {
        self.variation = variation
        self.onTap = onTap
    }
    
    public var body: some View {
        Button {
            onTap()
        } label: {
            Group {
                switch variation {
                case .back:
                    DesignSystem.Icons.arrowLeft.swiftUIImage
                        .resizable()
                        .frame(width: 32, height: 32)
                    
                case .text(let text):
                    Text(text)
                        .brandFont(.pretendard(.bold), 15)
                        .frame(height: 32)
                        .padding(.horizontal, 4)
                }
            }
            .foregroundStyle(DesignSystem.Colors.gray323232.swiftUIColor)
        }
        .modifier(NavigationBarButtonStyleViewModifier())
    }
}

// MARK: - ButtonStyle Helper
struct NavigationBarButtonStyleViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .buttonStyle(GlassButtonStyle())
        } else {
            content
        }
    }
}
