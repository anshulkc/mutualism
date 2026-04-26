//
//  ProfileView.swift
//  mutualism
//
//  User profile page with name and role
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var showSettings = false
    
    var body: some View {
        ZStack {
            // Background base
            AppColors.adaptivePrimary(for: colorScheme).opacity(0.4)
                .ignoresSafeArea()
            
            // Overlay gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    AppColors.adaptiveBackground(for: colorScheme).opacity(0.85),
                    AppColors.adaptiveBackground(for: colorScheme).opacity(0.3),
                    AppColors.adaptiveBackground(for: colorScheme).opacity(0.85)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                // Top Navigation
                HStack {
                    Button(action: {
                        print("Referrals tapped")
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "gift")
                                .font(.system(size: 20))
                            Text("referrals")
                                .font(AppTypography.body())
                        }
                        .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                        .padding(.horizontal, AppSpacing.md)
                        .padding(.vertical, AppSpacing.sm)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showSettings = true
                    }) {
                        VStack(spacing: 4) {
                            Rectangle()
                                .fill(AppColors.adaptiveText(for: colorScheme))
                                .frame(width: 24, height: 2)
                            Rectangle()
                                .fill(AppColors.adaptiveText(for: colorScheme))
                                .frame(width: 24, height: 2)
                            Rectangle()
                                .fill(AppColors.adaptiveText(for: colorScheme))
                                .frame(width: 24, height: 2)
                        }
                        .padding(AppSpacing.md)
                    }
                    .accessibilityLabel("Settings menu")
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.top, 8)
                
                Spacer()
                
                // Profile Name
                VStack(spacing: 8) {
                    HStack {
                        Text("anshul")
                            .font(AppTypography.largeTitle())
                            .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 32))
                            .foregroundColor(AppColors.adaptivePrimaryStrong(for: colorScheme))
                            .offset(y: 4)
                    }
                    
                    Text("experientialist")
                        .font(AppTypography.body())
                        .foregroundColor(AppColors.adaptiveTextMuted(for: colorScheme))
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

#Preview {
    ProfileView()
}

