//
//  Popup.swift
//  DesignSystem
//
//  Created by 김민준 on 1/6/26.
//

import SwiftUI

public struct Popup: View {
    
    public struct PopupAction {
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
        
        public enum Variation {
            case primary
            case secondary
            case destructive
            
            var backgroundColor: Color {
                switch self {
                case .primary: DesignSystem.Colors.gray323232.swiftUIColor
                case .secondary: DesignSystem.Colors.grayF4F5F7.swiftUIColor
                case .destructive: DesignSystem.Colors.eventDestructive.swiftUIColor
                }
            }
            
            var textColor: Color {
                switch self {
                case .primary: DesignSystem.Colors.grayFFFFFF.swiftUIColor
                case .secondary: DesignSystem.Colors.gray616161.swiftUIColor
                case .destructive: DesignSystem.Colors.grayFFFFFF.swiftUIColor
                }
            }
        }
    }
    
    let title: String
    let message: String
    let leftAction: PopupAction?
    let rightAction: PopupAction?
    
    public init(
        title: String,
        message: String,
        leftAction: PopupAction?,
        rightAction: PopupAction? = nil
    ) {
        self.title = title
        self.message = message
        self.leftAction = leftAction
        self.rightAction = rightAction
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .brandFont(.pretendard(.bold), 18)
                .foregroundStyle(DesignSystem.Colors.gray323232.swiftUIColor)
            
            Text(message)
                .brandFont(.pretendard(.medium), 15)
                .foregroundStyle(DesignSystem.Colors.gray616161.swiftUIColor)
                .padding(.top, 8)
            
            HStack(spacing: 12) {
                if let leftAction {
                    PopupButton(leftAction)
                }
                
                if let rightAction {
                    PopupButton(rightAction)
                }
            }
            .padding(.top, 20)
        }
        .padding(24)
    }
    
    @ViewBuilder
    private func PopupButton(_ popupAction: PopupAction) -> some View {
        Button {
            popupAction.action()
        } label: {
            Text(popupAction.title)
                .brandFont(.pretendard(.semiBold), 17)
                .foregroundStyle(popupAction.variation.textColor)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(popupAction.variation.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 13))
        }
    }
}
