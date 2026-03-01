//
//  TrackingInProgressView.swift
//  Tracking
//
//  Created by 김민준 on 1/10/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Domain
import Editor

public struct TrackingInProgressView: View {

    @Bindable private var store: StoreOf<TrackingInProgressFeature>
    @Environment(\.scenePhase) private var scenePhase

    public init(store: StoreOf<TrackingInProgressFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            NavigationBar(
                leadingView: {
                    NavigationBarButton(.dismiss) {
                        store.send(.view(.onTapDismissButton))
                    }
                }
            )

            Header()
                .padding(.top, 16)
                .padding(.horizontal, 20)

            TrackingDayBlock(
                title: store.trackingBlock.name,
                todayAmount: amount,
                symbol: IconPalette.toIcon(from: store.trackingBlock.iconIndex),
                color: ColorPalette.toColor(from: store.trackingBlock.colorIndex),
                isPaused: store.isPaused,
                onLongPressComplete: {
                    store.send(.view(.onLongPressCompleteTrackingBlock))
                }
            )
            .padding(.top, 32)

            Spacer()
                .frame(maxHeight: 36)

            TotalTimeCounter()
            
            Spacer()
            
            ProgressIndicator()
                .padding(.bottom, 124)
        }
        .background(DesignSystem.Colors.gray0.swiftUIColor)
        .onAppear {
            store.send(.view(.onAppear))
        }
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .active: store.send(.view(.onScenePhaseActive))
            default: return
            }
        }
        .popup(
            isPresented: $store.isPopupPresented,
            title: "블럭 생산을 중단할까요?",
            message: "지금까지 생산한 블럭이 모두 사라져요",
            leftAction: .init(
                title: "아니오",
                variation: .secondary,
                action: {
                    store.send(.popup(.cancel))
                }
            ),
            rightAction: .init(
                title: "중단할래요",
                variation: .destructive,
                action: {
                    store.send(.popup(.stopTracking))
                }
            )
        )
        .toast(
            isPresented: $store.isToastPresented,
            icon: Symbol.exclamationmark_circle_fill.symbolName,
            iconColor: DesignSystem.Colors.eventWarning.swiftUIColor,
            message: "0.5개 이상 블럭 생산 시 등록이 가능해요"
        )
        .overlay {
            if store.isCompletionAnimating {
                TrackingCompletionOverlay(
                    color: ColorPalette.toColor(from: store.trackingBlock.colorIndex),
                    onAnimationComplete: {
                        store.send(.view(.onCompletionAnimationComplete))
                    }
                )
            }
            if let childStore = store.scope(
                state: \.trackingEditor,
                action: \.trackingEditor
            ) {
                TrackingEditorView(store: childStore)
                    .transition(.opacity.animation(.easeInOut(duration: 0.5)))
            }
        }
    }
}

// MARK: - SubViews
extension TrackingInProgressView {

    @ViewBuilder
    private func Header() -> some View {
        HStack {
            DateTimeInfo()
            
            Spacer()
            
            TrackingBoard(
                activeBlocks: activeBlocks,
                blockSize: 18,
                blockCornerRadius: 4.5,
                spacing: 4,
                isPaused: store.isPaused
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
    private func TotalTimeCounter() -> some View {
        let width: CGFloat = 50
        let totalTime = Int(store.totalTime)
        HStack(spacing: -2) {
            Text(String(format: "%02d", totalTime / 3600))
                .frame(width: width)
                .contentTransition(.numericText())
            Text(":")
            Text(String(format: "%02d", totalTime / 60 % 60))
                .frame(width: width)
                .contentTransition(.numericText())
            Text(":")
            Text(String(format: "%02d", totalTime % 60))
                .frame(width: width)
                .contentTransition(.numericText())
        }
        .brandFont(.poppins(.bold), 36)
        .foregroundStyle(
            store.isPaused
            ? DesignSystem.Colors.gray400.swiftUIColor
            : DesignSystem.Colors.gray900.swiftUIColor
        )
        .animation(.default, value: store.totalTime)
    }
    
    @ViewBuilder
    private func ProgressIndicator() -> some View {
        let progress = min(max(store.elapsedTime / store.standardTime, 0), 1)
        ZStack {
            ProgressView(value: progress)
                .progressViewStyle(
                    CustomProgressViewStyle(
                        tint: store.isPaused
                        ? DesignSystem.Colors.gray400.swiftUIColor
                        : ColorPalette.toColor(from: store.trackingBlock.colorIndex),
                        background: DesignSystem.Colors.gray0.swiftUIColor,
                        height: 10
                    )
                )
                .frame(height: 12)
                .animation(.linear(duration: 1), value: progress)
            
            TrackingButton(
                state: store.isPaused ? .play : .pause,
                isDisabled: false,
                tapAction: {
                    store.send(.view(.onTapTrackingButton))
                }
            )
        }
    }
}

// MARK: - Helper
extension TrackingInProgressView {

    /// TrackingBoard에 표시할 데이터를 반환합니다.
    private var activeBlocks: [Int: TrackingBoardBlock.Area] {
        let builder = TrackingBoardDataBuilder()
        let trackingColor = ColorPalette.toColor(from: store.trackingBlock.colorIndex)
        let trackingVariation: TrackingBoardBlock.Area.Variation = store.isPaused ? .paused : .tracking
        let currentSessionId = store.currentSessionId

        var entries: [TrackingBoardDataBuilder.TimeEntry] = []

        // 1. DB에 저장된 오늘의 트래킹 데이터 (애니메이션 X)
        let storedEntries = store.storedTrackingEntries.map { entry in
            TrackingBoardDataBuilder.TimeEntry(
                time: entry.time,
                color: ColorPalette.toColor(from: entry.colorIndex),
                variation: .stored,
                sessionId: entry.sessionId
            )
        }
        entries.append(contentsOf: storedEntries)

        // 2. 현재 세션에서 완료된 트래킹 (애니메이션 O, 같은 세션)
        let completedEntries = store.todayCompletedTrackingTimeList.map { time in
            TrackingBoardDataBuilder.TimeEntry(
                time: time,
                color: trackingColor,
                variation: trackingVariation,
                sessionId: currentSessionId
            )
        }
        entries.append(contentsOf: completedEntries)

        // 3. 현재 트래킹 중인 시간 (애니메이션 O, 같은 세션)
        let trackingEntry = TrackingBoardDataBuilder.TimeEntry(
            time: store.trackingTime,
            color: trackingColor,
            variation: trackingVariation,
            sessionId: currentSessionId
        )
        entries.append(trackingEntry)

        return builder.build(entries: entries)
    }

    /// 현재 생산량을 반환합니다.
    private var amount: Double {
        Double(store.completedTrackingTimeList.count) * 0.5
    }
}
