//
//  OnboardingSlideFeature.swift
//  Onboarding
//
//  Created by 김민준 on 3/1/26.
//

import Foundation
import ComposableArchitecture
import DesignSystem
import Domain
import Editor
import PersistentData
import UserDefaults
import Util

@Reducer
public struct OnboardingSlideFeature {

    @ObservableState
    public struct State: Equatable {
        var currentPage: Int = 0
        var isCompletionAnimating: Bool = false
        var trackingEditor: TrackingEditorFeature.State?

        let tutorialBlockName: String = "튜토리얼 블럭"
        let tutorialBlockSymbol: String = Symbol.party_popper_fill.symbolName
        let tutorialBlockColor: Int = 4
        let tutorialBlockAmount: Double = 0.5

        public init() {}
    }

    public enum Action: TCAFeatureAction, BindableAction {
        public enum ViewAction {
            case onLongPressCompleteTutorialBlock
            case onCompletionAnimationComplete
        }

        public enum InnerAction {
            case hideCompletionOverlay
            case setTrackingEditor(TrackingEditorFeature.State)
        }

        public enum DelegateAction {
            case didCompleteOnboarding
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)
        case trackingEditor(TrackingEditorFeature.Action)
    }

    @Dependency(\.date) private var date
    @Dependency(\.uuid) private var uuid
    @Dependency(\.haptic) private var haptic
    @Dependency(\.continuousClock) private var clock
    @Dependency(\.groupRepository) private var groupRepository
    @Dependency(\.blockRepository) private var blockRepository
    @Dependency(\.trackingRepository) private var trackingRepository
    @Dependency(\.userDefaultsService) private var userDefaultsService

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
                return createTutorialData(state)

            case .inner(.setTrackingEditor(let editorState)):
                state.trackingEditor = editorState
                return .none

            case .inner(.hideCompletionOverlay):
                state.isCompletionAnimating = false
                return .none

            case .trackingEditor(.delegate(.didFinish)):
                state.trackingEditor = nil
                userDefaultsService.set(\.isOnboardingCompleted, true)
                return .send(.delegate(.didCompleteOnboarding))

            default:
                return .none
            }
        }
        .ifLet(\.trackingEditor, action: \.trackingEditor) {
            TrackingEditorFeature()
        }
    }
}

// MARK: - Shared Effect
extension OnboardingSlideFeature {

    private func createTutorialData(_ state: State) -> Effect<Action> {
        let name = state.tutorialBlockName
        let colorIndex = state.tutorialBlockColor
        let amount = state.tutorialBlockAmount

        return .run { send in
            let defaultGroup = await groupRepository.fetchDefaultGroup()

            let blockId = uuid()
            let tutorialBlock = try await blockRepository.createBlock(
                defaultGroup.id,
                Block(
                    id: blockId,
                    name: name,
                    iconIndex: 0,
                    colorIndex: colorIndex,
                    output: amount,
                    order: 0
                )
            )

            let now = date.now
            let startDate = now.addingTimeInterval(-1800)
            let trackingTime = TrackingTime(startDate: startDate, endDate: now)
            let sessionId = uuid()
            let session = TrackingSession(
                id: sessionId,
                createdAt: now,
                timeList: [trackingTime]
            )
            _ = try await trackingRepository.createSession(tutorialBlock.id, session)

            let editorState = TrackingEditorFeature.State(
                trackingGroup: defaultGroup,
                trackingBlock: tutorialBlock,
                sessionPages: [
                    .init(
                        id: sessionId,
                        trackingTimeList: [trackingTime],
                        totalTime: 1800,
                        memoText: """
                        튜토리얼을 위해
                        데이블럭이 미리 생산해둔
                        30분짜리 블럭이에요 🥳
                        """
                    )
                ]
            )
            await send(.inner(.setTrackingEditor(editorState)))

            try? await clock.sleep(for: .milliseconds(600))
            await send(.inner(.hideCompletionOverlay))
        }
    }
}
