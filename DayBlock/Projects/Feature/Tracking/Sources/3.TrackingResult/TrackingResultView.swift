//
//  TrackingResultView.swift
//  Tracking
//
//  Created by 김민준 on 1/24/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

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
                    font: DesignSystemFontFamily.Pretendard.medium.font(size: 15),
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
            }
        }
        .background(DesignSystem.Colors.gray0.swiftUIColor)
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
                activeBlocks: [:],
                blockSize: 32,
                blockCornerRadius: 8,
                spacing: 8,
                isPaused: false
            )
        }
    }
}

import Domain
#Preview {
    TrackingResultView(
        store: .init(
            initialState: TrackingResultFeature.State(
                trackingGroup: .init(id: .init(), name: "기본그룹", order: 0),
                trackingBlock: .init(id: .init(), name: "기본블럭", iconIndex: 4, colorIndex: 6, output: 1.5, order: 0),
                completedTrackingTimeList: [],
                totalTime: 1800
            ),
            reducer: {
                TrackingResultFeature()
            }
        )
    )
}
