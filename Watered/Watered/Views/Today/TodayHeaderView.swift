//
//  TodayHeaderView.swift
//  Watered
//
//  Created by Frank Sedivy on 26/08/2026.
//

import SwiftUI

// MARK: - Today Header View
//
// Purpose:
// Displays the fixed header at the top of the Today screen.
//
// Input:
// Accepts a glass tint color so the parent Today view can keep the avatar
// styling consistent with the rest of the screen.
//
// Returns:
// A SwiftUI view containing the Today title and profile initials placeholder.
//
// UI role:
// Keeps the Today screen header separate from the main Today layout. This view
// owns only the top title/avatar presentation.
struct TodayHeaderView: View {
    let glassTint: Color
    
    var body: some View {
        HStack(alignment: .top) {
            Text("Today")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            Text("FS")
                .font(.headline)
                .frame(width: 44, height: 44)
                .glassEffect(.regular.tint(glassTint), in: Circle())
        }
    }
}

#Preview {
    TodayHeaderView(
        glassTint: Color.black.opacity(0.60)
    )
}
