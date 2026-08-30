//
//  WateredRootView.swift
//  Watered
//
//  Created by Frank Sedivy on 30/08/2026.
//

import SwiftUI

// MARK: - Watered Root View
//
// Purpose: Defines the first SwiftUI view shown by the Watered app.
//
// Returns:
// The root app experience
//
// UI role: Keeps WateredApp focused on app launch, while this view decides which main
// screen or navigation structure the app should show.
//
// Notes:
// WateredTabView currently owns the top-level app structure. Today is the main
// read-only summary screen, while Add Drink is a temporary placeholder the
// future 0.3 drink loggin flow.
struct WateredRootView: View {
    var body: some View {
        WateredTabView()
    }
}

#Preview {
    WateredRootView()
}
