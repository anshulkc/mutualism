//
//  BottomNavBar.swift
//  mutualism
//
//  Bottom navigation bar with badges
//

import SwiftUI

struct BottomNavBar: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            // Gallery/Grid icon
            NavBarButton(
                icon: "photo.on.rectangle",
                badge: nil,
                isSelected: selectedTab == 0,
                action: { selectedTab = 0 }
            )
            
            Spacer()
            
            // Camera/Add icon with badge
            NavBarButton(
                icon: "camera",
                badge: 4,
                isSelected: selectedTab == 1,
                action: { selectedTab = 1 }
            )
            
            Spacer()
            
            // Profile icon with badge
            NavBarButton(
                icon: "person.crop.rectangle",
                badge: 1,
                isSelected: selectedTab == 2,
                action: { selectedTab = 2 }
            )
        }
        .padding(.horizontal, 50)
        .padding(.vertical, 16)
        .background(AppColors.adaptiveSurface(for: colorScheme))
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(AppColors.adaptiveBorder(for: colorScheme)),
            alignment: .top
        )
    }
}

struct NavBarButton: View {
    @Environment(\.colorScheme) var colorScheme
    
    let icon: String
    let badge: Int?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected 
                        ? AppColors.adaptivePrimary(for: colorScheme)
                        : AppColors.adaptiveTextMuted(for: colorScheme))
                    .frame(width: 44, height: 44)
                    .background(Color.clear)
                
                if let badge = badge {
                    Circle()
                        .fill(AppColors.adaptiveAccent(for: colorScheme))
                        .frame(width: 20, height: 20)
                        .overlay(
                            Text("\(badge)")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(AppColors.adaptiveBackground(for: colorScheme))
                        )
                        .offset(x: 8, y: -4)
                }
            }
        }
        .pressableScale(0.9)
        .accessibilityLabel(icon)
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
        .accessibilityValue(badge != nil ? "\(badge!) notifications" : "")
    }
}

