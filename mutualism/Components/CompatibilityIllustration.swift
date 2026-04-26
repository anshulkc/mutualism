//
//  CompatibilityIllustration.swift
//  mutualism
//
//  Illustration showing two people under a crescent moon
//

import SwiftUI

struct CompatibilityIllustration: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            ZStack {
                // Border frame
                RoundedRectangle(cornerRadius: 8)
                    .stroke(AppColors.adaptiveBorder(for: colorScheme), lineWidth: 1.5)
                    .frame(width: 160, height: 160)
                
                VStack(spacing: 20) {
                    // Crescent moon
                    CrescentMoon()
                        .frame(width: 40, height: 40)
                        .padding(.top, 16)
                    
                    // Two people illustration
                    HStack(spacing: 0) {
                        PersonSilhouette(facingRight: true)
                        PersonSilhouette(facingRight: false)
                    }
                    .padding(.bottom, 8)
                }
            }
            
            Text("check compatibility")
                .font(AppTypography.body())
                .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                .padding(.top, AppSpacing.md)
            
            Text("using the mutualism algorithm.")
                .font(AppTypography.body())
                .foregroundColor(AppColors.adaptiveText(for: colorScheme))
        }
    }
}

// MARK: - Crescent Moon
struct CrescentMoon: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.clear)
                .overlay(
                    Path { path in
                        let center = CGPoint(x: 20, y: 20)
                        let radius: CGFloat = 18
                        
                        // Draw crescent shape
                        path.move(to: CGPoint(x: center.x, y: center.y - radius))
                        path.addArc(center: center, radius: radius, startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: false)
                        path.addArc(center: CGPoint(x: center.x + 8, y: center.y), radius: radius - 5, startAngle: .degrees(90), endAngle: .degrees(-90), clockwise: true)
                    }
                    .fill(AppColors.adaptiveTextMuted(for: colorScheme).opacity(0.7))
                )
        }
        .frame(width: 40, height: 40)
    }
}

// MARK: - Person Silhouette
struct PersonSilhouette: View {
    @Environment(\.colorScheme) var colorScheme
    let facingRight: Bool
    
    var body: some View {
        ZStack {
            // Head
            Circle()
                .fill(AppColors.adaptiveTextMuted(for: colorScheme).opacity(0.8))
                .frame(width: 28, height: 28)
                .offset(y: -10)
            
            // Body
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.adaptiveTextMuted(for: colorScheme).opacity(0.8))
                .frame(width: 32, height: 40)
                .offset(y: 12)
        }
        .frame(width: 40, height: 70)
        .scaleEffect(x: facingRight ? 1 : -1, y: 1)
    }
}

