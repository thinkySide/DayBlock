//
//  GroupEditorView.swift
//  Editor
//
//  Created by 김민준 on 12/27/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct GroupEditorView: View {
    
    @Bindable private var store: StoreOf<GroupEditorFeature>
    @FocusState private var isNameTextFieldFocused: Bool

    public init(store: StoreOf<GroupEditorFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            LabelTextField(
                text: $store.nameText,
                isTextFieldFocused: $isNameTextFieldFocused,
                label: "그룹명",
                placeholder: store.initialGroup.name,
                accessory: {
                    Text("\(store.nameText.count)/\(store.nameTextLimit)")
                        .brandFont(.pretendard(.semiBold), 14)
                        .foregroundStyle(DesignSystem.Colors.grayAAAAAA.swiftUIColor)
                }
            )
            .padding(.top, 12)
            .padding(.horizontal, 20)
            .onChange(of: store.nameText) { _, value in
                store.send(.view(.typeNameText(value)))
            }
            
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                NavigationTitle()
            }

            ToolbarItem(placement: .topBarTrailing) {
                ConfirmButton()
                    .disabledToolBarItem(store.nameText.isEmpty)
            }
        }
        .onTapGesture {
            isNameTextFieldFocused = false
        }
    }
    
    @ViewBuilder
    private func NavigationTitle() -> some View {
        Text(navigationTitle)
            .brandFont(.pretendard(.bold), 15)
            .foregroundStyle(DesignSystem.Colors.gray323232.swiftUIColor)
    }
    
    @ViewBuilder
    private func ConfirmButton() -> some View {
        Button("확인") {
            store.send(.view(.onTapConfirmButton))
        }
        .brandFont(.pretendard(.bold), 15)
        .foregroundStyle(DesignSystem.Colors.gray323232.swiftUIColor)
    }
}

// MARK: - Helper
extension GroupEditorView {
    
    /// 네비게이션 제목을 반환합니다.
    private var navigationTitle: String {
        switch store.mode {
        case .add: "새 그룹 생성"
        case .edit: "그룹 편집"
        }
    }
}
