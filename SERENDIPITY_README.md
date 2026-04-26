# Initiated Serendipity - Implementation Guide

## Overview

The Initiated Serendipity feature allows users to broadcast their availability to nearby second-degree connections in a privacy-respecting way. This implementation replaces the "Close Friends" section with a dynamic, location-based availability system.

## Architecture

### Components

1. **OpenComposerSheet** (`mutualism/Components/OpenComposerSheet.swift`)
   - Bottom sheet modal for configuring availability broadcasts
   - Includes 5 configuration sections: Destination, Time Frame, Notes, Radius, Visibility

2. **OpenStatusChip** (`mutualism/Components/OpenStatusChip.swift`)
   - Compact status indicator showing active broadcast
   - Live countdown timer
   - Quick actions: Edit, End Early

3. **SerendipityViewModel** (`mutualism/ViewModels/SerendipityViewModel.swift`)
   - Manages broadcast state and UI interactions
   - Handles validation and API communication
   - Countdown timer management

### Services

1. **SerendipityService** (`mutualism/Services/SerendipityService.swift`)
   - Mocked API implementation for all broadcast operations
   - Endpoints:
     - `GET /graph/second-degree` - Find nearby users
     - `POST /open/begin` - Start broadcast
     - `POST /open/end` - End broadcast
     - `GET /open/status` - Check current status
     - `POST /notify` - Send notifications

2. **TelemetryService** (`mutualism/Services/TelemetryService.swift`)
   - Non-PII event tracking
   - Debug logging in development mode
   - Ready for production analytics integration

### Models

**SerendipityModels.swift** defines:
- `OpenBroadcast` - Active broadcast data
- `Destination` - Location with privacy controls
- `FuzzyLocation` - Privacy-preserving coordinates
- `RecipientEstimate` - Nearby user count
- `OpenStatus` - User's current availability state

## Configuration Knobs

All configuration is centralized in `SerendipityConfiguration` (SerendipityModels.swift):

```swift
struct SerendipityConfiguration {
    static let minRadiusKm: Double = 0.5        // Minimum search radius
    static let maxRadiusKm: Double = 5.0        // Maximum search radius
    static let defaultRadiusKm: Double = 2.0    // Default radius on open
    static let maxNotesLength: Int = 140        // Character limit for notes
    static let cooldownMinutes: Int = 30        // Cooldown between broadcasts
    static let maxDurationMinutes: Int = 180    // Maximum broadcast duration (3 hours)
    static let maxStartTimeHours: Int = 3       // Maximum schedule-ahead time
    static let durationPresets: [Int] = [30, 60, 90, 120, 180] // Quick-select durations
}
```

### Adjusting Configuration

To modify behavior:

1. **Change cooldown period:**
   ```swift
   static let cooldownMinutes: Int = 60  // 1 hour instead of 30 minutes
   ```

2. **Adjust radius limits:**
   ```swift
   static let minRadiusKm: Double = 1.0  // Increase minimum
   static let maxRadiusKm: Double = 10.0 // Increase maximum
   ```

3. **Modify duration presets:**
   ```swift
   static let durationPresets: [Int] = [15, 30, 60, 120]  // Add 15min option
   ```

## Privacy & Security Features

### Location Privacy
- **Fuzzy Location**: Broadcasts never send exact coordinates
- **Rounded Distance**: Distances shown as 0.1-0.5 km increments
- **Venue Name Only**: Optional checkbox to hide precise location
- **No Raw Coordinates**: All location data is fuzzed by 20% of radius

### Rate Limiting
- **Cooldown**: 30-minute cooldown between broadcasts (configurable)
- **Per-recipient Limit**: ≤1 notification per sender per 24 hours
- **Automatic Expiration**: Broadcasts auto-expire at end of time window

### User Controls
- Users can opt out globally
- Block/mute lists respected
- "No thanks" dismissal tracked
- End broadcast early at any time

## User Flow

### 1. Opening Composer
- Tap "Are You Open?" button
- System checks cooldown status
- Bottom sheet slides up with configuration options

