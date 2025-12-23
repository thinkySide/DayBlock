import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Block",
    targets: [
        .target(
            name: "Block",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.thinkyside.DayBlock.Block",
            buildableFolders: ["Sources"],
            dependencies: [
                .TCA,
                .project(target: "DesignSystem", path: "../../Core/DesignSystem"),
                .project(target: "Domain", path: "../../Core/Domain")
            ],
            settings: .shared
        )
    ]
)
