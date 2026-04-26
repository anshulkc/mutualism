//
//  SerendipityModels.swift
//  mutualism
//
//  Models for Initiated Serendipity flow
//

import Foundation
import CoreLocation

// MARK: - Broadcast Models

struct OpenBroadcast: Codable, Identifiable {
    let id: String
    let userId: String
    let destination: Destination
    let radiusKm: Double
    let durationMinutes: Int
    let notes: String?
    let startTime: Date
    let expiresAt: Date
    let status: BroadcastStatus
    
    enum BroadcastStatus: String, Codable {
        case active
        case ended
        case expired
    }
}

struct Destination: Codable, Hashable {
    let name: String
    let fuzzyLocation: FuzzyLocation
    let shareVenueNameOnly: Bool
    
    var displayName: String {
        shareVenueNameOnly ? name : "Near \(name)"
    }
}

struct FuzzyLocation: Codable, Hashable {
    let latitude: Double
    let longitude: Double
    let accuracyRadius: Double // in km
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// MARK: - Recipient Models

struct RecipientEstimate: Codable {
    let count: Int
    let withinRadius: [String] // User IDs
}

struct SecondDegreeUser: Identifiable, Codable {
    let id: String
    let name: String
    let distance: Double // in km
    let mutualContactName: String?
}

// MARK: - Status Models

struct OpenStatus: Codable {
    let active: Bool
    let broadcastId: String?
    let expiresAt: Date?
    let cooldownUntil: Date?
}

// MARK: - Notification Models

struct OpenNotification: Codable {
    let id: String
    let type: String // "open_invite"
    let senderName: String
    let venueName: String?
    let fuzzyDistance: String
    let expiresAt: Date
    let mutualContactName: String?
}

// MARK: - UI State

struct SerendipityConfiguration {
    static let minRadiusKm: Double = 0.5
    static let maxRadiusKm: Double = 5.0
    static let defaultRadiusKm: Double = 2.0
    static let maxNotesLength: Int = 140
    static let cooldownMinutes: Int = 30
    static let maxDurationMinutes: Int = 180
    static let maxStartTimeHours: Int = 3
    
    static let durationPresets: [Int] = [30, 60, 90, 120, 180] // minutes
}

struct RecentPlace: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let location: CLLocationCoordinate2D
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: RecentPlace, rhs: RecentPlace) -> Bool {
        lhs.id == rhs.id
    }
}

