//
//  TrackingCarouselView.swift
//  Tracking
//
//  Created by 김민준 on 12/8/25.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture
import Domain
import Editor
import Util

public struct TrackingCarouselView: View {

    @Bindable private var store: StoreOf<TrackingCarouselFeature>

    public init(store: StoreOf<TrackingCarouselFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            contentView
        } destination: { store in
            switch store.case {
            case let .blockEditor(store):
                BlockEditorView(store: store)
            }
        }
    }

    @ViewBuilder
    private var contentView: some View {
        VStack(spacing: 0) {
            NavigationBar()
            
            Header()
                .padding(.horizontal, 20)
            
            GroupPicker()
                .padding(.top, 32)

            BlockCarousel(store: store)
                .padding(.top, 16)
            
            Spacer()
                .frame(maxHeight: 48)
            
            Text("오늘 하루는 어떤 블럭으로\n채우고 계신가요?")
                .brandFont(.pretendard(.semiBold), 15)
                .foregroundStyle(DesignSystem.Colors.gray800.swiftUIColor)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
            
            Spacer()
                .frame(maxHeight: 48)
            
            TrackingButton(
                state: .play,
                isDisabled: store.focusedBlock == .addBlock || store.focusedBlock == nil,
                tapAction: {
                    
                }
            )
            
            Spacer()
        }
        .background(DesignSystem.Colors.gray0.swiftUIColor)
        .onLoad {
            store.send(.view(.onLoad))
        }
        .onAppear {
            store.send(.view(.onAppear))
        }
        .onDisappear {
            store.send(.view(.onDisappear))
        }
        .sheet(
            item: $store.scope(
                state: \.groupSelect,
                action: \.groupSelect
            )
        ) { childStore in
            GroupSelectView(store: childStore)
                .presentationDetents([.medium, .large], selection: $store.sheetDetent)
                .presentationDragIndicator(.visible)
        }
        .popup(
            isPresented: $store.isPopupPresented,
            title: "블럭을 삭제할까요?",
            message: "그동안 기록된 블록 정보가 모두 삭제돼요",
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

// MARK: - Header
extension TrackingCarouselView {
    
    @ViewBuilder
    private func Header() -> some View {
        HStack {
            DateTimeInfo()
            
            Spacer()
            
            TrackingBoard(
                activeBlocks: [:],
                blockSize: 18,
                blockCornerRadius: 4.5,
                spacing: 4
            )
        }
    }
    
    @ViewBuilder
    private func DateTimeInfo() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(store.currentDate.formattedDateWithWeekday)
                .brandFont(.pretendard(.semiBold), 16)
                .foregroundStyle(DesignSystem.Colors.gray800.swiftUIColor)
                .padding(.leading, 4)

            Text(store.currentDate.formattedTime24Hour)
                .brandFont(.poppins(.bold), 56)
                .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                .padding(.top, -8)

            Text("today +0.5")
                .brandFont(.poppins(.bold), 23)
                .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                .padding(.leading, 4)
                .padding(.top, -12)
        }
    }
    
    @ViewBuilder
    private func GroupPicker() -> some View {
        Button {
            store.send(.view(.onTapGroupSelect))
        } label: {
            let group = store.selectedGroup
            HStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(ColorPalette.toColor(from: group.colorIndex))
                    .frame(width: 16, height: 16)
                
                Text(group.name)
                    .brandFont(.pretendard(.bold), 16)
                    .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                
                DesignSystem.Icons.arrowDown.swiftUIImage
                    .resizable()
                    .frame(width: 20, height: 20)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - BlockCarousel
private struct BlockCarousel: View {
    
    typealias FocusedBlock = TrackingCarouselFeature.FocusedBlock

    @Bindable var store: StoreOf<TrackingCarouselFeature>
    private let cellSize: CGFloat = 180

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal) {
                HStack(spacing: 24) {
                    ForEach(store.blockList) { block in
                        CarouselDayBlock(
                            title: block.name,
                            totalAmount: block.output,
                            todayAmount: block.output,
                            symbol: IconPalette.toIcon(from: block.iconIndex),
                            color: ColorPalette.toColor(from: store.selectedGroup.colorIndex),
                            variation: store.selectedBlock?.id == block.id ? .back : .front,
                            onTapCell: {
                                store.send(.view(.onTapBlock(block)))
                            },
                            onTapDeleteButton: {
                                store.send(.view(.onTapBlockDeleteButton))
                            },
                            onTapEditButton: {
                                store.send(.view(.onTapBlockEditButton(block)))
                            }
                        )
                        .containerRelativeFrame(.horizontal, count: 1, spacing: 24)
                        .id(FocusedBlock.block(id: block.id))
                    }

                    CarouselAddBlock(
                        onTap: {
                            store.send(.view(.onTapAddBlock))
                        }
                    )
                    .containerRelativeFrame(.horizontal, count: 1, spacing: 24)
                    .id(FocusedBlock.addBlock)
                }
                .scrollTargetLayout()
            }
            .scrollClipDisabled()
            .scrollPosition(id: $store.focusedBlock)
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .safeAreaPadding(.horizontal, (geometry.size.width - cellSize) / 2)
        }
        .frame(height: cellSize)
    }
}
