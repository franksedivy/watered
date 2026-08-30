//
//  TodayToolbar.swift
//  Watered
//
//  Created by Frank Sedivy on 26/08/2026.
//

import SwiftUI

// MARK: - Today Toolbar View
//
// Purpose:
// Defines the toolbar controls shown at the top of the Today screen.
//
// Input:
// This toolbar currently does not accept any external values.
//
// Returns:
// Toolbar content that can be attached to a NavigationStack-backed screen
//
// UI role:
// Keeps top-bar controls separate from TodayView's screen layout. The screen
// title itself is handled by TodayView using navigationTitle.
//
// Notes:
// If the profile control later gains custom styling or real account data, those
// values should be added as explicit inputs.
struct TodayToolbar: ToolbarContent {
    
    
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Text("FS")
                .font(.headline)
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
                TodayToolbar()
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
