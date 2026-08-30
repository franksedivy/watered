//
//  FirstDrinkPrompt.swift
//  Watered
//
//  Created by Frank Sedivy on 30/08/2026.
//

import SwiftUI

// MARK: - First Drink Prompt
//
// Purpose:
// Shows the empty-state prompt that nudges the user towards logging their first
// drink of the day.
//
// Returns:
// A small SwiftUI view containing prompt text.
//
// UI role:
// Keeps the first-drink prompt separate from WateredTabView and EmptyTodayView.
// WateredTabView decides when it appears because the prompt is positioned near
// the app-level add-drink button.
struct FirstDrinkPrompt: View {
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            Text("Go on, log\nyour first drink")
                .font(.system(size: 17, weight: .regular))
                .fontWeight(.semibold)
                .multilineTextAlignment(.trailing)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            Image(systemName: "arrow.down.right")
                .font(.system(size: 17, weight: .regular))
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    FirstDrinkPrompt()
        .padding()
}
