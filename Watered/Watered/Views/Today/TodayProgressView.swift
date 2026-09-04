//
//  TodayProgressView.swift
//  Watered
//
//  Created by Frank Sedivy on 27/08/2026.
//

import SwiftUI

// MARK: - Today Progress View
//
// Purpose: Displays the user's progress toward their daily hydration target.
//
// Input:
// Accepts display-ready progress text, such as "54%"
// Accepts a visual progress value for the progress bar.
//
// Returns:
// A SwiftUI view containing the 0% label, progress bar, 100% label and current
// progress text.
//
// UI role:
// Keeps progress presentation separate from TodayView. This view does not
// calculate hydration progress; it only displays values prepared elsewhere.
struct TodayProgressView: View {
    let progressText: String
    let visualProgressValue: Double
    
    var body: some View {
        VStack(spacing: 4) {
            Text("0%")
                .font(.caption)
        
            ProgressView(value: visualProgressValue)
            
            Text("100%")
                .font(.caption)
            
            Text(progressText)
                .font(.title2)
                .fontWeight(.semibold)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Hydration progress")
        .accessibilityValue(progressText)
    }
}

#Preview {
    TodayProgressView(
        progressText: "54%",
        visualProgressValue: 0.54
    )
    .padding()
    .background(Color.blue)
}

