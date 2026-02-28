//
//  MyInfoListFeature.swift
//  MyInfo
//
//  Created by 김민준 on 2/14/26.
//

import ComposableArchitecture
import Domain
import Util

@Reducer
public struct MyInfoListFeature {
    
    @Reducer
    public enum Path {
        case resetData(ResetDataFeature)
    }

    @ObservableState
    public struct State: Equatable {
        public var path = StackState<Path.State>()
        
        public init() {}
    }

    public enum Action: TCAFeatureAction {
        public enum ViewAction {
            case onTapInquiryCell
            case onTapResetDataCell
        }

        public enum InnerAction {

        }

        public enum DelegateAction {
            
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case path(StackActionOf<Path>)
    }

    public init() {}

    @Dependency(\.urlClient) private var urlClient

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .onTapInquiryCell:
                    urlClient.open(.inquiry)
                    return .none

                case .onTapResetDataCell:
                    state.path.append(.resetData(.init()))
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

// MARK: - Path
extension MyInfoListFeature.Path.State: Equatable {}
