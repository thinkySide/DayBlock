//
//  OnboardingSlideFeature.swift
//  Onboarding
//
//  Created by 김민준 on 3/1/26.
//

import Foundation
import ComposableArchitecture
import Domain
import Editor
import Util

@Reducer
public struct OnboardingSlideFeature {

    @ObservableState
    public struct State: Equatable {
        var currentPage: Int = 0
        var isCompletionAnimating: Bool = false
        var trackingEditor: TrackingEditorFeature.State?

        public init() {}
    }

    public enum Action: TCAFeatureAction, BindableAction {
        public enum ViewAction {
            case onLongPressCompleteTutorialBlock
            case onCompletionAnimationComplete
        }

        public enum InnerAction {
            case hideCompletionOverlay
        }

        public enum DelegateAction {}

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)
        case trackingEditor(TrackingEditorFeature.Action)
    }

    @Dependency(\.haptic) private var haptic
    @Dependency(\.continuousClock) private var clock

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.currentPage):
                haptic.impact(.light)
                return .none

            case .view(.onLongPressCompleteTutorialBlock):
                state.isCompletionAnimating = true
                haptic.notification(.success)
                return .none

            case .view(.onCompletionAnimationComplete):
                let now = Date()
                let startDate = now.addingTimeInterval(-1800)
                let trackingTime = TrackingTime(startDate: startDate, endDate: now)
                let sessionId = UUID()

                state.trackingEditor = .init(
                    trackingGroup: .init(id: UUID(), name: "튜토리얼", order: 0),
                    trackingBlock: .init(id: UUID(), name: "튜토리얼 블럭", iconIndex: 0, colorIndex: 0, output: 0.5, order: 0),
                    sessionPages: [
                        .init(id: sessionId, trackingTimeList: [trackingTime], totalTime: 1800)
                    ]
                )
                return .run { send in
                    try? await clock.sleep(for: .milliseconds(600))
                    await send(.inner(.hideCompletionOverlay))
                }

            case .inner(.hideCompletionOverlay):
                state.isCompletionAnimating = false
                return .none

            case .trackingEditor(.delegate(.didFinish)):
                state.trackingEditor = nil
                return .none

            default:
                return .none
            }
        }
        .ifLet(\.trackingEditor, action: \.trackingEditor) {
            TrackingEditorFeature()
        }
    }
}
