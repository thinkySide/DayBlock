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
        NavigationStack {
            VStack(spacing: 0) {
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

                if case .edit = store.mode, !store.isDefaultGroup {
                    ActionButton(title: "삭제하기", variation: .delete) {
                        store.send(.view(.onTapDeleteButton))
                    }
                    .padding(.top, 32)
                    .padding(.horizontal, 20)
                }

                Spacer()
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        store.send(.view(.onTapBackButton))
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
                            .brandFont(.pretendard(.bold), 15)
                            .foregroundStyle(
                                store.nameText.isEmpty
                                ? DesignSystem.Colors.gray500.swiftUIColor
                                : DesignSystem.Colors.gray900.swiftUIColor
                            )
                    }
                    .disabled(store.nameText.isEmpty)
                }
            }
            .background(DesignSystem.Colors.gray0.swiftUIColor)
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
