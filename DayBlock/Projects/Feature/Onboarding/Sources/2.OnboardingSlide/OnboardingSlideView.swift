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
            PageIndicator(
                currentPage: store.currentPage,
                totalPages: store.onboardingItems.count
            )

            TabView(selection: $store.currentPage) {
                ForEach(store.onboardingItems) { item in
                    OnboardingPage(
                        text: item.text,
                        image: item.image,
                        subtitle: item.subtitle
                    )
                    .tag(item.id)
                }
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
