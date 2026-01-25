//
//  TrackingResultView.swift
//  Tracking
//
//  Created by 김민준 on 1/24/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Domain
import Editor

public struct TrackingResultView: View {
    
    @Bindable private var store: StoreOf<TrackingResultFeature>

    public init(store: StoreOf<TrackingResultFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            NavigationBar(
                trailingView: {
                    NavigationBarButton(
                        .text("완료"),
                        onTap: {
                            store.send(.view(.onTapFinishButton))
                        }
                    )
                }
            )

            VStack(spacing: 0) {
                Header()
                    .padding(.top, 20)

                DashedDivider()
                    .padding(.top, 32)
                    .frame(width: 204)

                DateInfo()
                    .padding(.top, 32)

                BoardSection()
                    .padding(.top, 44)

                let memoText = store.memoText.isEmpty
                ? "어떤 일을 했는지 메모로 남겨봐요"
                : store.memoText
                StableTextEditor(
                    isFocused: .constant(false),
                    text: .constant(memoText),
                    font: DesignSystemFontFamily.Pretendard.medium.font(size: 16),
                    textColor: memoText.isEmpty
                    ? DesignSystem.Colors.gray600.swiftUIColor
                    : DesignSystem.Colors.gray800.swiftUIColor,
                    tintColor: ColorPalette.toColor(from: store.trackingBlock.colorIndex),
                    backgroundColor: DesignSystem.Colors.gray100.swiftUIColor,
                    lineSpacing: 1,
                    contentInset: .init(top: 20, left: 20, bottom: 20, right: 20),
                    isEditable: false
                )
                .padding(.top, 56)
                .ignoresSafeArea()
                .onTapGesture {
                    store.send(.view(.onTapMemoEditor))
                }
            }
        }
        .background(DesignSystem.Colors.gray0.swiftUIColor)
        .fullScreenCover(
            item: $store.scope(
                state: \.memoEditor,
                action: \.memoEditor
            )
        ) { childStore in
            MemoEditorView(store: childStore)
        }
    }
}

// MARK: - SubViews
extension TrackingResultView {
    
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
    private func DateInfo() -> some View {
        VStack(spacing: 4) {
            Text("23년 08월 25일 목요일")
                .brandFont(.pretendard(.semiBold), 15)
                .foregroundStyle(DesignSystem.Colors.gray800.swiftUIColor)
            
            Text("07:55-08:25")
                .brandFont(.poppins(.bold), 28)
                .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
        }
    }
    
    @ViewBuilder
    private func BoardSection() -> some View {
        VStack(spacing: 6) {
            HStack(spacing: 0) {
                Text("블럭")
                    .brandFont(.pretendard(.bold), 18)
                    .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)

                Text("+")
                    .brandFont(.poppins(.bold), 24)
                    .foregroundStyle(ColorPalette.toColor(from: store.trackingBlock.colorIndex))
                    .padding(.leading, 2)

                Text("\(store.completedTrackingTimeList.count)")
                    .brandFont(.poppins(.bold), 24)
                    .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                    .padding(.leading, -1)
                    .padding(.trailing, 2)

                Text("개를 생산했어요!")
                    .brandFont(.pretendard(.bold), 18)
                    .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
            }

            TrackingBoard(
                activeBlocks: completedBlocks,
                blockSize: 32,
                blockCornerRadius: 8,
                spacing: 8,
                isPaused: false
            )
        }
    }
}

// MARK: - Helper
extension TrackingResultView {

    /// 완료된 트래킹 데이터를 TrackingBoard에 표시할 형태로 반환합니다.
    private var completedBlocks: [Int: TrackingBoardBlock.Area] {
        let builder = TrackingBoardDataBuilder()
        return builder.build(
            timeList: store.completedTrackingTimeList,
            color: ColorPalette.toColor(from: store.trackingBlock.colorIndex),
            variation: .stored,
            sessionId: store.sessionId
        )
    }
}

#Preview {
    TrackingResultView(
        store: .init(
            initialState: TrackingResultFeature.State(
                trackingGroup: .init(id: .init(), name: "기본그룹", order: 0),
                trackingBlock: .init(id: .init(), name: "기본블럭", iconIndex: 4, colorIndex: 6, output: 1.5, order: 0),
                completedTrackingTimeList: [],
                totalTime: 1800,
                sessionId: UUID()
            ),
            reducer: {
                TrackingResultFeature()
            }
        )
    )
}
