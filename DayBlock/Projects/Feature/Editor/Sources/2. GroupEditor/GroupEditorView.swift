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
                isSheet: store.isSheet,
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
                        .foregroundStyle(DesignSystem.Colors.gray600.swiftUIColor)
                }
            )
            .padding(.top, 32)
            .padding(.horizontal, 20)
            .onChange(of: store.nameText) { _, value in
                store.send(.view(.typeNameText(value)))
            }
            
            if case .edit = store.mode {
                ActionButton(title: "삭제하기", variation: .delete) {
                    store.send(.view(.onTapDeleteButton))
                }
                .padding(.top, 32)
                .padding(.horizontal, 20)
            }

            Spacer()
        }
        .background(DesignSystem.Colors.gray0.swiftUIColor)
        .toolbarVisibility(.hidden, for: .navigationBar)
        .onAppear {
            store.send(.view(.onAppear))
        }
        .onTapGesture {
            isNameTextFieldFocused = false
        }
        .popup(
            isPresented: $store.isPopupPresented,
            title: "그룹을 삭제할까요?",
            message: "그룹과 관련된 블럭과 정보가 모두 삭제돼요",
            leftAction: .init(
                title: "아니오",
                variation: .secondary,
                action: {
                    store.send(.popup(.cancel))
                }
            ),
            rightAction: .init(
                title: "삭제할래요",
                variation: .destructive,
                action: {
                    store.send(.popup(.deleteGroup))
                }
            )
        )
    }
    
    @ViewBuilder
    private func NavigationTitle() -> some View {
        Text(navigationTitle)
            .brandFont(.pretendard(.bold), 15)
            .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
    }
    
    @ViewBuilder
    private func ConfirmButton() -> some View {
        Button("확인") {
            store.send(.view(.onTapConfirmButton))
        }
        .brandFont(.pretendard(.bold), 15)
        .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
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
