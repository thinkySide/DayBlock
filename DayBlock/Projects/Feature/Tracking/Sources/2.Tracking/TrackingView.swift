//
//  TrackingView.swift
//  Tracking
//
//  Created by 김민준 on 1/10/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Domain

public struct TrackingView: View {
    
    @Bindable private var store: StoreOf<TrackingFeature>

    public init(store: StoreOf<TrackingFeature>) {
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
                color: ColorPalette.toColor(from: store.trackingGroup.colorIndex),
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
    }
}


// MARK: - SubViews
extension TrackingView {

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
        let progress = store.elapsedTime / store.standardTime
        ZStack {
            ProgressView(value: progress)
                .progressViewStyle(
                    CustomProgressViewStyle(
                        tint: store.isPaused
                        ? DesignSystem.Colors.gray400.swiftUIColor
                        : ColorPalette.toColor(from: store.trackingGroup.colorIndex),
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
extension TrackingView {
    
    /// TrackingBoard에 표시할 데이터를 반환합니다.
    private var activeBlocks: [Int: TrackingBoardBlock.Area] {
        let color = ColorPalette.toColor(from: store.trackingGroup.colorIndex)
        let currentVariation: TrackingBoardBlock.Area.Variation = store.isPaused ? .paused : .tracking
        let trackingBlock = convertTimeToBlocks(time: store.trackingTime, color: color, variation: currentVariation)
        let completedBlocks = store.completedTrackingTimeList.reduce(into: [Int: TrackingBoardBlock.Area]()) { result, time in
            let newBlocks = convertTimeToBlocks(time: time, color: color, variation: .stored)
            result = mergeBlocks(result, newBlocks, color: color)
        }
        return mergeBlocks(trackingBlock, completedBlocks, color: color)
    }

    /// TrackingData.Time을 블럭 딕셔너리로 변환합니다.
    private func convertTimeToBlocks(
        time: TrackingData.Time,
        color: Color,
        variation: TrackingBoardBlock.Area.Variation
    ) -> [Int: TrackingBoardBlock.Area] {
        @Dependency(\.calendar) var calendar
        let components = calendar.dateComponents([.hour, .minute], from: time.startDate)
        guard let hour = components.hour, let minute = components.minute else { return [:] }

        let isFirstHalf = minute < 30
        let area: TrackingBoardBlock.Area = isFirstHalf
            ? .firstHalf(color, variation)
            : .secondHalf(color, variation)

        return [hour: area]
    }

    /// 두 개의 블럭 딕셔너리를 병합합니다.
    private func mergeBlocks(
        _ blocks1: [Int: TrackingBoardBlock.Area],
        _ blocks2: [Int: TrackingBoardBlock.Area],
        color: Color
    ) -> [Int: TrackingBoardBlock.Area] {
        blocks2.reduce(into: blocks1) { result, entry in
            let (hour, newArea) = entry
            if let existingArea = result[hour] {
                result[hour] = mergeAreas(existingArea, newArea, color: color)
            } else {
                result[hour] = newArea
            }
        }
    }

    /// 두 개의 Area를 병합합니다.
    private func mergeAreas(
        _ existing: TrackingBoardBlock.Area,
        _ new: TrackingBoardBlock.Area,
        color: Color
    ) -> TrackingBoardBlock.Area {
        switch (existing, new) {
        case (.firstHalf(_, let existingVariation), .secondHalf(_, let newVariation)),
             (.secondHalf(_, let newVariation), .firstHalf(_, let existingVariation)):
            let mergedVariation = priorityVariation(existingVariation, newVariation)
            return .full(color, mergedVariation)

        default:
            return new
        }
    }

    /// 두 Variation 중 우선순위가 높은 것을 반환합니다.
    /// 우선순위: tracking > paused > stored
    private func priorityVariation(
        _ first: TrackingBoardBlock.Area.Variation,
        _ second: TrackingBoardBlock.Area.Variation
    ) -> TrackingBoardBlock.Area.Variation {
        if first == .tracking || second == .tracking {
            return .tracking
        } else if first == .paused || second == .paused {
            return .paused
        } else {
            return .stored
        }
    }
    
    /// 현재 생산량을 반환합니다.
    private var amount: Double {
        var result: Double = 0
        store.completedTrackingTimeList.forEach { _ in result += 0.5 }
        return result
    }
}
