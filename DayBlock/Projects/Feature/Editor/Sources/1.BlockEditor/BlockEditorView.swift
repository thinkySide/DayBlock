//
//  BlockEditorView.swift
//  Editor
//
//  Created by 김민준 on 12/21/25.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture
import Util

public struct BlockEditorView: View {

    @Bindable private var store: StoreOf<BlockEditorFeature>
    @FocusState private var isNameTextFieldFocused: Bool

    public init(store: StoreOf<BlockEditorFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
            CarouselDayBlock(
                title: blockTitle,
                totalAmount: store.initialBlock.output,
                todayAmount: store.initialBlock.output,
                symbol: IconPalette.toIcon(from: store.editingBlock.iconIndex),
                color: ColorPalette.toColor(from: store.editingBlock.colorIndex),
                variation: .front
            )
            .padding(.top, 12)
            
            LabelTextField(
                text: $store.nameText,
                isTextFieldFocused: $isNameTextFieldFocused,
                label: "작업명",
                placeholder: store.initialBlock.name,
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
            
            LabelSelection(
                label: "그룹",
                accessory: {
                    Text(store.selectedGroup.name)
                        .brandFont(.pretendard(.bold), 17)
                        .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                },
                onTap: {
                    store.send(.view(.onTapGroupSelection))
                }
            )
            .padding(.top, 24)
            .padding(.leading, 20)
            
            LabelSelection(
                label: "아이콘",
                accessory: {
                    SFSymbol(
                        symbol: IconPalette.toIcon(from: store.editingBlock.iconIndex),
                        size: 24,
                        color: DesignSystem.Colors.gray900.swiftUIColor
                    )
                },
                onTap: {
                    store.send(.view(.onTapIconSelection))
                }
            )
            .padding(.top, 24)
            .padding(.leading, 20)
            
            LabelSelection(
                label: "색상",
                accessory: {
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundStyle(ColorPalette.toColor(from: store.editingBlock.colorIndex))
                        .frame(width: 16, height: 16)
                },
                onTap: {
                    store.send(.view(.onTapColorSelection))
                }
            )
            .padding(.top, 24)
            .padding(.leading, 20)
            
            if case .edit = store.mode {
                ActionButton(title: "삭제하기", variation: .delete) {
                    store.send(.view(.onTapDeleteButton))
                }
                .padding(.top, 32)
                .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .navigationTitle(store.mode == .add ? "블럭 생성" : "블럭 편집")
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
        .sheet(
            item: $store.scope(
                state: \.groupSelect,
                action: \.groupSelect
            )
        ) { childStore in
            GroupSelectView(store: childStore)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .sheet(
            item: $store.scope(
                state: \.iconSelect,
                action: \.iconSelect
            )
        ) { childStore in
            IconSelectView(store: childStore)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
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
        .popup(
            isPresented: $store.isPopupPresented,
            title: "블럭을 삭제할까요?",
            message: "블럭의 정보가 모두 삭제돼요",
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
                    store.send(.popup(.deleteBlock))
                }
            )
        )
        }
    }
}

// MARK: - Helper
extension BlockEditorView {
    
    /// 캐러셀 블럭에 표시 될 이름을 반환합니다.
    private var blockTitle: String {
        if store.nameText.isEmpty {
            return store.initialBlock.name
        } else {
            return store.editingBlock.name
        }
    }
}
