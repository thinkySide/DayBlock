//
//  ActionButton.swift
//  DesignSystem
//
//  Created by 김민준 on 1/28/26.
//

import SwiftUI

public struct ActionButton: View {
    
    public enum Variation {
        case delete
        
        var textColor: Color {
            switch self {
            case .delete: DesignSystem.Colors.eventDestructive.swiftUIColor
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .delete: DesignSystem.Colors.gray100.swiftUIColor
            }
        }
    }
    
    let title: String
    let variation: Variation
    let action: () -> Void
    
    public init(
        title: String,
        variation: Variation,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.variation = variation
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .brandFont(.pretendard(.semiBold), 17)
                .foregroundStyle(variation.textColor)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(variation.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 13))
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
