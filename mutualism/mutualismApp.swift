//
//  mutualismApp.swift
//  mutualism
//
//  Created by Anshul Chennavaram on 10/2/25.
//

import SwiftUI

@main
struct mutualismApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var onboardingManager = OnboardingManager()

    init() {
        // Register custom fonts on app launch
        AppTypography.registerFonts()
    }

    var body: some Scene {
        WindowGroup {
            if onboardingManager.hasCompletedOnboarding {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(onboardingManager)
            } else {
                OnboardingView()
                    .environmentObject(onboardingManager)
            }
        }
    }
}
