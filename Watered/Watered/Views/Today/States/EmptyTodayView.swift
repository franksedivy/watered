//
//  EmptyTodayView.swift
//  Watered
//
//  Created by Frank Sedivy on 28/08/2026.
//

import SwiftUI

// MARK: - Empty Today View
//
// Purpose: Displays the Today screen state shown when no drinks have been logged.
//
// Input:
// This view currently does not accept model data. TodayView decides when the
// empty state should appear and then renders this view.
//
// Returns:
// A SwiftUI view containing the empty-state message
//
// UI Role:
// Keeps empty-state presentation separate from TodayView, so TodayView can
// focus on screen structure and state routing.
struct EmptyTodayView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text(".. has been pretty dry so far")
                .font(.system(size: 44, weight: .light).leading(.tight))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            
            Text("No drinks logged yet today.")
                .font(.body)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 120)
        
    }
}

#Preview {
    EmptyTodayView()
        .padding()
        .background(Color.yellow)
}
