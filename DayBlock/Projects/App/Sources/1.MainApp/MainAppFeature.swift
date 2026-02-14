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
        var selectedTab: MainTab = .tracking
        
        var tracking: BlockCarouselFeature.State = .init()
        var management: ManagementTabFeature.State = .init()
        var calendar: CalendarFeature.State = .init()
        var myInfo: MyInfoListFeature.State = .init()
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
            case .binding:
                return .none

            case .tracking:
                return .none
                
            case .management:
                return .none
                
            case .calendar:
                return .none
                
            case .myInfo:
                return .none
            }
        }
    }
}
