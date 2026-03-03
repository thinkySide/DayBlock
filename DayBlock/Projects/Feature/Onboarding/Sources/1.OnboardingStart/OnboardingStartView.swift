//
//  OnboardingStartView.swift
//  Onboarding
//
//  Created by 김민준 on 3/1/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct OnboardingStartView: View {
    
    @Bindable private var store: StoreOf<OnboardingStartFeature>

    public init(store: StoreOf<OnboardingStartFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()
                
                DesignSystem.Icons.app.swiftUIImage
                    .resizable()
                    .frame(width: 88, height: 88)
                
                Text("DayBlock")
                    .brandFont(.poppins(.bold), 40)
                    .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                    .padding(.top, 32)
                
                Text("나만의 생산성 블럭 만들기")
                    .brandFont(.pretendard(.bold), 18)
                    .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                    .padding(.top, 12)
                
                Button {
                    store.send(.view(.startButtonTapped))
                } label: {
                    HStack(spacing: 6) {
                        Text("시작하기")
                            .brandFont(.pretendard(.bold), 16)
                        
                        SFSymbol(
                            symbol: Symbol.chevron_forward.symbolName,
                            size: 10,
                            color: DesignSystem.Colors.gray0.swiftUIColor
                        )
                        .fontWeight(.medium)
                    }
                    .foregroundStyle(DesignSystem.Colors.gray0.swiftUIColor)
                    .padding(.horizontal, 24)
                    .frame(height: 48)
                    .background(DesignSystem.Colors.gray900.swiftUIColor)
                    .clipShape(.capsule)
                }
                .padding(.top, 48)
                .scaleButton()
                
                Spacer()
            }
            .background(DesignSystem.Colors.gray0.swiftUIColor)
            .navigationDestination(
                item: $store.scope(
                    state: \.slide,
                    action: \.slide
                )
            ) { store in
                OnboardingSlideView(store: store)
            }
        }
    }
}
