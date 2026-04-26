//
//  OnboardingView.swift
//  mutualism
//
//  Main onboarding flow container
//

import SwiftUI
import CoreLocation

struct OnboardingView: View {
    @EnvironmentObject var onboardingManager: OnboardingManager
    @StateObject private var locationManager = LocationManager()
    @State private var currentStep: OnboardingStep = .problemStatement
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            AppColors.adaptiveBackground(for: colorScheme)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress Bar
                HStack(spacing: AppSpacing.sm) {
                    ForEach(OnboardingStep.allCases, id: \.rawValue) { step in
                        Capsule()
                            .fill(step.rawValue <= currentStep.rawValue ? 
                                  AppColors.adaptivePrimary(for: colorScheme) : 
                                  AppColors.adaptiveBorder(for: colorScheme))
                            .frame(height: 4)
                            .animation(.easeInOut(duration: 0.3), value: currentStep)
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, 60)
                .padding(.bottom, AppSpacing.lg)
                
                // Content - Conditional rendering based on step
                ZStack {
                    switch currentStep {
                    case .problemStatement:
                        ProblemStatementView(
                            onNext: { moveToNextStep() },
                            onSkip: { skipOnboarding() }
                        )
                    case .introducing:
                        IntroducingView(
                            onNext: { moveToNextStep() },
                            onSkip: { skipOnboarding() }
                        )
                    case .instagram:
                        InstagramOnboardingView(
                            onNext: { moveToNextStep() },
                            onSkip: { skipOnboarding() }
                        )
                    case .inviteFriends:
                        InviteFriendsView(
                            onNext: { moveToNextStep() },
                            onSkip: { skipOnboarding() }
                        )
                    case .location:
                        LocationPermissionView(
                            onNext: { moveToNextStep() },
                            onSkip: { skipOnboarding() },
                            locationManager: locationManager
                        )
                    case .ready:
                        CompleteOnboardingView(
                            onComplete: { onboardingManager.completeOnboarding() }
                        )
                    }
                }
                .transition(.opacity)
            }
        }
    }
    
    private func moveToNextStep() {
        withAnimation {
            if currentStep == .ready {
                onboardingManager.completeOnboarding()
            } else if let nextStep = OnboardingStep(rawValue: currentStep.rawValue + 1) {
                currentStep = nextStep
            }
        }
    }
    
    private func skipOnboarding() {
        onboardingManager.completeOnboarding()
    }
}

#Preview {
    OnboardingView()
        .environmentObject(OnboardingManager())
}

