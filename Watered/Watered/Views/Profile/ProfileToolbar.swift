//
//  ProfileToolbar.swift
//  Watered
//
//  Created by Frank Sedivy on 26/08/2026.
//

import SwiftUI

// MARK: - Profile Toolbar View
//
// Purpose:
// Defines the persistent profile toolbar control.
//
// Input:
// Accepts an onOpenProfile closure from the screen that attaches the toolbar.
//
// Returns:
// Toolbar content containing the FS profile button.
//
// UI role:
// Keep the profile entry point reusable across top-level screens such as Today
// and Learn. The toolbar owns only the visual control' the parent decides what
// happens when it is tapped.
//
struct ProfileToolbar: ToolbarContent {
    // MARK: - Actions
    //
    // Purpose: Stores the action that opens the temporary profile sheet.
    //
    // Input:
    // Supplied by the screen or container that owns the profile sheet state.
    private let onOpenProfile: () -> Void
    
    // MARK: - Initisalisation
    
    init(onOpenProfile: @escaping () -> Void) {
        self.onOpenProfile = onOpenProfile
    }
    
    // MARK: - Body
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: onOpenProfile) {
                Text("FS")
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Profile")
            .accessibilityHint("Opens Profile settings.")
            .accessibilityIdentifier("profileButton")
        }
    }
}

#Preview {
    NavigationStack {
        Color.blue
            .ignoresSafeArea()
            .navigationTitle(Text("Preview"))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ProfileToolbar(onOpenProfile: {})
            }
    }
}
