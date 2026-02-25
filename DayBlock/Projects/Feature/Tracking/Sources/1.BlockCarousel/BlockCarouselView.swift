//
//  BlockCarouselView.swift
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

public struct BlockCarouselView: View {

    @Bindable private var store: StoreOf<BlockCarouselFeature>

    public init(store: StoreOf<BlockCarouselFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack {
            GeometryReader { _ in
                contentView
            }
            .ignoresSafeArea(.keyboard, edges: .all)
        }
    }

    @ViewBuilder
    private var contentView: some View {
        VStack(spacing: 0) {
            Header()
                .padding(.top, 16)
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
            
            TrackingButton(
                state: .play,
                isDisabled: store.focusedBlock == .addBlock || store.focusedBlock == nil,
                tapAction: {
                    store.send(.view(.onTapTrackingButton))
                }
            )
            .padding(.top, 56)
        }
        .background(DesignSystem.Colors.gray0.swiftUIColor)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Text("와우")
                } label: {
                    Image(systemName: Symbol.questionmark_circle_fill.symbolName)
                        .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                }

            }
        }
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
                state: \.blockEditor,
                action: \.blockEditor
            )
        ) { childStore in
            BlockEditorView(store: childStore)
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
        .overlay {
            if let childStore = store.scope(
                state: \.trackingInProgress,
                action: \.trackingInProgress
            ) {
                TrackingInProgressView(store: childStore)
            }
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
extension BlockCarouselView {

    @ViewBuilder
    private func Header() -> some View {
        HStack {
            DateTimeInfo()

            Spacer()

            TrackingBoard(
                activeBlocks: storedBlocks,
                blockSize: 18,
                blockCornerRadius: 4.5,
                spacing: 4,
                isPaused: false
            )
        }
    }

    /// 저장된 오늘의 트래킹 데이터를 TrackingBoard에 표시할 형태로 반환합니다.
    private var storedBlocks: [Int: TrackingBoardBlock.Area] {
        let builder = TrackingBoardDataBuilder()
        let entries = store.todayTrackingEntries.map { entry in
            TrackingBoardDataBuilder.TimeEntry(
                time: entry.time,
                color: ColorPalette.toColor(from: entry.colorIndex),
                variation: .stored,
                sessionId: entry.sessionId
            )
        }
        return builder.build(entries: entries)
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
    
    typealias FocusedBlock = BlockCarouselFeature.FocusedBlock

    @Bindable var store: StoreOf<BlockCarouselFeature>
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
                            color: ColorPalette.toColor(from: block.colorIndex),
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
