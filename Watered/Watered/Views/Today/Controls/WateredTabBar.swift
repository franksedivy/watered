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
// Input:
// Accepts a glass tint color so the parent screen can control the visual style.
// Accepts an onAddDrink action so the tab bar can trigger drink adding without
// knowing how drinks are created.
//
// Behavior:
// Builds the Today tab calendar symbol from the current day of the month.
//
// Returns:
// A SwiftUI view containing the current TOday tab item and add-drink button.
//
// UI role:
// Keeps the bottom navigation/action layout separate from TodayView.
struct WateredTabBar: View {
    let glassTint: Color
    let onAddDrink:() -> Void
    
    // Purpose: Builds the SF Symbol name for today's calendar day.
    //
    // Returns: A symbol name such as "1.calendar", "24.calendar", or "31.calendar".
    //
    // UI role:
    // Keeps the Today tab icon logic inside the tab bar instead of making the parent
    // Today screen prepare tab-specific display details.
    private var todayCalendarSymbolName: String {
        let dayOfMonth = Calendar.current.component(.day, from: Date())
        return "\(dayOfMonth).calendar"
    }
    
    var body: some View {
        HStack {
            WateredTabBarItem(
                systemImageName: todayCalendarSymbolName,
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
        glassTint: Color.black.opacity(0.60),
        onAddDrink: {}
    )
}
