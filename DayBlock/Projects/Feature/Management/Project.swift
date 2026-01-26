import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Management",
    targets: [
        .target(
            name: "Management",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.thinkyside.DayBlock.Management",
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
            name: "ManagementDemoApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.thinkyside.DayBlock.ManagementDemoApp",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "CFBundleDisplayName": "🛠️Management",
                ]
            ),
            buildableFolders: ["Demo"],
            dependencies: [
                .target(name: "Management")
            ],
            settings: .shared
        )
    ]
)
