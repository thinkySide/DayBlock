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
                ]
            ),
            buildableFolders: [
                "Sources",
                "Resources"
            ],
            dependencies: [
                .project(target: "DesignSystem", path: "../Core/DesignSystem"),
                .project(target: "Tracking", path: "../Feature/Tracking")
            ],
            settings: .shared
        )
    ]
)
