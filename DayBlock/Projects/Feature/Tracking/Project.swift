import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Tracking",
    targets: [
        .target(
            name: "Tracking",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.thinkyside.DayBlock.Tracking",
            buildableFolders: ["Sources"],
            dependencies: [
                .TCA,
                .project(target: "DesignSystem", path: "../../Core/DesignSystem"),
                .project(target: "Domain", path: "../../Core/Domain"),
                .project(target: "PersistentData", path: "../../Core/Data"),
                .project(target: "Util", path: "../../Shared"),
                .project(target: "Editor", path: "../Editor")
            ],
            settings: .shared
        ),
        .target(
            name: "TrackingDemoApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.thinkyside.DayBlock.TrackingDemoApp",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "CFBundleDisplayName": "🛠️Tracking",
                ]
            ),
            buildableFolders: ["Demo"],
            dependencies: [
                .target(name: "Tracking")
            ],
            settings: .shared
        )
    ]
)
