//
//  LearnView.swift
//  Watered
//
//  Created by Frank Sedivy on 30/08/2026.
//

import SwiftUI

// MARK: - Learn View
//
// Purpose:
// Shows the temporary Learn screen.
//
// Returns:
// A blank SwiftUI screen inside its own navigation stack.
//
// UI role:
// Gives Watered a second real tab so the app can start behaving like a
// multi-section iOS app. The content is intentionally empty for now because
// learning content is outside the current 0.2 UI foundation work.
struct LearnView: View {
    let onOpenProfile: () -> Void
    
    var body: some View {
        NavigationStack {
            Color.clear
                .navigationTitle("Learn")
                .toolbar {
                    ProfileToolbar(onOpenProfile: onOpenProfile)
                }
        }
    }
}

#Preview {
    LearnView(onOpenProfile: {})
}
