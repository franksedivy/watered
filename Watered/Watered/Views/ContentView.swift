//
//  ContentView.swift
//  Watered
//
//  Created by Frank Sedivy on 26/06/2026.
//

import SwiftUI

// MARK: - Main App Content
//
// Purpose: Shows the app's main screen.
//
// Returns: A SwiftUI view containing the current primary Watered experience.
//
// UI Role: Keeps the app entry view separate from the Today screen implementation.
struct ContentView: View {
    
    var body: some View {
        TodayView()
    }
}

#Preview {
    ContentView()
}
