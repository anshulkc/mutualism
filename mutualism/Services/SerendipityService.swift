//
//  SerendipityService.swift
//  mutualism
//
//  Service layer for Initiated Serendipity with mocked APIs
//

import Foundation
import CoreLocation

// MARK: - Service Protocol

protocol SerendipityServiceProtocol {
    func getSecondDegreeUsers(userId: String, location: CLLocationCoordinate2D, radiusKm: Double) async throws -> RecipientEstimate
    func beginOpenBroadcast(request: BeginOpenRequest) async throws -> OpenBroadcast
    func endOpenBroadcast(broadcastId: String) async throws
    func getOpenStatus(userId: String) async throws -> OpenStatus
    func sendNotification(notification: OpenNotification, toUserId: String) async throws
}

// MARK: - Request Models

struct BeginOpenRequest {
    let userId: String
    let destination: Destination
    let radiusKm: Double
    let durationMinutes: Int
    let notes: String?
    let startTime: Date
}

// MARK: - Service Implementation (Mocked)

class SerendipityService: SerendipityServiceProtocol, ObservableObject {
    
    // Singleton for easy access
    static let shared = SerendipityService()
    
    // In-memory storage for mocked data
    private var activeBroadcasts: [String: OpenBroadcast] = [:]
    private var userStatuses: [String: OpenStatus] = [:]
    
    private init() {}
    
    // MARK: - API Methods
    
    func getSecondDegreeUsers(userId: String, location: CLLocationCoordinate2D, radiusKm: Double) async throws -> RecipientEstimate {
        // Mock: Simulate network delay
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3s
        
        // Mock: Generate random count based on radius
        let baseCount = Int(radiusKm * 3)
        let variance = Int.random(in: -2...5)
        let count = max(0, baseCount + variance)
        
        // Mock: Generate fake user IDs
        let userIds = (0..<count).map { "user_\(userId)_\($0)" }
        
        return RecipientEstimate(count: count, withinRadius: userIds)
    }
    
    func beginOpenBroadcast(request: BeginOpenRequest) async throws -> OpenBroadcast {
        // Mock: Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5s
        
        // Check cooldown
        if let status = userStatuses[request.userId],
           let cooldownUntil = status.cooldownUntil,
           cooldownUntil > Date() {
            throw SerendipityError.cooldownActive(until: cooldownUntil)
        }
        
        // Create broadcast
        let broadcastId = "broadcast_\(UUID().uuidString.prefix(8))"
        let expiresAt = request.startTime.addingTimeInterval(TimeInterval(request.durationMinutes * 60))
        
        let broadcast = OpenBroadcast(
            id: broadcastId,
            userId: request.userId,
            destination: request.destination,
            radiusKm: request.radiusKm,
            durationMinutes: request.durationMinutes,
            notes: request.notes,
            startTime: request.startTime,
            expiresAt: expiresAt,
            status: .active
        )
        
        // Store broadcast
        activeBroadcasts[broadcastId] = broadcast
        
        // Update user status
        userStatuses[request.userId] = OpenStatus(
            active: true,
            broadcastId: broadcastId,
            expiresAt: expiresAt,
            cooldownUntil: nil
        )
        
        // Log telemetry
        TelemetryService.shared.log(event: .openBroadcastSent, metadata: [
            "broadcast_id": broadcastId,
            "duration_minutes": request.durationMinutes,
            "radius_km": request.radiusKm
        ])
        
        return broadcast
    }
    
    func endOpenBroadcast(broadcastId: String) async throws {
        // Mock: Simulate network delay
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2s
        
        guard let broadcast = activeBroadcasts[broadcastId] else {
            throw SerendipityError.broadcastNotFound
        }

        // Update broadcast status
        let updatedBroadcast = OpenBroadcast(
            id: broadcast.id,
            userId: broadcast.userId,
            destination: broadcast.destination,
            radiusKm: broadcast.radiusKm,
            durationMinutes: broadcast.durationMinutes,
            notes: broadcast.notes,
            startTime: broadcast.startTime,
            expiresAt: broadcast.expiresAt,
            status: .ended
        )
        activeBroadcasts[broadcastId] = updatedBroadcast
        
        // Set cooldown
        let cooldownUntil = Date().addingTimeInterval(TimeInterval(SerendipityConfiguration.cooldownMinutes * 60))
        userStatuses[broadcast.userId] = OpenStatus(
            active: false,
            broadcastId: nil,
            expiresAt: nil,
            cooldownUntil: cooldownUntil
        )
        
        // Log telemetry
        TelemetryService.shared.log(event: .openBroadcastEnded, metadata: [
            "broadcast_id": broadcastId,
            "ended_early": true
        ])
    }
    
    func getOpenStatus(userId: String) async throws -> OpenStatus {
        // Mock: Simulate network delay
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1s
        
        // Check if there's an existing status
        if let status = userStatuses[userId] {
            // Check if broadcast has expired
            if let expiresAt = status.expiresAt, expiresAt < Date() {
                // Auto-expire
                if let broadcastId = status.broadcastId {
                    try? await endOpenBroadcast(broadcastId: broadcastId)
                }
                return OpenStatus(active: false, broadcastId: nil, expiresAt: nil, cooldownUntil: status.cooldownUntil)
            }
            return status
        }
        
        return OpenStatus(active: false, broadcastId: nil, expiresAt: nil, cooldownUntil: nil)
    }
    
    func sendNotification(notification: OpenNotification, toUserId: String) async throws {
        // Mock: Simulate push notification
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1s
        
        // Log telemetry
        TelemetryService.shared.log(event: .notificationSent, metadata: [
            "notification_id": notification.id,
            "to_user": toUserId,
            "type": notification.type
        ])
    }
}

// MARK: - Errors

enum SerendipityError: LocalizedError {
    case cooldownActive(until: Date)
    case broadcastNotFound
    case invalidTimeFrame
    case invalidLocation
    case networkError
    case noEligibleRecipients
    
    var errorDescription: String? {
        switch self {
        case .cooldownActive(let date):
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return "You can broadcast again at \(formatter.string(from: date))"
        case .broadcastNotFound:
            return "Broadcast not found"
        case .invalidTimeFrame:
            return "Time frame must be ≤180 minutes and start ≤3 hours from now"
        case .invalidLocation:
            return "Please select a valid destination"
        case .networkError:
            return "Network error. Please try again."
        case .noEligibleRecipients:
            return "No eligible recipients found"
        }
    }
}

