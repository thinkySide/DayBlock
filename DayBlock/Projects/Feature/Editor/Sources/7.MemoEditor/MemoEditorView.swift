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
        NavigationStack {
            StableTextEditor(
                isFocused: $isMemoEditorFocused,
                text: $store.memoText,
                textColor: DesignSystem.Colors.gray900.swiftUIColor,
                tintColor: ColorPalette.toColor(from: store.colorIndex),
                backgroundColor: DesignSystem.Colors.gray100.swiftUIColor,
                lineSpacing: 1,
                contentInset: .init(top: 0, left: 20, bottom: 20, right: 20)
            )
            .padding(.top, 32)
            .background(DesignSystem.Colors.gray100.swiftUIColor)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("메모 수정")
                        .brandFont(.pretendard(.bold), 15)
                        .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        store.send(.view(.onTapDismissButton))
                    } label: {
                        Image(systemName: Symbol.xmark.symbolName)
                            .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        store.send(.view(.onTapConfirmButton))
                    } label: {
                        Text("확인")
                            .brandFont(.pretendard(.semiBold), 15)
                            .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                    }
                }
            }
            .toolbarBackground(
                DesignSystem.Colors.gray100.swiftUIColor,
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .onTapGesture {
            isMemoEditorFocused = false
        }
    }
}
