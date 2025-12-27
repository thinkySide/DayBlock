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
        VStack(spacing: 0) {
            CarouselDayBlock(
                title: blockTitle,
                totalAmount: store.initialBlock.output,
                todayAmount: store.initialBlock.output,
                symbol: IconPalette.toIcon(from: store.editingBlock.iconIndex),
                color: ColorPalette.toColor(from: store.selectedGroup.colorIndex),
                state: .front
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
                        .foregroundStyle(DesignSystem.Colors.grayAAAAAA.swiftUIColor)
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
                    HStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundStyle(ColorPalette.toColor(from: store.selectedGroup.colorIndex))
                            .frame(width: 16, height: 16)
                        
                        Text(store.selectedGroup.name)
                            .brandFont(.pretendard(.bold), 17)
                            .foregroundStyle(DesignSystem.Colors.gray323232.swiftUIColor)
                    }
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
                        color: DesignSystem.Colors.gray323232.swiftUIColor
                    )
                },
                onTap: {
                    store.send(.view(.onTapIconSelection))
                }
            )
            .padding(.top, 24)
            .padding(.leading, 20)
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(DesignSystem.Colors.grayFFFFFF.swiftUIColor)
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
        .sheet(
            item: $store.scope(
                state: \.groupSelect,
                action: \.groupSelect
            )
        ) { store in
            GroupSelectView(store: store)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .sheet(
            item: $store.scope(
                state: \.iconSelect,
                action: \.iconSelect
            )
        ) { store in
            IconSelectView(store: store)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
    
    @ViewBuilder
    private func NavigationTitle() -> some View {
        Text("블럭 생성")
            .brandFont(.pretendard(.bold), 15)
            .foregroundStyle(DesignSystem.Colors.gray323232.swiftUIColor)
    }
    
    @ViewBuilder
    private func ConfirmButton() -> some View {
        Button("완료") {
            store.send(.view(.onTapConfirmButton))
        }
        .brandFont(.pretendard(.bold), 15)
        .foregroundStyle(DesignSystem.Colors.gray323232.swiftUIColor)
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
