//
//  LabelTextField.swift
//  DesignSystem
//
//  Created by 김민준 on 12/21/25.
//

import SwiftUI

public struct LabelTextField<Accessory: View>: View {
    
    @Binding var text: String
    @FocusState.Binding var isTextFieldFocused: Bool

    let label: String
    let placeholder: String
    let tintColor: Color?
    let accessory: Accessory

    public init(
        text: Binding<String>,
        isTextFieldFocused: FocusState<Bool>.Binding,
        label: String,
        placeholder: String,
        tintColor: Color? = nil,
        @ViewBuilder accessory: (() -> Accessory) = { EmptyView() }
    ) {
        self._text = text
        self._isTextFieldFocused = isTextFieldFocused
        self.label = label
        self.placeholder = placeholder
        self.tintColor = tintColor
        self.accessory = accessory()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .brandFont(.pretendard(.semiBold), 16)
                .foregroundStyle(DesignSystem.Colors.gray800.swiftUIColor)
                .padding(.leading, 4)
            
            HStack {
                TextField(placeholder, text: $text)
                    .focused($isTextFieldFocused)
                    .brandFont(.pretendard(.semiBold), 18)
                    .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                    .tint(tintColor)
                    .padding(.leading, 16)
                
                accessory
                    .padding(.trailing, 16)
            }
            .frame(height: 56)
            .background(DesignSystem.Colors.gray100.swiftUIColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
