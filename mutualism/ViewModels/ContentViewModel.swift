//
//  ContentViewModel.swift
//  mutualism
//
//  ViewModel for content state management
//

import SwiftUI
import MapKit

// MARK: - ViewModel
class ContentViewModel: ObservableObject {
    @Published var isOpen: Bool = true
    @Published var mutuals: [Mutual] = []
    @Published var activities: [Activity] = []
    @Published var closeFriendsCount: Int = 0
    
    init() {
        loadMutuals()
    }
    
    func loadMutuals() {
        // Sample mutuals for the map
        mutuals = [
            Mutual(coordinate: CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.4094), color: Color(red: 0.4, green: 0.5, blue: 0.95)),
            Mutual(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4294), color: Color(red: 0.55, green: 0.65, blue: 0.85)),
            Mutual(coordinate: CLLocationCoordinate2D(latitude: 37.7649, longitude: -122.4194), color: Color(red: 0.6, green: 0.45, blue: 0.85)),
            Mutual(coordinate: CLLocationCoordinate2D(latitude: 37.7799, longitude: -122.4244), color: Color(red: 0.65, green: 0.75, blue: 0.85))
        ]
    }
    
    func inviteFriends() {
        print("Invite friends tapped")
    }
    
    func addMutual() {
        print("Add mutual tapped")
    }
    
    func addActivity() {
        print("Add activity tapped")
    }
    
    func shuffleFriend() {
        print("Shuffle friend tapped")
    }
    
    func checkCompatibility() {
        print("Check compatibility tapped")
    }
}

// MARK: - Models
struct Mutual: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let color: Color
}

struct Activity: Identifiable {
    let id = UUID()
    let title: String
    let timestamp: Date
}

