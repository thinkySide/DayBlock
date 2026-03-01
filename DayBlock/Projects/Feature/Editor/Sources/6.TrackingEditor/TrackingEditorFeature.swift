//
//  TrackingEditorFeature.swift
//  Editor
//
//  Created by 김민준 on 1/24/26.
//

import Foundation
import ComposableArchitecture
import Domain
import PersistentData
import Util

@Reducer
public struct TrackingEditorFeature {

    public enum PresentationMode: Equatable {
        case trackingComplete
        case calendarDetail
    }

    public struct SessionPage: Equatable, Identifiable {
        public let id: UUID
        public let trackingTimeList: [TrackingTime]
        public let totalTime: TimeInterval
        public var memoText: String

        public init(
            id: UUID,
            trackingTimeList: [TrackingTime],
            totalTime: TimeInterval,
            memoText: String = ""
        ) {
            self.id = id
            self.trackingTimeList = trackingTimeList
            self.totalTime = totalTime
            self.memoText = memoText
        }
    }

    @ObservableState
    public struct State: Equatable {
        let presentationMode: PresentationMode
        var trackingGroup: BlockGroup
        var trackingBlock: Block
        var sessionPages: [SessionPage]
        var currentPageId: UUID?
        var isPopupPresented: Bool = false

        @Presents var memoEditor: MemoEditorFeature.State?

        var currentPage: SessionPage? {
            guard let currentPageId else { return sessionPages.first }
            return sessionPages.first(where: { $0.id == currentPageId })
        }

        /// calendarDetail용 init (단일 세션)
        public init(
            presentationMode: PresentationMode,
            trackingGroup: BlockGroup,
            trackingBlock: Block,
            completedTrackingTimeList: [TrackingTime],
            totalTime: TimeInterval,
            sessionId: UUID,
            memoText: String = ""
        ) {
            self.presentationMode = presentationMode
            self.trackingGroup = trackingGroup
            self.trackingBlock = trackingBlock
            let page = SessionPage(
                id: sessionId,
                trackingTimeList: completedTrackingTimeList,
                totalTime: totalTime,
                memoText: memoText
            )
            self.sessionPages = [page]
            self.currentPageId = page.id
        }

        /// trackingComplete용 init (다중 세션 페이지)
        public init(
            trackingGroup: BlockGroup,
            trackingBlock: Block,
            sessionPages: [SessionPage]
        ) {
            self.presentationMode = .trackingComplete
            self.trackingGroup = trackingGroup
            self.trackingBlock = trackingBlock
            self.sessionPages = sessionPages
            self.currentPageId = sessionPages.first?.id
        }
    }

    public enum Action: TCAFeatureAction, BindableAction {
        public enum ViewAction {
            case onTapFinishButton
            case onTapDismissButton
            case onTapDeleteButton
            case onTapMemoEditor
        }

        public enum InnerAction {

        }

        public enum DelegateAction {
            case didFinish
            case didDelete
        }

        public enum PopupAction {
            case cancel
            case deleteSession
        }

        case view(ViewAction)
        case inner(InnerAction)
        case delegate(DelegateAction)
        case popup(PopupAction)
        case binding(BindingAction<State>)
        case memoEditor(PresentationAction<MemoEditorFeature.Action>)
    }

    @Dependency(\.haptic) private var haptic
    @Dependency(\.trackingRepository) private var trackingRepository

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .onTapFinishButton:
                    haptic.impact(.light)
                    return saveMemoAndFinish(state: state)

                case .onTapDismissButton:
                    haptic.impact(.light)
                    return saveMemoAndFinish(state: state)

                case .onTapDeleteButton:
                    state.isPopupPresented = true
                    haptic.notification(.warning)
                    return .none

                case .onTapMemoEditor:
                    let currentMemo = state.currentPage?.memoText ?? ""
                    state.memoEditor = .init(
                        memoText: currentMemo,
                        colorIndex: state.trackingBlock.colorIndex
                    )
                    return .none
                }

            case .popup(let popupAction):
                switch popupAction {
                case .cancel:
                    state.isPopupPresented = false
                    return .none

                case .deleteSession:
                    state.isPopupPresented = false
                    guard let page = state.sessionPages.first else { return .none }
                    let sessionId = page.id
                    return .run { send in
                        await trackingRepository.deleteSession(sessionId)
                        await send(.delegate(.didDelete))
                    }
                }

            case .memoEditor(.presented(.delegate(.didDismiss))):
                state.memoEditor = nil
                return .none

            case .memoEditor(.presented(.delegate(.didConfirm(let memoText)))):
                if let currentPageId = state.currentPageId,
                   let index = state.sessionPages.firstIndex(where: { $0.id == currentPageId }) {
                    state.sessionPages[index].memoText = memoText
                }
                state.memoEditor = nil
                return .none

            default:
                return .none
            }
        }
        .ifLet(\.$memoEditor, action: \.memoEditor) {
            MemoEditorFeature()
        }
    }

    // MARK: - Private

    private func saveMemoAndFinish(state: State) -> Effect<Action> {
        let blockId = state.trackingBlock.id
        let pages = state.sessionPages
        return .concatenate(
            .run { _ in
                let sessions = await trackingRepository.fetchSessions(blockId)
                for page in pages {
                    guard var session = sessions.first(where: { $0.id == page.id }) else { continue }
                    session.memo = page.memoText
                    _ = try await trackingRepository.updateSession(page.id, session)
                }
            },
            .send(.delegate(.didFinish))
        )
    }
}
