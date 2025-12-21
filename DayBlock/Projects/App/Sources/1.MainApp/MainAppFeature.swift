//
//  MainAppFeature.swift
//  App
//
//  Created by 김민준 on 12/21/25.
//

import ComposableArchitecture
import Tracking

@Reducer
struct MainAppFeature {

    @ObservableState
    struct State {
        var selectedTab: MainTab = .tracking
        var trackingState: TrackingCarouselFeature.State = .init()
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            }
        }
    }
}
