# ZatsuDo App
![Swift 6](https://img.shields.io/badge/swift-6-orange.svg)
![iOS 26+](https://img.shields.io/badge/iOS-26%2B-blue.svg)

sample iOS multi-module todo application — quickly capture tasks without overthinking it.

## Architecture

Multi-module SwiftUI app using Unidirectional Data Flow (UDF) via ViewModel + UiState.

```
App/               # Entry point (main target)
AppPackage/        # Main implementation (Swift Package)
  Feature/         # UI layer (TaskFeature, SettingFeature, OnboardingFeature)
  Core/            # Non-UI layer (SharedModel, AppStorage)
  FeatureCommon/   # Shared UI components
AppLibrary/        # Domain-agnostic utilities (Logger, UtilType)
```

## Documentation

- [Setup](./docs/setup.md)
- [Features](./docs/features.md)
- [Architecture](./docs/architecture.md)
- [Logging](./docs/logging.md)

## License

ZatsuDo is released under the MIT license.
