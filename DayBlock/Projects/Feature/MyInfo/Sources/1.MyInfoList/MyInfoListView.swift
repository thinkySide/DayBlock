//
//  MyInfoListView.swift
//  MyInfo
//
//  Created by 김민준 on 2/14/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct MyInfoListView: View {
    
    @Bindable private var store: StoreOf<MyInfoListFeature>

    public init(store: StoreOf<MyInfoListFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ContentView()
        } destination: { store in
            switch store.case {
            case let .resetData(store): ResetDataView(store: store)
            case let .developerInfo(store): DeveloperInfoView(store: store)
            }
        }
    }
    
    @ViewBuilder
    private func ContentView() -> some View {
        ScrollView {
            VStack(spacing: 0) {
                Header()
                
                SectionDivider()
                    .padding(.top, 24)
                
                HelpSection()
                    .padding(.top, 20)
                
                SectionDivider()
                    .padding(.top, 20)
                
                CommunitySection()
                    .padding(.top, 20)
                
                SectionDivider()
                    .padding(.top, 20)
                
                DevelopmentSection()
                    .padding(.top, 20)
                
                Spacer()
            }
            .background(DesignSystem.Colors.gray0.swiftUIColor)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarVisibility(.visible, for: .navigationBar)
            .onAppear {
                store.send(.view(.onAppear))
            }
        }
    }
    
    @ViewBuilder
    private func Header() -> some View {
        VStack(spacing: 20) {
            Text("생산한 블럭을\n차곡차곡 쌓아뒀어요")
                .brandFont(.pretendard(.bold), 20)
                .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 24) {
                HeaderInfoCell(
                    title: "total",
                    value: store.totalOutput,
                    symbolName: Symbol.batteryblock_fill.symbolName,
                    color: DesignSystem.ColorPalette.blueBlock4.swiftUIColor
                )

                HeaderInfoCell(
                    title: "today",
                    value: store.todayOutput,
                    symbolName: Symbol.gauge_with_needle_fill.symbolName,
                    color: DesignSystem.ColorPalette.greenBlock4.swiftUIColor
                )

                HeaderInfoCell(
                    title: "streaks",
                    value: Double(store.streaks),
                    symbolName: Symbol.flame_fill.symbolName,
                    color: DesignSystem.ColorPalette.redBlock5.swiftUIColor
                )
            }
        }
    }
    
    @ViewBuilder
    private func HeaderInfoCell(
        title: String,
        value: Double,
        symbolName: String,
        color: Color
    ) -> some View {
        VStack(spacing: 0) {
            Circle()
                .frame(width: 24, height: 24)
                .foregroundStyle(color.opacity(0.3))
                .overlay {
                    SFSymbol(
                        symbol: symbolName,
                        size: 12,
                        color: color
                    )
                }
            
            Text(value.toValueString())
                .brandFont(.poppins(.semiBold), 16)
                .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                .padding(.top, 3)
            
            Text(title)
                .brandFont(.poppins(.semiBold), 16)
                .foregroundStyle(DesignSystem.Colors.gray400.swiftUIColor)
        }
        .frame(width: 64)
    }
    
    @ViewBuilder
    private func HelpSection() -> some View {
        VStack(spacing: 0) {
            MyInfoListCell(
                title: "사용 방법 가이드",
                onTap: { }
            )
            
            MyInfoListCell(
                title: "데이터 초기화",
                onTap: { store.send(.view(.onTapResetDataCell)) }
            )
        }
    }
    
    @ViewBuilder
    private func CommunitySection() -> some View {
        VStack(spacing: 0) {
            MyInfoListCell(
                title: "앱스토어 리뷰 작성",
                onTap: { store.send(.view(.onTapAppStoreReviewCell)) }
            )
            
            MyInfoListCell(
                title: "기능 요청 및 개선사항 제안",
                onTap: { store.send(.view(.onTapInquiryCell)) }
            )
            
            MyInfoListCell(
                title: "데이블럭 오픈채팅",
                onTap: { store.send(.view(.onTapOpenChatCell)) }
            )
        }
    }
    
    @ViewBuilder
    private func DevelopmentSection() -> some View {
        VStack(spacing: 0) {
            MyInfoListCell(
                title: "개발자 정보",
                onTap: { store.send(.view(.onTapDeveloperInfoCell)) }
            )
            
            HStack {
                Text("앱 버전")
                    .brandFont(.pretendard(.semiBold), 16)
                    .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                
                Spacer()
                
                Text(store.appVersion)
                    .brandFont(.poppins(.semiBold), 14)
                    .foregroundStyle(DesignSystem.Colors.gray700.swiftUIColor)
            }
            .padding(.horizontal, 20)
            .frame(height: 56)
        }
    }
    
    @ViewBuilder
    private func MyInfoListCell(
        title: String,
        onTap: @escaping () -> Void
    ) -> some View {
        Button {
            onTap()
        } label: {
            HStack {
                Text(title)
                    .brandFont(.pretendard(.semiBold), 16)
                    .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                
                Spacer()
                
                DesignSystem.Icons.arrowRight.swiftUIImage
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 56)
    }
}
