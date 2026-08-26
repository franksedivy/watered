//
//  WateredTabBar.swift
//  Watered
//
//  Created by Frank Sedivy on 26/08/2026.
//

import SwiftUI

// MARK: - Watered Tab Bar
//
// Purpose:
// Displays Watered's custom bottom tab bar and main add-drink action.
//
// Input: Accepts the SF Symbol name for the Today tab icon.
// Accepts a glass tint color so the parent screen can control the visual style.
// Accepts an onAddDrink action so the tab bar can trigger drink adding without
// knowing how drinks are created.
//
// Returns:
// A SwiftUI view containing the current TOday tab item and add-drink button.
//
// UI role:
// Keeps the bottom navigation/action layout separate from TodayView.
struct WateredTabBar: View {
    let todaySymbolName: String
    let glassTint: Color
    let onAddDrink:() -> Void
    
    var body: some View {
        HStack {
            WateredTabBarItem(
                systemImageName: todaySymbolName,
                title: "Today",
                glassTint: glassTint
            )
            
            Spacer()
            
            AddDrinkButton(
                glassTint: glassTint,
                onAddDrink: onAddDrink
            )
        }
    }
}

#Preview {
    WateredTabBar(
        todaySymbolName: "26.calendar",
        glassTint: Color.black.opacity(0.60),
        onAddDrink: {}
    )
}
