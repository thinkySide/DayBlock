//
//  ResetDataView.swift
//  MyInfo
//
//  Created by 김민준 on 2/15/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct ResetDataView: View {
    
    @Bindable private var store: StoreOf<ResetDataFeature>

    public init(store: StoreOf<ResetDataFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationBar(
                title: "초기화",
                leadingView: {
                    NavigationBarButton(.back) {
                        store.send(.view(.onTapBackButton))
                    }
                }
            )
            
            Text(resetDataString)
                .brandFont(.pretendard(.medium), 16)
                .lineSpacing(3)
                .padding(.top, 24)
                .padding(.horizontal, 24)
            
            ActionButton(
                title: "초기화하기",
                variation: .delete,
                action: {
                    store.send(.view(.onTapResetDataButton))
                }
            )
            .padding(.top, 32)
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .background(DesignSystem.Colors.gray0.swiftUIColor)
        .toolbarVisibility(.hidden, for: .navigationBar)
        .popup(
            isPresented: $store.isPopupPresented,
            title: "모든 데이터를 초기화할까요?",
            message: "그동안 생성된 데이터가 모두 삭제돼요",
            leftAction: .init(
                title: "아니오",
                variation: .secondary,
                action: {
                    store.send(.popup(.cancel))
                }
            ),
            rightAction: .init(
                title: "초기화할래요",
                variation: .destructive,
                action: {
                    store.send(.popup(.reset))
                }
            )
        )
    }
}

// MARK: - AttributedString
extension ResetDataView {
    
    private var resetDataString: AttributedString {
        .build(
            (
                "초기화 작업 실행 시 그룹 및 블럭 정보가 저장된\n",
                DesignSystem.Colors.gray800.swiftUIColor,
                DesignSystemFontFamily.Pretendard.medium.swiftUIFont(size: 16)
            ),
            (
                "모든 트래킹 데이터가 삭제",
                DesignSystem.Colors.eventDestructive.swiftUIColor,
                DesignSystemFontFamily.Pretendard.semiBold.swiftUIFont(size: 16)
            ),
            (
                "됩니다.",
                DesignSystem.Colors.gray800.swiftUIColor,
                DesignSystemFontFamily.Pretendard.medium.swiftUIFont(size: 16)
            )
        )
    }
}
