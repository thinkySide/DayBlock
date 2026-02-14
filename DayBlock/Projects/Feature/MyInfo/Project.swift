import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "MyInfo",
    targets: [
        .target(
            name: "MyInfo",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.thinkyside.DayBlock.MyInfo",
            buildableFolders: ["Sources"],
            dependencies: [
                .TCA,
                .project(target: "DesignSystem", path: "../../Core/DesignSystem"),
                .project(target: "Domain", path: "../../Core/Domain"),
                .project(target: "PersistentData", path: "../../Core/Data"),
                .project(target: "UserDefaults", path: "../../Core/Data"),
                .project(target: "Util", path: "../../Shared")
            ],
            settings: .shared
        ),
        .target(
            name: "MyInfoDemoApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.thinkyside.DayBlock.MyInfoDemoApp",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "CFBundleDisplayName": "🛠️MyInfo",
                ]
            ),
            buildableFolders: ["Demo"],
            dependencies: [
                .target(name: "MyInfo")
            ],
            settings: .shared
        )
    ]
)
