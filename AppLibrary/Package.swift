// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "AppLibrary",
  defaultLocalization: "en",
  platforms: [.iOS(.v26)],
  products: [
    .library(
      name: "UtilType",
      targets: ["ID"]
    ),
    .library(
      name: "Logger",
      targets: ["Logger"]
    ),
  ],
  targets: [
    .target(name: "ID"),
    .target(name: "Logger"),
  ]
)
