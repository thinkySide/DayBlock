import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "App",
    targets: [
        .target(
            name: "App",
            destinations: .iOS,
            product: .app,
            bundleId: "com.thinkyside.DayBlock",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "CFBundleDisplayName": "DayBlock",
                    "CFBundleShortVersionString": "1.0.0",
                    "CFBundleVersion": "1",
                ]
            ),
            buildableFolders: [
                "Sources",
                "Resources"
            ],
            dependencies: [
                .TCA,
                .project(target: "DesignSystem", path: "../Core/DesignSystem"),
                .project(target: "Tracking", path: "../Feature/Tracking"),
                .project(target: "Management", path: "../Feature/Management"),
                .project(target: "Calendar", path: "../Feature/Calendar"),
                .project(target: "MyInfo", path: "../Feature/MyInfo")
            ],
            settings: .shared
        )
    ]
)