### 2. Configuration
- **Destination**: Search or select recent place, optional venue name sharing
- **Time Frame**: Choose duration (30-180 min) and start time (now or scheduled)
- **Notes**: Optional 140-char message (e.g., "coffee + walk near Mission?")
- **Radius**: Slider 0.5-5 km with estimated recipient count
- **Visibility**: Info about privacy and who receives notification

### 3. Broadcast
- Validation runs (destination + time frame required)
- "Broadcast Open" button enabled when valid
- API call sends broadcast
- Success feedback: haptic + toast message
- Status chip appears on home screen

### 4. Active Broadcast
- Compact chip shows "Open · MM:SS" countdown
- Quick actions: Edit (reopens composer), End Early (stops broadcast)
- Auto-expires when time runs out
- Toast notification on expiration

### 5. Cooldown
- After broadcast ends, 30-minute cooldown begins
- Attempting to broadcast during cooldown shows alert
- Alert displays time when next broadcast is allowed

## Edge Cases Handled

### Location Permission Denied
- Fallback to city-level selection
- Disable radius options < 1 km
- Show appropriate error message

### Offline Mode
- Queue broadcast for when connection restored
- Show "Will send when back online" message
- Server reconciliation on reconnect

### App Killed/Backgrounded
- Server timer continues running
- UI resyncs broadcast state on resume
- Countdown timer restarts from server time

### Zero Recipients
- Show zero-state message
- Allow sending anyway with informative copy
- Post status for friends who come nearby later

### Validation Errors
- Inline validation shows specific issues
- Destination required
- Notes ≤140 characters
- Time frame ≤180 min and start ≤3h from now
- Haptic error feedback

## Telemetry Events

All events are non-PII and logged via `TelemetryService`:

| Event | When Fired | Metadata |
|-------|-----------|----------|
| `open_sheet_opened` | Composer opened | - |
| `open_broadcast_sent` | Broadcast created | `broadcast_id`, `duration_minutes`, `radius_km` |
| `recipients_estimated` | Recipient count updated | `count`, `radius_km` |
| `delivered_count` | Notifications delivered | `broadcast_id`, `count` |
| `viewed_notification` | Recipient views notification | `notification_id` |
| `tap_through` | Recipient taps notification | `notification_id`, `broadcast_id` |
| `end_early` | Broadcast ended manually | `broadcast_id`, `ended_early: true/false` |
| `cooldown_blocked` | User attempts broadcast during cooldown | `cooldown_until` |
| `zero_recipients` | Broadcast sent with 0 recipients | `broadcast_id` |
| `validation_error` | Validation fails | `message` |

### Integrating Production Analytics

Replace mock implementation in `TelemetryService.swift`:

```swift
func log(event: TelemetryEvent, metadata: [String: Any] = [:]) {
    // Example: Mixpanel
    Mixpanel.mainInstance().track(event: event.rawValue, properties: metadata)
    
    // Example: Firebase Analytics
    Analytics.logEvent(event.rawValue, parameters: metadata)
    
    // Example: Amplitude
    Amplitude.instance().logEvent(event.rawValue, withEventProperties: metadata)
}
```

## API Integration

### Converting Mocks to Production

Replace `SerendipityService.swift` mock methods with real HTTP calls:

```swift
func beginOpenBroadcast(request: BeginOpenRequest) async throws -> OpenBroadcast {
    let url = URL(string: "\(apiBaseURL)/open/begin")!
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "POST"
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let encoder = JSONEncoder()
    urlRequest.httpBody = try encoder.encode(request)
    
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    
    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
        throw SerendipityError.networkError
    }
    
    let decoder = JSONDecoder()
    return try decoder.decode(OpenBroadcast.self, from: data)
}
```

### Backend Requirements

Your backend should implement:

1. **Second-degree graph queries**
   - Spatial indexing for efficient nearby user lookups
   - Graph traversal for second-degree connections
   - Privacy filtering (blocks, mutes, opt-outs)

2. **Broadcast storage**
   - Active broadcasts table with expiration
   - Indexed by user_id and expiration timestamp
   - Cleanup job for expired broadcasts

3. **Notification delivery**
   - Push notification service integration (APNs, FCM)
   - Rate limiting per recipient
   - Delivery tracking for analytics

