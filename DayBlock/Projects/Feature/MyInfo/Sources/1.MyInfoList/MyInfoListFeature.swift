//
//  MyInfoListFeature.swift
//  MyInfo
//
//  Created by 김민준 on 2/14/26.
//

import Foundation
import ComposableArchitecture
import Domain
import PersistentData
import Util

@Reducer
public struct MyInfoListFeature {
    
    @Reducer
    public enum Path {
        case resetData(ResetDataFeature)
        case developerInfo(DeveloperInfoFeature)
    }

    @ObservableState
    public struct State: Equatable {
        public var path = StackState<Path.State>()
        var appVersion: String = ""
        var totalOutput: Double = 0
        var todayOutput: Double = 0
        var streaks: Int = 0

        public init() {}
    }

    public enum Action: TCAFeatureAction {
        public enum ViewAction {
            case onAppear
            case onTapInquiryCell
            case onTapResetDataCell
            case onTapAppStoreReviewCell
            case onTapDeveloperInfoCell
            case onTapOpenChatCell
        }

        public enum InnerAction {
            case setOutputStats(total: Double, today: Double, streaks: Int)
        }

        public enum DelegateAction {
            
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case path(StackActionOf<Path>)
    }

    public init() {}

    @Dependency(\.date) private var date
    @Dependency(\.calendar) private var calendar
    @Dependency(\.urlClient) private var urlClient
    @Dependency(\.appInfoClient) private var appInfoClient
    @Dependency(\.groupRepository) private var groupRepository
    @Dependency(\.blockRepository) private var blockRepository
    @Dependency(\.trackingRepository) private var trackingRepository

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .onAppear:
                    state.appVersion = appInfoClient.version
                    return fetchOutputStats()

                case .onTapInquiryCell:
                    urlClient.open(.inquiry)
                    return .none

                case .onTapResetDataCell:
                    state.path.append(.resetData(.init()))
                    return .none
                    
                case .onTapAppStoreReviewCell:
                    urlClient.open(.appStoreReview)
                    return .none
                    
                case .onTapDeveloperInfoCell:
                    state.path.append(.developerInfo(.init()))
                    return .none
                    
                case .onTapOpenChatCell:
                    urlClient.open(.openChat)
                    return .none
                }
                
            case .inner(let innerAction):
                switch innerAction {
                case .setOutputStats(let total, let today, let streaks):
                    state.totalOutput = total
                    state.todayOutput = today
                    state.streaks = streaks
                    return .none
                }

            case .path(.element(_, action: .resetData(.delegate(.didPop)))):
                state.path.removeLast()
                return .none

            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

// MARK: - Effect
extension MyInfoListFeature {

    /// 전체/오늘 생산량 및 연속 기록을 조회합니다.
    private func fetchOutputStats() -> Effect<Action> {
        .run { send in
            let allTimeDates = await fetchAllTrackingTimeDates()
            let total = computeTotalOutput(from: allTimeDates)
            let today = computeTodayOutput(from: allTimeDates)
            let streaks = computeStreaks(from: allTimeDates)
            await send(.inner(.setOutputStats(total: total, today: today, streaks: streaks)))
        }
    }

    /// 모든 그룹/블럭의 TrackingTime startDate를 수집합니다.
    private func fetchAllTrackingTimeDates() async -> [Date] {
        let allGroups = await groupRepository.fetchGroupList()
        var dates: [Date] = []
        for group in allGroups {
            let blocks = await blockRepository.fetchBlockList(groupId: group.id)
            for block in blocks {
                let sessions = await trackingRepository.fetchSessions(block.id)
                for session in sessions {
                    dates.append(contentsOf: session.timeList.map(\.startDate))
                }
            }
        }
        return dates
    }

    /// 전체 생산량을 계산합니다.
    private func computeTotalOutput(from dates: [Date]) -> Double {
        Double(dates.count) * 0.5
    }

    /// 오늘 생산량을 계산합니다.
    private func computeTodayOutput(from dates: [Date]) -> Double {
        let today = date.now
        let todayCount = dates.filter { calendar.isDate($0, inSameDayAs: today) }.count
        return Double(todayCount) * 0.5
    }

    /// 연속 생산 일수를 계산합니다.
    private func computeStreaks(from dates: [Date]) -> Int {
        let trackingDays = Set(dates.map { calendar.startOfDay(for: $0) })
        var streaks = 0
        var checkDate = calendar.startOfDay(for: date.now)

        // 오늘 아직 생산이 없으면 어제부터 체크 (오늘이 아직 안 끝났으므로)
        if !trackingDays.contains(checkDate) {
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: checkDate) else { return 0 }
            checkDate = yesterday
        }

        while trackingDays.contains(checkDate) {
            streaks += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
            checkDate = previousDay
        }

        return streaks
    }
}

// MARK: - Path
extension MyInfoListFeature.Path.State: Equatable {}
