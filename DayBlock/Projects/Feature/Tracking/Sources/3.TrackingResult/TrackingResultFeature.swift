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

    public enum Action: TCAFeatureAction {
        public enum ViewAction {
            
        }

        public enum InnerAction {

        }

        public enum DelegateAction {
            
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            
                
            default:
                return .none
            }
        }
    }
}
