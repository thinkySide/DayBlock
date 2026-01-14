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
        let standardTime: TimeInterval = 1800
        var trackingGroup: BlockGroup
        var trackingBlock: Block
        var trackingTime: TrackingData.Time
        var completedTrackingTimeList: [TrackingData.Time] = []
        var currentDate: Date = .now
        var totalTime: TimeInterval = 0
        var elapsedTime: TimeInterval = 0
        var timerBaseDate: Date
        var isPaused: Bool = false
        var isPopupPresented: Bool = false
        var isToastPresented: Bool = false

        public init(
            trackingGroup: BlockGroup,
            trackingBlock: Block
        ) {
            @Dependency(\.date) var date
            self.trackingGroup = trackingGroup
            self.trackingBlock = trackingBlock
            let nowDate = date.now
            self.trackingTime = .init(startDate: nowDate, endDate: nil)
            self.timerBaseDate = nowDate
        }
    }

    public enum Action: TCAFeatureAction, BindableAction {
        public enum ViewAction {
            case onAppear
            case onScenePhaseActive
            case onTapDismissButton
            case onTapTrackingButton
            case onLongPressCompleteTrackingBlock
        }

        public enum InnerAction {
            case setCurrentDate(Date)
            case updateElapsedTime
        }

        public enum DelegateAction {
            case didDismiss
        }
        
        public enum PopupAction {
            case cancel
            case stopTracking
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case popup(PopupAction)
        case binding(BindingAction<State>)
    }

    @CasePathable
    enum CancelID {
        case trackingTimer
    }

    public init() {}

    @Dependency(\.date) private var date
    @Dependency(\.continuousClock) private var clock
    @Dependency(\.haptic) private var haptic

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .onAppear:
                    return startTrackingTimer()

                case .onScenePhaseActive:
                    guard !state.isPaused else { return .none }
                    return .send(.inner(.updateElapsedTime))

                case .onTapDismissButton:
                    state.isPopupPresented = true
                    return .none
                    
                case .onTapTrackingButton:
                    state.isPaused.toggle()
                    haptic.impact(.light)
                    if state.isPaused {
                        return .cancel(id: CancelID.trackingTimer)
                    } else {
                        state.timerBaseDate = date.now.addingTimeInterval(-state.elapsedTime)
                        return startTrackingTimer()
                    }
                    
                case .onLongPressCompleteTrackingBlock:
                    state.isToastPresented = true
                    haptic.notification(.error)
                    return .none
                }

            case .inner(let innerAction):
                switch innerAction {
                case .setCurrentDate(let currentDate):
                    state.currentDate = currentDate
                    return .none

                case .updateElapsedTime:
                    state.elapsedTime = date.now.timeIntervalSince(state.timerBaseDate)

                    let completedTime = state.completedTrackingTimeList.reduce(0) { total, time in
                        guard let endDate = time.endDate else { return total }
                        return total + endDate.timeIntervalSince(time.startDate)
                    }
                    state.totalTime = completedTime + state.elapsedTime

                    if state.elapsedTime >= state.standardTime {
                        state.trackingTime.endDate = date.now
                        state.completedTrackingTimeList.append(state.trackingTime)
                        state.trackingTime = .init(startDate: date.now, endDate: nil)
                        state.timerBaseDate = date.now
                        state.elapsedTime = 0
                    }

                    return .none
                }

            case .delegate(let delegateAction):
                switch delegateAction {
                case .didDismiss:
                    return .none
                }
                
            case .popup(let popupAction):
                switch popupAction {
                case .cancel:
                    state.isPopupPresented = false
                    return .none

                case .stopTracking:
                    return .concatenate(
                        .cancel(id: CancelID.trackingTimer),
                        .send(.delegate(.didDismiss))
                    )
                }
                
            default:
                return .none
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
