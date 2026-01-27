//
//  BlockListView.swift
//  Management
//
//  Created by 김민준 on 1/26/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct BlockListView: View {

    private var store: StoreOf<BlockListFeature>

    public init(store: StoreOf<BlockListFeature>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                ForEach(store.sectionList) { section in
                    BlockListSection(from: section)
                }
            }
            .padding(.vertical, 20)
        }
        .onAppear {
            store.send(.view(.onAppear))
        }
    }
}

// MARK: - SubViews
extension BlockListView {
    
    @ViewBuilder
    private func BlockListSection(from viewItem: BlockListViewItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(viewItem.group.name)
                .brandFont(.pretendard(.bold), 18)
                .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
            
            ForEach(viewItem.blockList) { blockViewItem in
                BlockListSectionCell(from: blockViewItem)
            }
            .padding(.top, 12)
            
            AddBlockButton(from: viewItem)
                .padding(.top, 16)
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func BlockListSectionCell(from viewItem: BlockListViewItem.BlockViewItem) -> some View {
        Button {
            
        } label: {
            HStack(spacing: 14) {
                IconBlock(
                    symbol: IconPalette.toIcon(from: viewItem.block.iconIndex),
                    color: ColorPalette.toColor(from: viewItem.block.colorIndex),
                    size: 32
                )
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(viewItem.block.name)
                        .brandFont(.pretendard(.bold), 16)
                        .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                    
                    Text("total +\(viewItem.total)")
                        .brandFont(.poppins(.semiBold), 13)
                        .foregroundStyle(DesignSystem.Colors.gray800.swiftUIColor)
                }
                
                Spacer()
                
                DesignSystem.Icons.arrowRight.swiftUIImage
                    .tint(DesignSystem.Colors.gray700.swiftUIColor)
            }
            .frame(height: 40)
        }
    }
    
    @ViewBuilder
    private func AddBlockButton(from viewItem: BlockListViewItem) -> some View {
        Button {
            
        } label: {
            HStack(spacing: 8) {
                DesignSystem.Icons.addCell.swiftUIImage
                    .resizable()
                    .frame(width: 32, height: 32)
                
                Text("블럭 추가하기")
                    .brandFont(.pretendard(.semiBold), 15)
                    .foregroundStyle(DesignSystem.Colors.gray800.swiftUIColor)
                    .padding(.leading, 8)
                
                Spacer()
            }
            .frame(height: 40)
        }
    }
}
