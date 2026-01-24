//
//  TrackingFeature.swift
//  Tracking
//
//  Created by 김민준 on 1/10/26.
//

import Foundation
import ComposableArchitecture
import Domain
import UserDefaults
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

        /// 트래킹 시작하는 생성자
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

        /// 저장된 세션에서 복원하는 생성자
        public init(
            trackingGroup: BlockGroup,
            trackingBlock: Block,
            trackingSession: TrackingSessionState
        ) {
            @Dependency(\.date) var date
            self.trackingGroup = trackingGroup
            self.trackingBlock = trackingBlock
            self.trackingTime = .init(startDate: trackingSession.trackingStartDate, endDate: nil)
            self.completedTrackingTimeList = trackingSession.completedTrackingTimeList.map {
                TrackingData.Time(startDate: $0.startDate, endDate: $0.endDate)
            }
            self.isPaused = trackingSession.isPaused
            self.timerBaseDate = trackingSession.timerBaseDate

            if trackingSession.isPaused {
                self.elapsedTime = trackingSession.elapsedTime
            } else {
                self.elapsedTime = date.now.timeIntervalSince(trackingSession.timerBaseDate)
            }

            let completedTime = trackingSession.completedTrackingTimeList.reduce(0) { total, time in
                total + time.endDate.timeIntervalSince(time.startDate)
            }
            self.totalTime = self.elapsedTime + completedTime
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
            case updateCurrentDate
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
        case clockTimer
        case trackingTimer
    }

    public init() {}

    @Dependency(\.date) private var date
    @Dependency(\.continuousClock) private var clock
    @Dependency(\.haptic) private var haptic
    @Dependency(\.userDefaultsService) private var userDefaultsService

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .onAppear:
                    saveTrackingSession(state)
                    if state.isPaused {
                        return startClockTimer()
                    }
                    return .merge(
                        startClockTimer(),
                        startTrackingTimer()
                    )

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
                        saveTrackingSession(state)
                        return .cancel(id: CancelID.trackingTimer)
                    } else {
                        state.timerBaseDate = date.now.addingTimeInterval(-state.elapsedTime)
                        saveTrackingSession(state)
                        return startTrackingTimer()
                    }
                    
                case .onLongPressCompleteTrackingBlock:
                    state.isToastPresented = true
                    haptic.notification(.error)
                    return .none
                }

            case .inner(let innerAction):
                switch innerAction {
                case .updateCurrentDate:
                    state.currentDate = date.now
                    return .none

                case .updateElapsedTime:
                    state.elapsedTime = date.now.timeIntervalSince(state.timerBaseDate)

                    while state.elapsedTime >= state.standardTime {
                        let blockEndDate = state.timerBaseDate.addingTimeInterval(state.standardTime)
                        state.trackingTime.endDate = blockEndDate
                        state.completedTrackingTimeList.append(state.trackingTime)
                        state.timerBaseDate = blockEndDate
                        state.trackingTime = .init(startDate: blockEndDate, endDate: nil)
                        state.elapsedTime = date.now.timeIntervalSince(state.timerBaseDate)
                    }

                    let completedTime = state.completedTrackingTimeList.reduce(0) { total, time in
                        guard let endDate = time.endDate else { return total }
                        return total + endDate.timeIntervalSince(time.startDate)
                    }
                    state.totalTime = completedTime + state.elapsedTime
                    saveTrackingSession(state)

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
                    userDefaultsService.remove(\.trackingSession)
                    return .concatenate(
                        .cancel(id: CancelID.clockTimer),
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

    /// 시계 타이머를 시작합니다.
    private func startClockTimer() -> Effect<Action> {
        .run { send in
            for await _ in self.clock.timer(interval: .seconds(1)) {
                await send(.inner(.updateCurrentDate))
            }
        }
        .cancellable(id: CancelID.clockTimer, cancelInFlight: true)
    }

    /// 트래킹 타이머를 시작합니다.
    private func startTrackingTimer() -> Effect<Action> {
        .run { send in
            for await _ in self.clock.timer(interval: .seconds(1)) {
                await send(.inner(.updateElapsedTime))
            }
        }
        .cancellable(id: CancelID.trackingTimer, cancelInFlight: true)
    }

    /// 트래킹 세션을 UserDefaults에 저장합니다.
    private func saveTrackingSession(_ state: State) {
        let completedTimeList = state.completedTrackingTimeList.compactMap {
            time -> TrackingSessionState.CompletedTime? in
            guard let endDate = time.endDate else { return nil }
            return .init(startDate: time.startDate, endDate: endDate)
        }

        let session = TrackingSessionState(
            trackingGroupId: state.trackingGroup.id,
            trackingBlockId: state.trackingBlock.id,
            trackingStartDate: state.trackingTime.startDate,
            timerBaseDate: state.timerBaseDate,
            elapsedTime: state.elapsedTime,
            completedTrackingTimeList: completedTimeList,
            isPaused: state.isPaused
        )

        userDefaultsService.set(\.trackingSession, session)
    }
}
