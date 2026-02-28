//
//  DeveloperInfoView.swift
//  MyInfo
//
//  Created by 김민준 on 2/28/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct DeveloperInfoView: View {
    
    private var store: StoreOf<DeveloperInfoFeature>

    public init(store: StoreOf<DeveloperInfoFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            DesignSystem.Icons.app.swiftUIImage
                .padding(.top, 16)
            
            Text("한톨")
                .brandFont(.pretendard(.bold), 26)
                .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                .padding(.top, 16)
            
            Text("Minjoon Kim")
                .brandFont(.poppins(.bold), 16)
                .foregroundStyle(DesignSystem.Colors.gray800.swiftUIColor)
            
            DashedDivider()
                .padding(.top, 32)
                .padding(.horizontal, 40)
            
            LinkList()
                .padding(.top, 32)
                .padding(.horizontal, 40)
            
            DashedDivider()
                .padding(.top, 32)
                .padding(.horizontal, 40)
            
            Text(
                """
                우리 모두는 하루를 다양한 시간으로 채워가고 있어요. 그중 기록하고 싶은 시간들을 블럭으로 만들고 쌓아가다 보면 노력과 열정의 흔적을 데이블럭에서 확인할 수 있을 거에요.
                """
            )
            .brandFont(.pretendard(.semiBold), 14)
            .foregroundStyle(DesignSystem.Colors.gray800.swiftUIColor)
            .padding(.top, 32)
            .padding(.horizontal, 40)
            .lineSpacing(4)
            
            Spacer()
        }
        .background(DesignSystem.Colors.gray0.swiftUIColor)
        .navigationTitle("개발자 정보")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func LinkList() -> some View {
        VStack(spacing: 24) {
            LinkCell(
                title: "Github",
                subtitle: "잡다한 개발 프로젝트 둘러보기",
                linkString: "https://github.com/thinkySide"
            )
            
            LinkCell(
                title: "Blog",
                subtitle: "솔직 담백하게 개발 이야기 풀어내기",
                linkString: "https://thinkyside.tistory.com/"
            )
            
            LinkCell(
                title: "Instagram",
                subtitle: "개발자 한톨의 다양한 소식 듣기",
                linkString: "https://www.instagram.com/thinkydev?igsh=MWV1cDl4ZWU2b2p0bQ%3D%3D&utm_source=qr"
            )
            
            LinkCell(
                title: "LinkedIn",
                subtitle: "커리어 구경하기",
                linkString: "https://www.linkedin.com/in/minjoon-kim-3756a91a7?utm_source=share_via&utm_content=profile&utm_medium=member_ios"
            )
        }
    }
    
    @ViewBuilder
    private func LinkCell(
        title: String,
        subtitle: String,
        linkString: String
    ) -> some View {
        HStack {
            Text(title)
                .brandFont(.pretendard(.semiBold), 13)
                .foregroundStyle(DesignSystem.Colors.gray800.swiftUIColor)
            
            Spacer(minLength: 16)
            
            if let url = URL(string: linkString), UIApplication.shared.canOpenURL(url) {
                Link(destination: URL(string: linkString)!) {
                    Text(subtitle)
                        .brandFont(.pretendard(.bold), 14)
                        .foregroundStyle(DesignSystem.Colors.eventLink.swiftUIColor)
                        .lineLimit(1)
                }
            }
        }
    }
}
