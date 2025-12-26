import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Editor",
    targets: [
        .target(
            name: "Editor",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.thinkyside.DayBlock.Editor",
            buildableFolders: ["Sources"],
            dependencies: [
                .TCA,
                .project(target: "DesignSystem", path: "../../Core/DesignSystem"),
                .project(target: "Domain", path: "../../Core/Domain"),
                .project(target: "PersistentData", path: "../../Core/Data"),
                .project(target: "Util", path: "../../Shared")
            ],
            settings: .shared
        )
    ]
)
