//
//  TrackingView.swift
//  Tracking
//
//  Created by 김민준 on 1/10/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

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
                totalAmount: store.trackingBlock.output,
                todayAmount: store.trackingBlock.output,
                symbol: IconPalette.toIcon(from: store.trackingBlock.iconIndex),
                color: ColorPalette.toColor(from: store.trackingGroup.colorIndex),
                onTapCell: {
                    
                }
            )
            .padding(.top, 32)
            
            Spacer()
        }
        .background(DesignSystem.Colors.gray0.swiftUIColor)
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
}
