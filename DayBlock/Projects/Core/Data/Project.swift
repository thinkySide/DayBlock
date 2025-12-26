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
            settings: .shared
        )
    ]
)
