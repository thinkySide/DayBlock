//
//  GroupSelectView.swift
//  Editor
//
//  Created by 김민준 on 12/27/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Domain

public struct GroupSelectView: View {
    
    @Bindable private var store: StoreOf<GroupSelectFeature>

    public init(store: StoreOf<GroupSelectFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            NavigationBar(title: "그룹 선택")
            
            GroupScrollView()
        }
        .sheet(
            item: $store.scope(
                state: \.groupEditor,
                action: \.groupEditor
            )
        ) { store in
            GroupEditorView(store: store)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
    
    @ViewBuilder
    private func GroupScrollView() -> some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(store.groupList) { group in
                    GroupCell(group)
                }

                AddGroupCell()
            }
        }
    }
    
    @ViewBuilder
    private func GroupCell(_ group: BlockGroup) -> some View {
        let isSelected = group == store.selectedGroup
        Button {
            store.send(.view(.onTapGroup(group)))
        } label: {
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 7)
                    .foregroundStyle(ColorPalette.toColor(from: group.colorIndex))
                    .frame(width: 22, height: 22)
                
                Text(group.name)
                    .brandFont(.poppins(.semiBold), 16)
                    .foregroundStyle(DesignSystem.Colors.gray323232.swiftUIColor)
                
                Text("+7")
                    .brandFont(.pretendard(.semiBold), 15)
                    .foregroundStyle(DesignSystem.Colors.gray616161.swiftUIColor)
                
                Spacer()
                
                if isSelected {
                    SFSymbol(
                        symbol: Symbol.checkmark_circle_fill.symbolName,
                        size: 20,
                        color: DesignSystem.Colors.gray323232.swiftUIColor
                    )
                }
            }
            .padding(.horizontal, 20)
            .frame(height: 56)
            .contentShape(Rectangle())
            .background(
                isSelected
                ? DesignSystem.Colors.grayE8E8E8.swiftUIColor
                : .clear
            )
        }
    }
    
    @ViewBuilder
    private func AddGroupCell() -> some View {
        Button {
            store.send(.view(.onTapAddGroup))
        } label: {
            HStack(spacing: 8) {
                DesignSystem.Icons.addCell.swiftUIImage
                    .resizable()
                    .frame(width: 22, height: 22)
                
                Text("그룹 추가하기")
                    .brandFont(.pretendard(.semiBold), 15)
                    .foregroundStyle(DesignSystem.Colors.gray616161.swiftUIColor)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .frame(height: 56)
            .contentShape(Rectangle())
        }
    }
}
