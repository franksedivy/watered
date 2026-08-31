//
//  ProfileView.swift
//  Watered
//
//  Created by Frank Sedivy on 30/08/2026.
//

import SwiftUI

// MARK: - Profile View
//
// Purpose:
// Shows the temporary Profile screen.
//
// Returns:
// A blank SwiftUI screen inside its own navigation stack.
//
// UI role:
// Gives the persistent FS profile button a real destination. For now this is an
// empty sheet, but later it can grow into account details, preferences, HealthKit
// permissions, display units, and other profile-level settings.
struct ProfileView: View {
    
    // Purpose: Stores the selected display unit for volume values.
    //
    // Input:
    // Supplied as a binding from WateredTabView, where temporary app-level display
    // unit state currently lives.
    //
    // UI role:
    // Allows Profile to change the app's display unit without owning the setting.
    @Binding var displayUnit: LiquidUnit
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Display units") {
                    Picker("Volume unit", selection: $displayUnit) {
                        ForEach(LiquidUnit.allCases) { liquidUnit in
                            Text(liquidUnit.rawValue)
                                .tag(liquidUnit)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            Color.clear
                .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView(displayUnit: .constant(.milliliters))
}
