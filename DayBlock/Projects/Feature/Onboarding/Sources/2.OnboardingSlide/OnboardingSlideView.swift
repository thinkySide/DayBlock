//
//  OnboardingSlideView.swift
//  Onboarding
//
//  Created by 김민준 on 3/1/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct OnboardingSlideView: View {

    @Bindable private var store: StoreOf<OnboardingSlideFeature>

    public init(store: StoreOf<OnboardingSlideFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            PageIndicator(currentPage: store.currentPage, totalPages: 4)

            TabView(selection: $store.currentPage) {
                OnboardingPage(
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
                    subtitle: "“00:00분부터 23:59분까지가 하루에요”"
                )
                .tag(0)

                OnboardingPage(
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
                )
                .tag(1)
                
                OnboardingPage(
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
                    subtitle: "“공부, 운동, 독서 어떤 작업이든 트래킹해요”"
                )
                .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.top, 24)
        }
        .navigationBarBackButtonHidden()
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
        .frame(maxHeight: .infinity, alignment: .top)
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
