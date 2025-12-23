//
//  LabelSelection.swift
//  DesignSystem
//
//  Created by 김민준 on 12/23/25.
//

import SwiftUI

public struct LabelSelection<Accessory: View>: View {
    
    let label: String
    let accessory: Accessory
    
    public init(
        label: String,
        @ViewBuilder accessory: (() -> Accessory) = { EmptyView() }
    ) {
        self.label = label
        self.accessory = accessory()
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            Text(label)
                .brandFont(.pretendard(.semiBold), 16)
                .foregroundStyle(DesignSystem.Colors.gray616161.swiftUIColor)
                .padding(.leading, 4)
            
            Spacer()
            
            accessory
                .padding(.trailing, 8)
            
            Image(.arrowDown)
                .resizable()
                .frame(width: 20, height: 20)
                .padding(.trailing, 20)
        }
        .frame(height: 48)
        .contentShape(Rectangle())
        .overlay(alignment: .bottom) {
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .foregroundStyle(DesignSystem.Colors.grayE8E8E8.swiftUIColor)
        }
    }
}
