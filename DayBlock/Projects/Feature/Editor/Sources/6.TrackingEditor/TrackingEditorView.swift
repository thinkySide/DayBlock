//
//  TrackingEditorView.swift
//  Editor
//
//  Created by 김민준 on 1/24/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Domain
import Util

public struct TrackingEditorView: View {

    @Bindable private var store: StoreOf<TrackingEditorFeature>

    public init(store: StoreOf<TrackingEditorFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Header()
                    .padding(.top, 20)

                DashedDivider()
                    .padding(.top, 32)
                    .frame(width: 204)

                SessionCarousel()

                if store.sessionPages.count > 1 {
                    PageIndicator()
                        .padding(.top, 20)
                }

                let currentMemo = store.currentPage?.memoText ?? ""
                let memoText = currentMemo.isEmpty
                ? "어떤 일을 했는지 메모로 남겨봐요"
                : currentMemo
                StableTextEditor(
                    isFocused: .constant(false),
                    text: .constant(memoText),
                    textColor: currentMemo.isEmpty
                    ? DesignSystem.Colors.gray600.swiftUIColor
                    : DesignSystem.Colors.gray800.swiftUIColor,
                    tintColor: ColorPalette.toColor(from: store.trackingBlock.colorIndex),
                    backgroundColor: DesignSystem.Colors.gray100.swiftUIColor,
                    lineSpacing: 1,
                    contentInset: .init(top: 20, left: 20, bottom: 20, right: 20),
                    isEditable: false
                )
                .padding(.top, store.sessionPages.count > 1 ? 20 : 56)
                .ignoresSafeArea()
                .onTapGesture {
                    store.send(.view(.onTapMemoEditor))
                }
            }
            .background(DesignSystem.Colors.gray0.swiftUIColor)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                switch store.presentationMode {
                case .trackingComplete:
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("완료") {
                            store.send(.view(.onTapFinishButton))
                        }
                        .brandFont(.pretendard(.semiBold), 16)
                        .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                    }

                case .calendarDetail:
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            store.send(.view(.onTapDismissButton))
                        } label: {
                            Image(systemName: Symbol.xmark.symbolName)
                                .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Button(role: .destructive) {
                                store.send(.view(.onTapDeleteButton))
                            } label: {
                                Label("삭제하기", systemImage: Symbol.trash.symbolName)
                            }
                            .tint(.red)
                        } label: {
                            Image(systemName: Symbol.ellipsis.symbolName)
                                .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                        }
                    }
                }
            }
        }
        .fullScreenCover(
            item: $store.scope(
                state: \.memoEditor,
                action: \.memoEditor
            )
        ) { childStore in
            MemoEditorView(store: childStore)
        }
        .popup(
            isPresented: $store.isPopupPresented,
            title: "기록을 삭제할까요?",
            message: "해당 트래킹 기록이 영구적으로 삭제돼요",
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
                    store.send(.popup(.deleteSession))
                }
            )
        )
    }
}

// MARK: - SubViews
extension TrackingEditorView {

    @ViewBuilder
    private func Header() -> some View {
        VStack(spacing: 0) {
            IconBlock(
                symbol: IconPalette.toIcon(from: store.trackingBlock.iconIndex),
                color: ColorPalette.toColor(from: store.trackingBlock.colorIndex),
                size: 44
            )

            Text(store.trackingGroup.name)
                .brandFont(.pretendard(.semiBold), 15)
                .foregroundStyle(DesignSystem.Colors.gray800.swiftUIColor)
                .padding(.top, 16)

            Text(store.trackingBlock.name)
                .brandFont(.pretendard(.bold), 20)
                .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                .padding(.top, 4)
        }
    }

