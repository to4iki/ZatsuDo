// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "AppPackage",
  defaultLocalization: "en",
  platforms: [.iOS(.v26)],
  products: [
    .library(
      name: "AppFeature",
      targets: ["AppFeature"]
    )
  ],
  dependencies: [
    .package(path: "../AppLibrary"),
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.9.0"),
  ],
  targets: [
    // -- Feature Layer --
    .target(
      name: "AppFeature",
      dependencies: [
        "TaskFeature",
        "SettingFeature",
        "OnboardingFeature",
        "AppStorage",
      ],
      path: "./Sources/Feature/App"
    ),
    .target(
      name: "TaskFeature",
      dependencies: [
        "FeatureCommon",
        "SharedModel",
      ],
      path: "./Sources/Feature/Task"
    ),
    .target(
      name: "SettingFeature",
      dependencies: [
        "AppStorage"
      ],
      path: "./Sources/Feature/Setting"
    ),
    .target(
      name: "OnboardingFeature",
      path: "./Sources/Feature/Onboarding"
    ),
    .target(
      name: "FeatureCommon",
      dependencies: [
        .product(name: "Logger", package: "AppLibrary")
      ],
      path: "./Sources/FeatureCommon"
    ),

    // -- Core Layer ---
    .target(
      name: "AppStorage",
      dependencies: [
        .product(name: "Dependencies", package: "swift-dependencies"),
        .product(name: "DependenciesMacros", package: "swift-dependencies"),
        .product(name: "Logger", package: "AppLibrary"),
      ],
      path: "./Sources/Core/AppStorage"
    ),
    .target(
      name: "SharedModel",
      dependencies: [
        .product(name: "UtilType", package: "AppLibrary")
      ],
      path: "./Sources/Core/SharedModel"
    ),

    // -- Test --
    .testTarget(
      name: "AppFeatureTests",
      dependencies: [
        "AppFeature",
        .product(name: "Dependencies", package: "swift-dependencies"),
      ],
      path: "./Tests/Feature/App"
    ),
    .testTarget(
      name: "OnboardingFeatureTests",
      dependencies: ["OnboardingFeature"],
      path: "./Tests/Feature/Onboarding"
    ),
    .testTarget(
      name: "SettingFeatureTests",
      dependencies: [
        "SettingFeature",
        .product(name: "Dependencies", package: "swift-dependencies"),
      ],
      path: "./Tests/Feature/Setting"
    ),
    .testTarget(
      name: "TaskFeatureTests",
      dependencies: ["TaskFeature"],
      path: "./Tests/Feature/Task"
    ),
  ]
)
