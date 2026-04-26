//
//  TabButton.swift
//  mutualism
//
//  Tab navigation button component
//

import SwiftUI

struct TabButton: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isHovered = false
    
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTypography.tabLabel())
                .foregroundColor(isSelected 
                    ? AppColors.adaptivePrimary(for: colorScheme)
                    : AppColors.adaptiveTextMuted(for: colorScheme))
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.md)
                .background(Color.clear)
                .overlay(
                    Rectangle()
                        .frame(height: 3)
                        .foregroundColor(isSelected 
                            ? AppColors.adaptivePrimary(for: colorScheme)
                            : Color.clear),
                    alignment: .bottom
                )
        }
        .accessibilityLabel(title)
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
}

