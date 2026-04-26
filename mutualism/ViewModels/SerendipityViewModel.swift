//
//  SerendipityViewModel.swift
//  mutualism
//
//  ViewModel for Initiated Serendipity flow
//

import SwiftUI
import CoreLocation
import Combine

class SerendipityViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var showComposer = false
    @Published var activeBroadcast: OpenBroadcast?
    @Published var isActive = false
    @Published var countdownText = "0:00"
    @Published var cooldownUntil: Date?
    
    // Composer state
    @Published var selectedDestination: RecentPlace?
    @Published var shareVenueNameOnly = true
    @Published var selectedDurationMinutes = 60
    @Published var startNow = true
    @Published var scheduledStartTime = Date()
    @Published var notes = ""
    @Published var radiusKm = SerendipityConfiguration.defaultRadiusKm
    @Published var estimatedRecipients = 0
    
    // UI state
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var searchText = ""
    
    // MARK: - Private Properties
    
    private let service: SerendipityServiceProtocol
    private let userId: String
    private var countdownTimer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    // Mock recent places
    let recentPlaces: [RecentPlace] = [
        RecentPlace(name: "Dolores Park", location: CLLocationCoordinate2D(latitude: 37.7596, longitude: -122.4269)),
        RecentPlace(name: "Mission District", location: CLLocationCoordinate2D(latitude: 37.7599, longitude: -122.4148)),
        RecentPlace(name: "Blue Bottle Coffee", location: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)),
        RecentPlace(name: "Ferry Building", location: CLLocationCoordinate2D(latitude: 37.7956, longitude: -122.3935))
    ]
    
    var filteredPlaces: [RecentPlace] {
        if searchText.isEmpty {
            return recentPlaces
        }
        return recentPlaces.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    // MARK: - Initialization
    
    init(service: SerendipityServiceProtocol = SerendipityService.shared, userId: String = "current_user") {
        self.service = service
        self.userId = userId
        
        setupObservers()
        Task { await loadStatus() }
    }
    
    // MARK: - Setup
    
    private func setupObservers() {
        // Update recipient estimate when radius or destination changes
        Publishers.CombineLatest($radiusKm, $selectedDestination)
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] radius, destination in
                guard let self = self, let destination = destination else { return }
                Task { await self.updateRecipientEstimate(location: destination.location, radius: radius) }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    
    func openComposer() {
        // Check cooldown
        if let cooldownUntil = cooldownUntil, cooldownUntil > Date() {
            errorMessage = SerendipityError.cooldownActive(until: cooldownUntil).localizedDescription
            showError = true
            TelemetryService.shared.log(event: .cooldownBlocked, metadata: ["cooldown_until": cooldownUntil])
            return
        }
        
        TelemetryService.shared.log(event: .openSheetOpened)
        showComposer = true
    }
    
    func broadcastOpen() {
        Task {
            await performBroadcast()
        }
    }
    
    func endBroadcast() {
        guard let broadcast = activeBroadcast else { return }
        
        Task {
            do {
                isLoading = true
                try await service.endOpenBroadcast(broadcastId: broadcast.id)
                
                await MainActor.run {
                    isActive = false
                    activeBroadcast = nil
                    stopCountdown()
                    
                    // Show toast
                    errorMessage = SerendipityStrings.broadcastEnded
                    showError = true
                    
                    isLoading = false
                }
                
                TelemetryService.shared.log(event: .endEarly, metadata: ["broadcast_id": broadcast.id])
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                    isLoading = false
                }
                TelemetryService.shared.logError(error, context: "End broadcast")
            }
        }
    }
    
    func cancelComposer() {
        showComposer = false
        resetComposerState()
    }
    
    // MARK: - Private Methods
    
    private func loadStatus() async {
        do {
            let status = try await service.getOpenStatus(userId: userId)
            
            await MainActor.run {
                isActive = status.active
                cooldownUntil = status.cooldownUntil
                
                if status.active, let _ = status.broadcastId {
                    // Reload active broadcast
                    // In a real app, fetch from service
                }
            }
        } catch {
            TelemetryService.shared.logError(error, context: "Load status")
        }
    }
    
    private func updateRecipientEstimate(location: CLLocationCoordinate2D, radius: Double) async {
        do {
            let estimate = try await service.getSecondDegreeUsers(userId: userId, location: location, radiusKm: radius)
            
            await MainActor.run {
                estimatedRecipients = estimate.count
            }
            
            TelemetryService.shared.log(event: .recipientsEstimated, metadata: [
                "count": estimate.count,
                "radius_km": radius
            ])
        } catch {
            TelemetryService.shared.logError(error, context: "Estimate recipients")
        }
    }
    
    private func performBroadcast() async {
        // Validate
        guard let destination = selectedDestination else {
            await showValidationError(SerendipityStrings.destinationRequired)
            return
        }
        
        if notes.count > SerendipityConfiguration.maxNotesLength {
            await showValidationError(SerendipityStrings.notesTooLong)
            return
        }
        
        let startTime = startNow ? Date() : scheduledStartTime
        
        // Validate time frame
        let hoursFromNow = startTime.timeIntervalSince(Date()) / 3600
        if hoursFromNow > Double(SerendipityConfiguration.maxStartTimeHours) {
            await showValidationError(SerendipityStrings.invalidTimeFrame)
            return
        }
        
        // Create request
        let fuzzyLocation = FuzzyLocation(
            latitude: destination.location.latitude,
            longitude: destination.location.longitude,
            accuracyRadius: radiusKm * 0.2 // Fuzz by 20% of radius
        )
        
        let dest = Destination(
            name: destination.name,
            fuzzyLocation: fuzzyLocation,
            shareVenueNameOnly: shareVenueNameOnly
        )
        
        let request = BeginOpenRequest(
            userId: userId,
            destination: dest,
            radiusKm: radiusKm,
            durationMinutes: selectedDurationMinutes,
            notes: notes.isEmpty ? nil : notes,
            startTime: startTime
        )
        
        do {
            await MainActor.run { isLoading = true }
            
            let broadcast = try await service.beginOpenBroadcast(request: request)
            
            await MainActor.run {
                activeBroadcast = broadcast
                isActive = true
                showComposer = false
                isLoading = false
                
                // Start countdown
                startCountdown(expiresAt: broadcast.expiresAt)
                
                // Show success message
                errorMessage = SerendipityStrings.broadcastSent
                showError = true
                
                // Provide haptic feedback
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                
                resetComposerState()
            }
            
            // Handle zero recipients
            if estimatedRecipients == 0 {
                TelemetryService.shared.log(event: .zeroRecipients, metadata: ["broadcast_id": broadcast.id])
            }
            
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                showError = true
                isLoading = false
            }
            TelemetryService.shared.logError(error, context: "Begin broadcast")
        }
    }
    
    private func showValidationError(_ message: String) async {
        await MainActor.run {
            errorMessage = message
            showError = true
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
        
        TelemetryService.shared.log(event: .validationError, metadata: ["message": message])
    }
    
    private func resetComposerState() {
        selectedDestination = nil
        shareVenueNameOnly = true
        selectedDurationMinutes = 60
        startNow = true
        scheduledStartTime = Date()
        notes = ""
        radiusKm = SerendipityConfiguration.defaultRadiusKm
        estimatedRecipients = 0
        searchText = ""
    }
    
    private func startCountdown(expiresAt: Date) {
        stopCountdown()
        
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            let remaining = max(0, Int(expiresAt.timeIntervalSinceNow))
            self.countdownText = SerendipityStrings.timeRemaining(remaining)
            
            if remaining <= 0 {
                self.handleExpiration()
            }
        }
    }
    
    private func stopCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = nil
    }
    
    private func handleExpiration() {
        stopCountdown()
        isActive = false
        activeBroadcast = nil
        
        errorMessage = SerendipityStrings.broadcastEnded
        showError = true
        
        if let broadcast = activeBroadcast {
            TelemetryService.shared.log(event: .endEarly, metadata: [
                "broadcast_id": broadcast.id,
                "auto_expired": true
            ])
        }
    }
    
    // MARK: - Computed Properties
    
    var isValidForBroadcast: Bool {
        selectedDestination != nil
    }
}

