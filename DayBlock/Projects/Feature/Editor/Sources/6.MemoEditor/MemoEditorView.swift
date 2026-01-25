//
//  MemoEditorView.swift
//  Editor
//
//  Created by 김민준 on 1/25/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct MemoEditorView: View {
    
    @Bindable private var store: StoreOf<MemoEditorFeature>
    @State private var isMemoEditorFocused: Bool = true

    public init(store: StoreOf<MemoEditorFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            NavigationBar(
                title: "메모 수정",
                backgroundColor: DesignSystem.Colors.gray100.swiftUIColor,
                leadingView: {
                    NavigationBarButton(.dismiss) {
                        store.send(.view(.onTapDismissButton))
                    }
                },
                trailingView: {
                    NavigationBarButton(.text("확인")) {
                        store.send(.view(.onTapConfirmButton))
                    }
                }
            )
            
            StableTextEditor(
                isFocused: $isMemoEditorFocused,
                text: $store.memoText,
                font: DesignSystemFontFamily.Pretendard.medium.font(size: 16),
                textColor: DesignSystem.Colors.gray900.swiftUIColor,
                tintColor: ColorPalette.toColor(from: store.colorIndex),
                backgroundColor: DesignSystem.Colors.gray100.swiftUIColor,
                lineSpacing: 1,
                contentInset: .init(top: 0, left: 20, bottom: 20, right: 20)
            )
            .padding(.top, 32)
        }
        .background(DesignSystem.Colors.gray100.swiftUIColor)
        .onTapGesture {
            isMemoEditorFocused = false
        }
    }
}
