//
//  TrackingCarouselView.swift
//  Tracking
//
//  Created by 김민준 on 12/8/25.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture
import Editor

public struct TrackingCarouselView: View {

    @Bindable public var store: StoreOf<TrackingCarouselFeature>

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
                .foregroundStyle(DesignSystem.Colors.gray616161.swiftUIColor)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
            
            Spacer()
                .frame(maxHeight: 48)
            
            TrackingButton(
                state: .play,
                tapAction: {
                    
                }
            )
            
            Spacer()
        }
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
            Text("1월 2일 화요일")
                .brandFont(.pretendard(.semiBold), 16)
                .foregroundStyle(DesignSystem.Colors.gray616161.swiftUIColor)
                .padding(.leading, 4)
            
            Text("08:25")
                .brandFont(.poppins(.bold), 56)
                .foregroundStyle(DesignSystem.Colors.gray323232.swiftUIColor)
                .padding(.top, -8)
            
            Text("today +0.5")
                .brandFont(.poppins(.bold), 23)
                .foregroundStyle(DesignSystem.Colors.gray323232.swiftUIColor)
                .padding(.leading, 4)
                .padding(.top, -12)
        }
    }
    
    @ViewBuilder
    private func GroupPicker() -> some View {
        Button {
            
        } label: {
            HStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(DesignSystem.Colors.gray323232.swiftUIColor)
                    .frame(width: 16, height: 16)
                
                Text("기본 그룹")
                    .brandFont(.pretendard(.bold), 16)
                    .foregroundStyle(DesignSystem.Colors.gray323232.swiftUIColor)
                
                DesignSystem.Icons.arrowDown.swiftUIImage
                    .resizable()
                    .frame(width: 20, height: 20)
            }
        }
    }
}

// MARK: - BlockCarousel
private struct BlockCarousel: View {

    let store: StoreOf<TrackingCarouselFeature>
    private let cellSize: CGFloat = 180

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal) {
                HStack(spacing: 24) {
                    CarouselDayBlock(
                        title: "첫번째 블럭",
                        totalAmount: 3.0,
                        todayAmount: 1.5,
                        symbol: Symbol.party_popper_fill.symbolName,
                        color: .blue,
                        state: .front
                    )
                    
                    CarouselDayBlock(
                        title: "두번째 블럭두번째 블럭두번째 블럭두번째 블럭두번째 블럭",
                        totalAmount: 153.0,
                        todayAmount: 1.5,
                        symbol: Symbol.pause_fill.symbolName,
                        color: .blue,
                        state: .back
                    )
                    
                    CarouselAddBlock(
                        onTap: {
                            store.send(.onTapAddBlock)
                        }
                    )
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .safeAreaPadding(.horizontal, (geometry.size.width - cellSize) / 2)
        }
        .frame(height: cellSize)
    }
}
