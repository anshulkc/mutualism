//
//  SerendipityStrings.swift
//  mutualism
//
//  Localized strings for Initiated Serendipity flow (i18n-ready)
//

import Foundation

struct SerendipityStrings {
    
    // MARK: - Section Titles
    static let destination = "Destination"
    static let timeFrame = "Time Frame"
    static let notes = "Notes"
    static let radius = "Radius"
    static let visibility = "Visibility"
    
    // MARK: - Placeholders
    static let destinationPlaceholder = "Search places or drop a pin..."
    static let notesPlaceholder = "coffee + walk near Mission?"
    
    // MARK: - Buttons
    static let broadcastOpen = "Broadcast Open"
    static let cancel = "Cancel"
    static let endEarly = "End Early"
    static let edit = "Edit"
    static let done = "Done"
    
    // MARK: - Labels
    static let shareVenueNameOnly = "Share venue name only"
    static let startNow = "Start now"
    static let scheduleFor = "Schedule for"
    static let open = "Open"
    static let youreOpen = "You're Open"
    
    // MARK: - Time Presets
    static func minutesLabel(_ minutes: Int) -> String {
        "\(minutes)m"
    }
    
    // MARK: - Helper Text
    static let visibilityHint = "Sends to nearby 2nd-degree only. Exact location is never shared."
    
    static func estimatedRecipients(_ count: Int) -> String {
        switch count {
        case 0:
            return "No recipients nearby"
        case 1:
            return "~1 person nearby"
        default:
            return "~\(count) people nearby"
        }
    }
    
    static func radiusLabel(_ km: Double) -> String {
        String(format: "%.1f km", km)
    }
    
    static func fuzzyDistance(_ km: Double) -> String {
        let rounded = (km * 10).rounded() / 10
        return String(format: "%.1f km away", rounded)
    }
    
    // MARK: - Validation Messages
    static let destinationRequired = "Please select a destination"
    static let timeFrameRequired = "Please select a time frame"
    static let notesTooLong = "Notes must be 140 characters or less"
    static let invalidTimeFrame = "Time frame must be within next 3 hours"
    
    // MARK: - Status Messages
    static let broadcastSent = "Your status is live!"
    static let broadcastEnded = "You're no longer open."
    static let willSendWhenOnline = "Will send when back online"
    static let locationDenied = "Location access denied"
    
    // MARK: - Zero State
    static let zeroRecipientsTitle = "No one nearby right now"
    static let zeroRecipientsMessage = "We'll still post your status for friends who come nearby."
    
    // MARK: - Countdown
    static func timeRemaining(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", minutes, secs)
    }
}

