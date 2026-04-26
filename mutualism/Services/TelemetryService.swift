//
//  TelemetryService.swift
//  mutualism
//
//  Non-PII telemetry tracking for analytics
//

import Foundation

// MARK: - Telemetry Events

enum TelemetryEvent: String {
    case openSheetOpened = "open_sheet_opened"
    case openBroadcastSent = "open_broadcast_sent"
    case openBroadcastEnded = "open_broadcast_ended"
    case recipientsEstimated = "recipients_estimated"
    case deliveredCount = "delivered_count"
    case viewedNotification = "viewed_notification"
    case tapThrough = "tap_through"
    case endEarly = "end_early"
    case cooldownBlocked = "cooldown_blocked"
    case zeroRecipients = "zero_recipients"
    case validationError = "validation_error"
    case notificationSent = "notification_sent"
}

// MARK: - Telemetry Service

class TelemetryService {
    static let shared = TelemetryService()
    
    private init() {}
    
    func log(event: TelemetryEvent, metadata: [String: Any] = [:]) {
        // Mock implementation - in production, this would send to analytics service
        #if DEBUG
        print("📊 [Telemetry] \(event.rawValue)")
        if !metadata.isEmpty {
            print("   Metadata: \(metadata)")
        }
        #endif
        
        // In production, integrate with analytics SDK:
        // - Mixpanel
        // - Amplitude
        // - Firebase Analytics --> might use supabase instead
        // - Custom backend
    }
    
    func logError(_ error: Error, context: String) {
        #if DEBUG
        print("❌ [Telemetry Error] \(context): \(error.localizedDescription)")
        #endif
        
        // In production, send to error tracking service:
        // - Sentry
        // - Crashlytics
        // - Custom error logging
    }
}

