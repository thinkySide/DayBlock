import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Data",
    targets: [
        .target(
            name: "PersistentData",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.thinkyside.DayBlock.PersistentData",
            buildableFolders: ["Sources/PersistentData"],
            dependencies: [
                .project(target: "Domain", path: "../Domain"),
                .project(target: "Util", path: "../../Shared"),
                .TCA
            ],
            settings: .shared
        ),
        .target(
            name: "UserDefaults",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.thinkyside.DayBlock.UserDefaults",
            buildableFolders: ["Sources/UserDefaults"],
            dependencies: [
                .project(target: "Domain", path: "../Domain"),
                .project(target: "Util", path: "../../Shared"),
                .TCA
            ],
            settings: .shared
        )
    ]
)
