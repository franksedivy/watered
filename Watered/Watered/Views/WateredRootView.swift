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
// TodayView is the only active screen for now. When watered grows real tabs,
// onboarding, settings, or authentication, this is the place where that top-level
// app structure should begin.
struct WateredRootView: View {
    var body: some View {
        TodayView()
    }
}

#Preview {
    WateredRootView()
}