    @ViewBuilder
    private func SessionCarousel() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                ForEach(store.sessionPages) { page in
                    VStack(spacing: 0) {
                        DateInfo(page: page)
                            .padding(.top, 32)

                        BoardSection(page: page)
                            .padding(.top, 44)
                    }
                    .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $store.currentPageId)
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
    }

    @ViewBuilder
    private func PageIndicator() -> some View {
        HStack(spacing: 6) {
            ForEach(store.sessionPages) { page in
                Circle()
                    .fill(
                        page.id == store.currentPageId
                        ? ColorPalette.toColor(from: store.trackingBlock.colorIndex)
                        : DesignSystem.Colors.gray300.swiftUIColor
                    )
                    .frame(width: 6, height: 6)
            }
        }
    }

    @ViewBuilder
    private func DateInfo(page: TrackingEditorFeature.SessionPage) -> some View {
        VStack(spacing: 4) {
            if let firstTime = page.trackingTimeList.first {
                Text(firstTime.startDate.formattedDateWithWeekday)
                    .brandFont(.pretendard(.semiBold), 15)
                    .foregroundStyle(DesignSystem.Colors.gray800.swiftUIColor)

                Text(timeRangeText(for: page))
                    .brandFont(.poppins(.bold), 28)
                    .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
            }
        }
    }

    @ViewBuilder
    private func BoardSection(page: TrackingEditorFeature.SessionPage) -> some View {
        VStack(spacing: 6) {
            HStack(spacing: 0) {
                Text("블럭")
                    .brandFont(.pretendard(.bold), 18)
                    .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)

                Text("+")
                    .brandFont(.poppins(.bold), 24)
                    .foregroundStyle(ColorPalette.toColor(from: store.trackingBlock.colorIndex))
                    .padding(.leading, 2)

                Text(outputValue(for: page).toValueString())
                    .brandFont(.poppins(.bold), 24)
                    .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                    .padding(.leading, -1)
                    .padding(.trailing, 2)

                Text("개를 생산했어요!")
                    .brandFont(.pretendard(.bold), 18)
                    .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
            }

            TrackingBoard(
                activeBlocks: completedBlocks(for: page),
                blockSize: 32,
                blockCornerRadius: 8,
                spacing: 8,
                isPaused: false
            )
        }
    }
}

// MARK: - Helper
extension TrackingEditorView {

    /// 생산량을 반환합니다. (TrackingTime 1개 = 0.5 블럭)
    private func outputValue(for page: TrackingEditorFeature.SessionPage) -> Double {
        Double(page.trackingTimeList.count) * 0.5
    }

    /// 트래킹 시간 범위 텍스트를 반환합니다.
    private func timeRangeText(for page: TrackingEditorFeature.SessionPage) -> String {
        guard let first = page.trackingTimeList.first else { return "" }
        let start = first.startDate.formattedTime24Hour
        if let last = page.trackingTimeList.last,
           let endDate = last.endDate {
            return "\(start)-\(endDate.formattedTime24Hour)"
        }
        return "\(start)-"
    }

    /// 완료된 트래킹 데이터를 TrackingBoard에 표시할 형태로 반환합니다.
    private func completedBlocks(for page: TrackingEditorFeature.SessionPage) -> [Int: TrackingBoardBlock.Area] {
        let builder = TrackingBoardDataBuilder()
        return builder.build(
            timeList: page.trackingTimeList,
            color: ColorPalette.toColor(from: store.trackingBlock.colorIndex),
            variation: .stored,
            sessionId: page.id
        )
    }
}

#Preview {
    TrackingEditorView(
        store: .init(
            initialState: TrackingEditorFeature.State(
                trackingGroup: .init(id: .init(), name: "기본그룹", order: 0),
                trackingBlock: .init(id: .init(), name: "기본블럭", iconIndex: 4, colorIndex: 6, output: 1.5, order: 0),
                sessionPages: [
                    .init(id: UUID(), trackingTimeList: [], totalTime: 1800)
                ]
            ),
            reducer: {
                TrackingEditorFeature()
            }
        )
    )
}
