//
//  LocationPermissionView.swift
//  mutualism
//
//  Location permission onboarding screen
//

import SwiftUI
import CoreLocation

struct LocationPermissionView: View {
    let onNext: () -> Void
    let onSkip: () -> Void
    @ObservedObject var locationManager: LocationManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Icon
            Image(systemName: "location.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(AppColors.adaptivePrimary(for: colorScheme))
                .padding(.bottom, AppSpacing.xl)
            
            // Title
            Text("enable location")
                .font(AppTypography.sectionTitle())
                .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.xl)
                .padding(.bottom, AppSpacing.md)
            
            // Description
            Text("we need location to show you mutuals nearby. your location is only shared when you're \"open\"")
                .font(AppTypography.body())
                .foregroundColor(AppColors.adaptiveTextMuted(for: colorScheme))
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal, AppSpacing.xl)
            
            Spacer()
            
            // Buttons
            OnboardingButtonStack(
                primaryTitle: primaryButtonText,
                onPrimary: handlePrimaryAction,
                onSecondary: onSkip
            )
        }
    }
    
    private var primaryButtonText: String {
        locationManager.authorizationStatus == .authorizedWhenInUse || 
        locationManager.authorizationStatus == .authorizedAlways 
        ? "continue" : "enable location"
    }
    
    private func handlePrimaryAction() {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestPermission()
            // Wait a moment for permission dialog
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                onNext()
            }
        } else {
            onNext()
        }
    }
}

