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
            NavigationBar(
                title: navigationTitle,
                isSheet: true,
                leadingView: {
                    NavigationBarButton(.back) {
                        store.send(.view(.onTapBackButton))
                    }
                },
                trailingView: {
                    NavigationBarButton(.text("확인")) {
                        store.send(.view(.onTapConfirmButton))
                    }
                    .disabledToolBarItem(store.nameText.isEmpty)
                }
            )
            
            LabelTextField(
                text: $store.nameText,
                isTextFieldFocused: $isNameTextFieldFocused,
                label: "그룹명",
                placeholder: groupNameTextFieldPlaceholder,
                accessory: {
                    Text("\(store.nameText.count)/\(store.nameTextLimit)")
                        .brandFont(.pretendard(.semiBold), 14)
                        .foregroundStyle(DesignSystem.Colors.grayAAAAAA.swiftUIColor)
                }
            )
            .padding(.top, 32)
            .padding(.horizontal, 20)
            .onChange(of: store.nameText) { _, value in
                store.send(.view(.typeNameText(value)))
            }
            
            LabelSelection(
                label: "색상",
                accessory: {
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundStyle(ColorPalette.toColor(from: store.editingGroup.colorIndex))
                        .frame(width: 16, height: 16)
                },
                onTap: {
                    store.send(.view(.onTapColorSelection))
                }
            )
            .padding(.top, 24)
            .padding(.leading, 20)
            
            Spacer()
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
        .onTapGesture {
            isNameTextFieldFocused = false
        }
        .sheet(
            item: $store.scope(
                state: \.colorSelect,
                action: \.colorSelect
            )
        ) { childStore in
            ColorSelectView(store: childStore)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
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
    
    /// 그룹 이름 텍스트필드의 placeholder 값을 반환합니다.
    private var groupNameTextFieldPlaceholder: String {
        switch store.mode {
        case .add: "ex) 시험 공부, 피트니스"
        case .edit: store.initialGroup.name
        }
    }
}
