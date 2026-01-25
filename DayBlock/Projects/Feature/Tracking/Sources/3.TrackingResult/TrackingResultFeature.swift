//
//  TrackingResultFeature.swift
//  Tracking
//
//  Created by 김민준 on 1/24/26.
//

import Foundation
import ComposableArchitecture
import Domain
import Util

@Reducer
public struct TrackingResultFeature {

    @ObservableState
    public struct State: Equatable {
        var trackingGroup: BlockGroup
        var trackingBlock: Block
        var completedTrackingTimeList: [TrackingData.Time]
        var totalTime: TimeInterval
        
        public init(
            trackingGroup: BlockGroup,
            trackingBlock: Block,
            completedTrackingTimeList: [TrackingData.Time],
            totalTime: TimeInterval
        ) {
            self.trackingGroup = trackingGroup
            self.trackingBlock = trackingBlock
            self.completedTrackingTimeList = completedTrackingTimeList
            self.totalTime = totalTime
        }
    }

    public enum Action: TCAFeatureAction, BindableAction {
        public enum ViewAction {
            case onTapFinishButton
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
                }
                
            default:
                return .none
            }
        }
    }
}
