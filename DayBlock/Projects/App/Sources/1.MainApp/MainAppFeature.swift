//
//  MainAppFeature.swift
//  App
//
//  Created by 김민준 on 12/21/25.
//

import ComposableArchitecture
import Tracking
import Management
import Calendar
import MyInfo

@Reducer
struct MainAppFeature {

    @ObservableState
    struct State {
        var tracking: BlockCarouselFeature.State = .init()
        var management: ManagementTabFeature.State = .init()
        var calendar: CalendarFeature.State = .init()
        var myInfo: MyInfoListFeature.State = .init()
        
        var selectedTab: MainTab = .tracking
        var isTabBarHidden: Bool = false
        
        /// TabBar가 표시되는 조건을 반환합니다.
        var isTabBarVisible: Bool {
            !isTabBarHidden
            && tracking.path.isEmpty
            && management.path.isEmpty
            && myInfo.path.isEmpty
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case tracking(BlockCarouselFeature.Action)
        case management(ManagementTabFeature.Action)
        case calendar(CalendarFeature.Action)
        case myInfo(MyInfoListFeature.Action)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Scope(state: \.tracking, action: \.tracking) {
            BlockCarouselFeature()
        }
        Scope(state: \.management, action: \.management) {
            ManagementTabFeature()
        }
        Scope(state: \.calendar, action: \.calendar) {
            CalendarFeature()
        }
        Scope(state: \.myInfo, action: \.myInfo) {
            MyInfoListFeature()
        }
        Reduce { state, action in
            switch action {
            case .tracking(.delegate(.didStart)):
                state.isTabBarHidden = true
                return .none
                
            case .tracking(.delegate(.didFinish)):
                state.isTabBarHidden = false
                return .none
                
            default:
                return .none
            }
        }
    }
}
