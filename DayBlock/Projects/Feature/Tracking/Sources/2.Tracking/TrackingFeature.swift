//
//  TrackingFeature.swift
//  Tracking
//
//  Created by 김민준 on 1/10/26.
//

import ComposableArchitecture
import Domain
import Util

@Reducer
public struct TrackingFeature {

    @ObservableState
    public struct State: Equatable {
        var trackingGroup: BlockGroup
        var trackingBlock: Block
        
        public init(
            trackingGroup: BlockGroup,
            trackingBlock: Block
        ) {
            self.trackingGroup = trackingGroup
            self.trackingBlock = trackingBlock
            Debug.log("group: \(trackingGroup.name), block: \(trackingBlock.name)")
        }
    }

    public enum Action: TCAFeatureAction {
        public enum ViewAction {
            case onTapDismissButton
        }

        public enum InnerAction {

        }

        public enum DelegateAction {
            case didDismiss
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .onTapDismissButton:
                    return .send(.delegate(.didDismiss))
                }
                
            case .delegate(let delegateAction):
                switch delegateAction {
                case .didDismiss:
                    return .none
                }
                
            default:
                return .none
            }
        }
    }
}
