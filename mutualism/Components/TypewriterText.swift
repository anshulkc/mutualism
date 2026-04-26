//
//  TypewriterText.swift
//  mutualism
//
//  Typewriter animation component for sequential text reveal
//

import SwiftUI

// MARK: - Text Segment
struct TextSegment {
    let text: String
    let color: Color
    let font: Font
    let isUnderlined: Bool
    
    init(text: String, color: Color, font: Font, isUnderlined: Bool = false) {
        self.text = text
        self.color = color
        self.font = font
        self.isUnderlined = isUnderlined
    }
}

// MARK: - Typewriter Text
struct TypewriterText: View {
    let segments: [TextSegment]
    let charactersPerSecond: Double
    let onComplete: (() -> Void)?
    
    @State private var displayedText: [String] = []
    @State private var currentSegmentIndex = 0
    @State private var currentCharIndex = 0
    @State private var timer: Timer?
    
    init(
        segments: [TextSegment],
        charactersPerSecond: Double = 1,
        onComplete: (() -> Void)? = nil
    ) {
        self.segments = segments
        self.charactersPerSecond = charactersPerSecond
        self.onComplete = onComplete
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<segments.count, id: \.self) { index in
                if index < displayedText.count {
                    let segment = segments[index]
                    let text = displayedText[index]
                    
                    Text(text)
                        .font(segment.font)
                        .foregroundColor(segment.color)
                        .underline(segment.isUnderlined)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .onAppear {
            displayedText = Array(repeating: "", count: segments.count)
            startTyping()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func startTyping() {
        let interval = 1.0 / charactersPerSecond
        
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            guard currentSegmentIndex < segments.count else {
                timer?.invalidate()
                onComplete?()
                return
            }
            
            let segment = segments[currentSegmentIndex]
            
            if currentCharIndex < segment.text.count {
                let index = segment.text.index(
                    segment.text.startIndex,
                    offsetBy: currentCharIndex
                )
                displayedText[currentSegmentIndex] = String(segment.text[...index])
                currentCharIndex += 1
            } else {
                // Move to next segment
                currentSegmentIndex += 1
                currentCharIndex = 0
            }
        }
    }
}