4. **Cooldown management**
   - User cooldown state storage
   - Automatic cooldown expiration
   - Validation on broadcast creation

## Localization (i18n)

All user-facing strings are in `SerendipityStrings.swift`. To add localization:

1. Create string catalogs for each language
2. Replace static strings with localized keys:
   ```swift
   Text(String(localized: "serendipity.destination", bundle: .main))
   ```
3. Update `SerendipityStrings` to use `LocalizedStringKey`

## Testing

### Unit Tests (Recommended)

```swift
func testBroadcastCreation() async throws {
    let service = SerendipityService.shared
    let viewModel = SerendipityViewModel(service: service)
    
    viewModel.selectedDestination = RecentPlace(name: "Test", location: CLLocationCoordinate2D())
    viewModel.selectedDurationMinutes = 60
    
    await viewModel.broadcastOpen()
    
    XCTAssertTrue(viewModel.isActive)
    XCTAssertNotNil(viewModel.activeBroadcast)
}

func testCooldownPreventsRebroadcast() async throws {
    let service = SerendipityService.shared
    let viewModel = SerendipityViewModel(service: service)
    
    // First broadcast
    viewModel.selectedDestination = RecentPlace(name: "Test", location: CLLocationCoordinate2D())
    await viewModel.broadcastOpen()
    
    // End it
    await viewModel.endBroadcast()
    
    // Try to broadcast again
    viewModel.openComposer()
    
    XCTAssertTrue(viewModel.showError)
    XCTAssertNotNil(viewModel.cooldownUntil)
}
```

### UI Tests

Test the complete flow in `mutualismUITests`:

```swift
func testOpenBroadcastFlow() {
    let app = XCUIApplication()
    app.launch()
    
    // Tap "Are You Open?"
    app.buttons["are you open?"].tap()
    
    // Select destination
    app.buttons["Dolores Park"].tap()
    
    // Select duration
    app.buttons["60m"].tap()
    
    // Add notes
    app.textFields["Notes"].tap()
    app.typeText("Coffee in the park")
    
    // Broadcast
    app.buttons["Broadcast Open"].tap()
    
    // Verify status chip appears
    XCTAssertTrue(app.staticTexts["Open"].exists)
}
```

## Performance Considerations

### Optimization Tips

1. **Debounce recipient estimates**: Already implemented with 300ms debounce
2. **Cache recent places**: Store in UserDefaults or Core Data
3. **Background timer**: Use `BackgroundTask` API for countdown when backgrounded
4. **Lazy loading**: Load broadcast history on demand
5. **Image optimization**: Use SF Symbols (already implemented)

### Memory Management

- ViewModels use `@ObservedObject` for automatic cleanup
- Timers are properly invalidated in `stopCountdown()`
- Combine publishers stored in `cancellables` set for automatic disposal

## Future Enhancements

### Potential Features
- [ ] Map view showing approximate broadcast area
- [ ] Rich notifications with accept/decline actions
- [ ] Broadcast history view
- [ ] Recurring availability schedules
- [ ] Group broadcasts (send to multiple friend circles)
- [ ] Activity-based broadcasts (lunch, workout, study, etc.)
- [ ] Response tracking (who's interested)
- [ ] Direct messaging from broadcast responses

### API Additions Needed
- [ ] GET /open/history - Past broadcasts
- [ ] POST /open/respond - Respond to someone's broadcast
- [ ] GET /open/responses - See who responded to yours
- [ ] PATCH /open/:id - Edit active broadcast

## Troubleshooting

### Common Issues

**Composer doesn't open**
- Check cooldown status
- Verify `showComposer` binding
- Check console for validation errors

**Countdown not updating**
- Ensure `startCountdown()` is called after broadcast
- Verify timer is on main thread
- Check `expiresAt` timestamp is future

**Recipient count always zero**
- Mock service returns random count based on radius
- In production, check graph query performance
- Verify location permissions granted

**Push notifications not received**
- Mock service only logs events
- Integrate real push notification service
- Check device notification settings

## Support & Feedback

For questions or issues with this implementation, please contact the development team or file an issue in the project repository.

---

**Last Updated:** October 5, 2025  
**Version:** 1.0  
**Author:** Claude (Anthropic)

