//
//  TrackingResultFeature.swift
//  Tracking
//
//  Created by 김민준 on 1/24/26.
//

import Foundation
import ComposableArchitecture
import Domain
import Editor
import Util

@Reducer
public struct TrackingResultFeature {

    @ObservableState
    public struct State: Equatable {
        var trackingGroup: BlockGroup
        var trackingBlock: Block
        var completedTrackingTimeList: [TrackingTime]
        var totalTime: TimeInterval
        var sessionId: UUID
        var memoText: String = ""

        @Presents var memoEditor: MemoEditorFeature.State?

        public init(
            trackingGroup: BlockGroup,
            trackingBlock: Block,
            completedTrackingTimeList: [TrackingTime],
            totalTime: TimeInterval,
            sessionId: UUID
        ) {
            self.trackingGroup = trackingGroup
            self.trackingBlock = trackingBlock
            self.completedTrackingTimeList = completedTrackingTimeList
            self.totalTime = totalTime
            self.sessionId = sessionId
        }
    }

    public enum Action: TCAFeatureAction, BindableAction {
        public enum ViewAction {
            case onTapFinishButton
            case onTapMemoEditor
        }

        public enum InnerAction {

        }

        public enum DelegateAction {
            case didFinish
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)
        case memoEditor(PresentationAction<MemoEditorFeature.Action>)
    }
    
    @Dependency(\.haptic) private var haptic

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .onTapFinishButton:
                    haptic.impact(.light)
                    return .send(.delegate(.didFinish))
                    
                case .onTapMemoEditor:
                    state.memoEditor = .init(
                        memoText: state.memoText,
                        colorIndex: state.trackingBlock.colorIndex
                    )
                    return .none
                }
                
            case .memoEditor(.presented(.delegate(.didDismiss))):
                state.memoEditor = nil
                return .none
                
            case .memoEditor(.presented(.delegate(.didConfirm(let memoText)))):
                state.memoText = memoText
                state.memoEditor = nil
                return .none
                
            default:
                return .none
            }
        }
        .ifLet(\.$memoEditor, action: \.memoEditor) {
            MemoEditorFeature()
        }
    }
}
