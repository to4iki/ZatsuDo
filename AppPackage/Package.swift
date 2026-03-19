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
    .package(path: "../AppLibrary")
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
      path: "./Sources/Feature/Task",
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
      ]
    ),

    // -- Core Layer ---
    .target(
      name: "AppStorage",
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
      dependencies: ["AppFeature", "AppStorage"],
      path: "./Tests/Feature/App"
    ),
    .testTarget(
      name: "OnboardingFeatureTests",
      dependencies: ["OnboardingFeature"],
      path: "./Tests/Feature/Onboarding"
    ),
    .testTarget(
      name: "SettingFeatureTests",
      dependencies: ["SettingFeature", "AppStorage"],
      path: "./Tests/Feature/Setting"
    ),
  ]
)
