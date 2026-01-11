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
    
    private var store: StoreOf<TrackingFeature>

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
                onTapCell: {

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
    private var activeBlocks: [Int: TrackingBoardBlock.Variation] {
        let color = ColorPalette.toColor(from: store.trackingGroup.colorIndex)
        let trackingBlock = convertTimeToBlocks(time: store.trackingTime, color: color, isTracking: true)
        let completedBlocks = store.completedTrackingTimeList.reduce(into: [Int: TrackingBoardBlock.Variation]()) { result, time in
            let newBlocks = convertTimeToBlocks(time: time, color: color, isTracking: true)
            result = mergeBlocks(result, newBlocks, color: color)
        }
        return mergeBlocks(trackingBlock, completedBlocks, color: color)
    }

    /// TrackingData.Time을 블럭 딕셔너리로 변환합니다.
    private func convertTimeToBlocks(
        time: TrackingData.Time,
        color: Color,
        isTracking: Bool
    ) -> [Int: TrackingBoardBlock.Variation] {
        @Dependency(\.calendar) var calendar
        let components = calendar.dateComponents([.hour, .minute], from: time.startDate)
        guard let hour = components.hour, let minute = components.minute else { return [:] }

        let isFirstHalf = minute < 30
        let state: TrackingBoardBlock.Variation = isFirstHalf
            ? .firstHalf(color, isTracking: isTracking)
            : .secondHalf(color, isTracking: isTracking)

        return [hour: state]
    }

    /// 두 개의 블럭 딕셔너리를 병합합니다.
    private func mergeBlocks(
        _ blocks1: [Int: TrackingBoardBlock.Variation],
        _ blocks2: [Int: TrackingBoardBlock.Variation],
        color: Color
    ) -> [Int: TrackingBoardBlock.Variation] {
        blocks2.reduce(into: blocks1) { result, entry in
            let (hour, newState) = entry
            if let existingState = result[hour] {
                result[hour] = mergeStates(existingState, newState, color: color)
            } else {
                result[hour] = newState
            }
        }
    }

    /// 두 개의 State를 병합합니다.
    private func mergeStates(
        _ existing: TrackingBoardBlock.Variation,
        _ new: TrackingBoardBlock.Variation,
        color: Color
    ) -> TrackingBoardBlock.Variation {
        switch (existing, new) {
        case (.firstHalf(_, let existingTracking), .secondHalf(_, let newTracking)),
             (.secondHalf(_, let newTracking), .firstHalf(_, let existingTracking)):
            let isTracking = existingTracking || newTracking
            return .full(color, isTracking: isTracking)

        default:
            return new
        }
    }
    
    /// 현재 생산량을 반환합니다.
    private var amount: Double {
        var result: Double = 0
        store.completedTrackingTimeList.forEach { _ in result += 0.5 }
        return result
    }
}
