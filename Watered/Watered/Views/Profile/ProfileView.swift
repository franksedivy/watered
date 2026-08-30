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
    var body: some View {
        NavigationStack {
            Color.clear
                .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
}
