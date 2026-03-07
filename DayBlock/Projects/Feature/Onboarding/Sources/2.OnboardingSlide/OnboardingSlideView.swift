//
//  OnboardingSlideView.swift
//  Onboarding
//
//  Created by 김민준 on 3/1/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Editor

public struct OnboardingSlideView: View {

    @Bindable private var store: StoreOf<OnboardingSlideFeature>

    public init(store: StoreOf<OnboardingSlideFeature>) {
        self.store = store
    }

    public var body: some View {
        TabView(selection: $store.currentPage) {
            ForEach(onboardingItems) { item in
                OnboardingPage(
                    text: item.text,
                    image: item.image,
                    subtitle: item.subtitle
                )
                .tag(item.id)
            }
            
            TutorialPage()
                .tag(onboardingItems.count)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .padding(.top, 24)
        .navigationBarBackButtonHidden()
        .overlay(alignment: .top) {
            PageIndicator(
                currentPage: store.currentPage,
                totalPages: onboardingItems.count + 1
            )
        }
        .overlay {
            if store.isCompletionAnimating {
                TrackingCompletionOverlay(
                    color: DesignSystem.Colors.gray900.swiftUIColor,
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
    
    @ViewBuilder
    private func OnboardingPage(
        text: AttributedString,
        image: Image,
        subtitle: String
    ) -> some View {
        VStack(spacing: 0) {
            Text(text)
                .multilineTextAlignment(.center)

            image
                .padding(.horizontal, 48)
            
            Text(subtitle)
                .brandFont(.pretendard(.medium), 15)
                .foregroundStyle(DesignSystem.Colors.gray800.swiftUIColor)
        }
    }
    
    @ViewBuilder
    private func TutorialPage() -> some View {
        VStack(spacing: 0) {
            Text(.buildAttributed([
                .init(
                    text: "하루하루 데이블럭과 함께\n",
                    color: DesignSystem.Colors.gray900.swiftUIColor,
                    font: DesignSystemFontFamily.Pretendard.bold.swiftUIFont(size: 20)
                ),
                .init(
                    text: "블럭을 채워나가볼까요?",
                    color: DesignSystem.Colors.gray900.swiftUIColor,
                    font: DesignSystemFontFamily.Pretendard.medium.swiftUIFont(size: 20)
                )
            ]))
            .multilineTextAlignment(.center)
            .padding(.top, 32)

            TrackingDayBlock(
                title: store.tutorialBlockName,
                todayAmount: store.tutorialBlockAmount,
                symbol: store.tutorialBlockSymbol,
                color: ColorPalette.toColor(from: store.tutorialBlockColor),
                size: 180,
                isPaused: true,
                onLongPressComplete: {
                    store.send(.view(.onLongPressCompleteTutorialBlock))
                }
            )
            .padding(.top, 40)
            
            Text(.buildAttributed([
                .init(
                    text: "“블럭을 길-게 눌러",
                    color: DesignSystem.Colors.gray900.swiftUIColor,
                    font: DesignSystemFontFamily.Pretendard.bold.swiftUIFont(size: 15)
                ),
                .init(
                    text: "첫 생산을 완료해요“",
                    color: DesignSystem.Colors.gray800.swiftUIColor,
                    font: DesignSystemFontFamily.Pretendard.medium.swiftUIFont(size: 15)
                )
            ]))
            .padding(.top, 40)
            
            Text("* 튜토리얼을 위해 30분짜리 블럭을 미리 생산해뒀어요!")
                .brandFont(.pretendard(.semiBold), 13)
                .foregroundStyle(DesignSystem.Colors.gray600.swiftUIColor)
                .padding(.top, 12)
        }
    }
}

// MARK: - PageIndicator

private struct PageIndicator: View {

    let currentPage: Int
    let totalPages: Int

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .foregroundStyle(.clear)
                .frame(height: 200)

            HStack(spacing: 8) {
                ForEach(0..<totalPages, id: \.self) { index in
                    Circle()
                        .fill(
                            index == currentPage
                            ? DesignSystem.Colors.gray900.swiftUIColor
                            : DesignSystem.Colors.gray300.swiftUIColor
                        )
                        .frame(width: 8, height: 8)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: currentPage)
        }
    }
}

// MARK: - Items
extension OnboardingSlideView {
    
    public struct OnboardingSlideItem: Identifiable {
        public let id: Int
        let text: AttributedString
        let image: Image
        let subtitle: String
    }
    
    private var onboardingItems: [OnboardingSlideItem] {
        [
            OnboardingSlideItem(
                id: 0,
                text: .buildAttributed(
                    [
                        .init(
                            text: "데이블럭의 하루에는\n",
                            color: DesignSystem.Colors.gray900.swiftUIColor,
                            font: DesignSystemFontFamily.Pretendard.medium.swiftUIFont(size: 20)
                        ),
                        .init(
                            text: "24개의 빈 블럭이 있어요",
                            color: DesignSystem.Colors.gray900.swiftUIColor,
                            font: DesignSystemFontFamily.Pretendard.bold.swiftUIFont(size: 20)
                        )
                    ]
                ),
                image: DesignSystem.Images.onboarding1.swiftUIImage,
                subtitle: "“00:00분부터 23:59분까지가 하루에요“"
            ),
            OnboardingSlideItem(
                id: 1,
                text: .buildAttributed(
                    [
                        .init(
                            text: "블럭은",
                            color: DesignSystem.Colors.gray900.swiftUIColor,
                            font: DesignSystemFontFamily.Pretendard.medium.swiftUIFont(size: 20)
                        ),
                        .init(
                            text: "30분에 반 개\n60분에 한 개",
                            color: DesignSystem.Colors.gray900.swiftUIColor,
                            font: DesignSystemFontFamily.Pretendard.bold.swiftUIFont(size: 20)
                        ),
                        .init(
                            text: "씩 생산할 수 있어요",
                            color: DesignSystem.Colors.gray900.swiftUIColor,
                            font: DesignSystemFontFamily.Pretendard.medium.swiftUIFont(size: 20)
                        )
                    ]
                ),
                image: DesignSystem.Images.onboarding2.swiftUIImage,
                subtitle: "“최소 30분 이상 생산해야 블럭이 생겨요“"
            ),
            OnboardingSlideItem(
                id: 2,
                text: .buildAttributed(
                    [
                        .init(
                            text: "직접 만든 블럭으로",
                            color: DesignSystem.Colors.gray900.swiftUIColor,
                            font: DesignSystemFontFamily.Pretendard.medium.swiftUIFont(size: 20)
                        ),
                        .init(
                            text: "생산성을\n얼마나 발휘 했는지 트래킹",
                            color: DesignSystem.Colors.gray900.swiftUIColor,
                            font: DesignSystemFontFamily.Pretendard.bold.swiftUIFont(size: 20)
                        ),
                        .init(
                            text: "해요",
                            color: DesignSystem.Colors.gray900.swiftUIColor,
                            font: DesignSystemFontFamily.Pretendard.medium.swiftUIFont(size: 20)
                        )
                    ]
                ),
                image: DesignSystem.Images.onboarding3.swiftUIImage,
                subtitle: "“공부, 운동, 독서 어떤 작업이든 트래킹해요“"
            )
        ]
    }
}
