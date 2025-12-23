//
//  BlockAddEditView.swift
//  Block
//
//  Created by 김민준 on 12/21/25.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

public struct BlockAddEditView: View {

    public let store: StoreOf<BlockAddEditFeature>

    public init(store: StoreOf<BlockAddEditFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            CarouselDayBlock(
                title: store.block.name,
                totalAmount: store.block.output,
                todayAmount: 0,
                symbol: store.block.symbol,
                color: DesignSystem.Colors.gray323232.swiftUIColor,
                state: .front
            )
            .padding(.top, 12)
            
            LabelTextField(
                text: .constant(""),
                label: "작업명",
                placeholder: "블럭 쌓기",
                accessory: {
                    Text("0/16")
                        .brandFont(.pretendard(.semiBold), 14)
                        .foregroundStyle(DesignSystem.Colors.grayAAAAAA.swiftUIColor)
                }
            )
            .padding(.top, 32)
            .padding(.horizontal, 20)
            
            LabelSelection(
                label: "그룹",
                accessory: {
                    HStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundStyle(DesignSystem.Colors.gray323232.swiftUIColor)
                            .frame(width: 16, height: 16)
                        
                        Text("기본 그룹")
                            .brandFont(.pretendard(.bold), 17)
                            .foregroundStyle(DesignSystem.Colors.gray323232.swiftUIColor)
                    }
                }
            )
            .padding(.top, 24)
            .padding(.leading, 20)
            
            LabelSelection(
                label: "아이콘",
                accessory: {
                    SFSymbol(
                        symbol: Symbol.batteryblock_fill.symbolName,
                        size: 24,
                        color: DesignSystem.Colors.gray323232.swiftUIColor
                    )
                }
            )
            .padding(.top, 24)
            .padding(.leading, 20)
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                NavigationTitle()
            }

            ToolbarItem(placement: .topBarTrailing) {
                ConfirmButton()
            }
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
            
        }
        .brandFont(.pretendard(.bold), 15)
        .foregroundStyle(DesignSystem.Colors.gray323232.swiftUIColor)
    }
}
