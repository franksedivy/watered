//
//  WateredTabBarItem.swift
//  Watered
//
//  Created by Frank Sedivy on 26/08/2026.
//

import SwiftUI

// MARK: - Watered Tab Bar Item
//
// Purpose: Displays one item inside Watered's custom tab bar.
//
// Input:
// Accepts an SF Symbol name and a text label.
// Accepts a glass tint colour so the tab item can match the surrounding tab bar.
//
// Returns:
// A SwiftUI view for one custom tab bar item.
//
// UI role:
// This is the reusable building block for Watered's bottom tab bar. Today is the
// first item, but future app sections can use this same structure.
struct WateredTabBarItem: View {
    let systemImageName: String
    let title: String
    let glassTint: Color
    
    var body: some View {
        VStack(spacing: 3) {
            Image(systemName: systemImageName)
                .font(.system(size: 32, weight: .regular))
            
            Text(title)
                .font(.system(size: 12, weight: .bold))
        }
        .foregroundStyle(.white)
        .frame(width: 120, height: 62)
        .glassEffect(.regular.tint(glassTint), in: Capsule())
    }
}

#Preview {
    WateredTabBarItem(
        systemImageName: "26.calendar",
        title: "Today",
        glassTint: Color.black.opacity(0.60)
    )
}
