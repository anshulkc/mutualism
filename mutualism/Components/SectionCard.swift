//
//  SectionCard.swift
//  mutualism
//
//  Reusable card component for sections
//

import SwiftUI

struct SectionCard<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(AppSpacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .fill(AppColors.adaptiveSurface(for: colorScheme))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppRadius.lg)
                            .stroke(AppColors.adaptiveBorder(for: colorScheme), lineWidth: 1)
                    )
                    .shadow(color: AppColors.adaptiveBorder(for: colorScheme).opacity(0.3), radius: 8, x: 0, y: 2)
            )
    }
}

