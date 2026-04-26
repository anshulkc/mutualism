//
//  OnboardingManager.swift
//  mutualism
//
//  Manages onboarding state and persistence
//

import SwiftUI
import CoreLocation

// MARK: - Onboarding Manager
class OnboardingManager: ObservableObject {
    @Published var hasCompletedOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
        }
    }
    
    init() {
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
    }
    
    func resetOnboarding() {
        hasCompletedOnboarding = false
    }
}

// MARK: - Onboarding Steps
enum OnboardingStep: Int, CaseIterable {
    case problemStatement = 0
    case introducing = 1
    case instagram = 2
    case inviteFriends = 3
    case location = 4
    case ready = 5

    var title: String {
        switch self {
        case .problemStatement: return "problem"
        case .introducing: return "solution"
        case .instagram: return "connect instagram"
        case .inviteFriends: return "invite friends"
        case .location: return "enable location"
        case .ready: return "ready to explore"
        }
    }

    var iconName: String {
        switch self {
        case .problemStatement: return "exclamationmark.bubble"
        case .introducing: return "sparkles"
        case .instagram: return "camera"
        case .inviteFriends: return "person.2"
        case .location: return "location"
        case .ready: return "checkmark.circle"
        }
    }

    var description: String {
        switch self {
        case .problemStatement:
            return "it's hard to meet up with friends spontaneously. schedules are busy and coordination is difficult."
        case .introducing:
            return "mutualism makes it easy to see when your friends are free and nearby, so you can hang out without the hassle."
        case .instagram:
            return "connect your instagram to find friends who are already on mutualism and build your network."
        case .inviteFriends:
            return "invite your closest friends to join mutualism so you can see when they're around."
        case .location:
            return "we need your location to show you which friends are nearby when you're both available."
        case .ready:
            return "you're all set! start seeing your friends when they're around and make spontaneous plans."
        }
    }
}

// MARK: - Location Manager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        manager.delegate = self
        authorizationStatus = manager.authorizationStatus
    }
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
}

