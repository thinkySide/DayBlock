//
//  DesignSystemConfiguration.swift
//  DesignSystem
//
//  Created by 김민준 on 2/25/26.
//

import UIKit

public enum DesignSystemConfiguration {

    /// DesignSystem 초기 설정을 수행합니다.
    ///
    /// 앱 시작 시 한 번 호출해주세요.
    public static func configure() {
        registerFonts()
        configureNavigationBarAppearance()
        configureTabBarAppearance()
    }

    private static func registerFonts() {
        DesignSystemFontFamily.registerAllCustomFonts()
    }

    private static func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = DesignSystem.Colors.gray0.color
        appearance.shadowColor = .clear

        let titleFont = UIFont(
            name: BrandFont.Pretendard.bold.fontName,
            size: 15
        ) ?? .boldSystemFont(ofSize: 15)

        appearance.titleTextAttributes = [
            .font: titleFont,
            .foregroundColor: DesignSystem.Colors.gray900.color
        ]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }

    private static func configureTabBarAppearance() {
        let gray900 = DesignSystem.Colors.gray900.color

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = DesignSystem.Colors.gray0.color
        appearance.shadowColor = .clear

        let normalAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: gray900]
        let selectedAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: gray900]

        appearance.stackedLayoutAppearance.normal.iconColor = gray900
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
        appearance.stackedLayoutAppearance.selected.iconColor = gray900
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
