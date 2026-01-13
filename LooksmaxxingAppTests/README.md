# LooksmaxxingApp Tests

## Test Coverage

### Unit Tests

| File | Tests | Coverage |
|------|-------|----------|
| `FaceAnalysisResultTests.swift` | Model initialization, formatting, codable | FaceAnalysisResult model |
| `UserDefaultsExtensionsTests.swift` | All UserDefaults properties, scan limits | UserDefaults+Extensions |
| `AppErrorTests.swift` | All error cases, descriptions, retryability | AppError enum |
| `StreakViewModelTests.swift` | Streak logic, freeze mechanics, reset | StreakViewModel |
| `SubscriptionViewModelTests.swift` | Purchase flow, status, streak freeze | SubscriptionViewModel |
| `ScanViewModelTests.swift` | Capture flow, processing state, reset | ScanViewModel |
| `CoreMLServiceTests.swift` | Rating bounds, processing time, face detection | CoreMLService |

### Integration Tests

| File | Tests |
|------|-------|
| `IntegrationTests.swift` | End-to-end flows, component interactions |

## Running Tests

### In Xcode

1. Open `LooksmaxxingApp.xcodeproj`
2. Press `Cmd + U` to run all tests
3. Or go to Product → Test

### Command Line

```bash
xcodebuild test \
  -project LooksmaxxingApp.xcodeproj \
  -scheme LooksmaxxingApp \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Test Categories

### 1. Model Tests
- `FaceAnalysisResult` struct validation
- Codable conformance
- Computed properties

### 2. ViewModel Tests
- `StreakViewModel`: Streak increment/reset, freeze application
- `SubscriptionViewModel`: Purchase simulation, status tracking
- `ScanViewModel`: Capture flow, state management

### 3. Service Tests
- `CoreMLService`: Face detection, rating calculation
- Note: Full Vision tests require real face images

### 4. Extension Tests
- `UserDefaults+Extensions`: All properties and helpers

### 5. Error Handling Tests
- All `AppError` cases
- Error descriptions and recovery suggestions
- Retryability logic

### 6. Integration Tests
- Onboarding → Home flow
- Free vs Pro scan limits
- Streak + Daily task completion
- Purchase → Unlock flow

## Known Limitations

1. **CoreMLService Tests**: Vision framework requires real face images for full coverage. Synthetic images may not trigger face detection.

2. **Singleton ViewModels**: `StreakViewModel` and `SubscriptionViewModel` are singletons, which limits test isolation. Tests save/restore state.

3. **Async Tests**: Some tests use `async/await` and may have timing dependencies.

## Adding New Tests

1. Create new test file in `LooksmaxxingAppTests/`
2. Import: `@testable import LooksmaxxingApp`
3. Use `XCTestCase` subclass
4. Name tests: `test[MethodName]_[Condition]`

## Test Naming Convention

```
test[Component]_[Behavior]_[ExpectedResult]
```

Examples:
- `testStreakReset_SetsCountToZero`
- `testPurchaseSubscription_UpdatesProStatus`
- `testCanScanToday_FreeUser_RecentScan_ReturnsFalse`
