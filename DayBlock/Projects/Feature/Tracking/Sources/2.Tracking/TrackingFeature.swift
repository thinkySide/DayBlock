//
//  TrackingFeature.swift
//  Tracking
//
//  Created by 김민준 on 1/10/26.
//

import Foundation
import ComposableArchitecture
import Domain
import Util

@Reducer
public struct TrackingFeature {

    @ObservableState
    public struct State: Equatable {
        var trackingGroup: BlockGroup
        var trackingBlock: Block
        var currentDate: Date = .now
        var elapsedTime: TimeInterval = 0

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
            case onAppear
            case onTapDismissButton
        }

        public enum InnerAction {
            case setCurrentDate(Date)
            case updateElapsedTime
        }

        public enum DelegateAction {
            case didDismiss
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
    }

    @CasePathable
    enum CancelID {
        case trackingTimer
    }

    public init() {}

    @Dependency(\.date) private var date
    @Dependency(\.continuousClock) private var clock

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .onAppear:
                    state.elapsedTime = 0
                    return startTrackingTimer()

                case .onTapDismissButton:
                    return .concatenate(
                        .cancel(id: CancelID.trackingTimer),
                        .send(.delegate(.didDismiss))
                    )
                }

            case .inner(let innerAction):
                switch innerAction {
                case .setCurrentDate(let currentDate):
                    state.currentDate = currentDate
                    return .none

                case .updateElapsedTime:
                    state.elapsedTime += 1
                    return .none
                }

            case .delegate(let delegateAction):
                switch delegateAction {
                case .didDismiss:
                    return .none
                }
            }
        }
    }
}

// MARK: - Shared Effect
extension TrackingFeature {

    /// 트래킹 타이머를 시작합니다.
    private func startTrackingTimer() -> Effect<Action> {
        .run { send in
            for await _ in self.clock.timer(interval: .seconds(1)) {
                await send(.inner(.updateElapsedTime))
            }
        }
        .cancellable(id: CancelID.trackingTimer, cancelInFlight: true)
    }
}
