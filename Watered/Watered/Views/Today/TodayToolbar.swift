//
//  TodayHeaderToolbar.swift
//  Watered
//
//  Created by Frank Sedivy on 26/08/2026.
//

import SwiftUI

// MARK: - Today Header View
//
// Purpose:
// Defines the toolbar controls shown at the top of the Today screen.
//
// Input:
// Accepts a glass tint color so the profile control can match Watered's current
// glass styling
//
// Returns:
// Toolbar content that can be attached to a NavigationStack-backed screen
//
// UI role:
// Keeps top-bar controls separate from TodayView's screen layout. The screen
// title itself is handled by TOdayView using navigationTitle.
struct TodayToolbar: ToolbarContent {
    let glassTint: Color
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Text("FS")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
        }
    }
}

#Preview {
    NavigationStack {
        Color.blue
            .ignoresSafeArea()
            .navigationTitle(Text("Today"))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                TodayToolbar(glassTint: Color.black.opacity(0.60))
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
