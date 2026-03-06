//
//  OnboardingSlideFeature.swift
//  Onboarding
//
//  Created by 김민준 on 3/1/26.
//

import SwiftUI
import ComposableArchitecture
import Domain
import DesignSystem
import Util

@Reducer
public struct OnboardingSlideFeature {

    @ObservableState
    public struct State: Equatable {
        let onboardingItems: IdentifiedArrayOf<OnboardingSlideItem>
        var currentPage: Int = 0
        
        public init() {
            self.onboardingItems = OnboardingSlideFeature.onboardingItems
        }
    }

    public enum Action: TCAFeatureAction, BindableAction {
        public enum ViewAction {}

        public enum InnerAction {}

        public enum DelegateAction {}

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}

// MARK: - Model
extension OnboardingSlideFeature {
    
    public struct OnboardingSlideItem: Identifiable, Equatable {
        public let id: Int
        let text: AttributedString
        let image: Image
        let subtitle: String
    }
}

// MARK: - Helper
extension OnboardingSlideFeature {
    
    private static var onboardingItems: IdentifiedArrayOf<OnboardingSlideItem> {
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
