//
//  WateredTabView.swift
//  Watered
//
//  Created by Frank Sedivy on 30/08/2026.
//

import SwiftUI

// MARK: - Watered Tab View
//
// Purpose: Define Watered's top-level tab navigation.
//
// Returns:
// A native SwiftUI TabView containing the main app areas.
//
// UI role:
// This view owns the temporary -.2 drink entries because both TodayView and
// AddDrinkView need access to the same demo data.
//
// Notes:
// Today is the read-only summary screen. Add Drink is currently a temporary
// placeholder, but it gives the future 0.3 add-drink flow a real home.
struct WateredTabView: View {
    
    // MARK: - Temporary State
    //
    // Purpose: Stores temporary drink entries while the 0.2 UI is being built.
    //
    // UI role:
    // Keeps shared screen state above the tabs so TodayView can display entries
    // and AddDrinkView can add entries.
    @State private var entries: [DrinkEntry] = []
    
    // MARK: - Temporary Demo Data
    // Creates temporary drinks for the prototype add-drink action.
    //
    // Notes:
    // This will be replaced by the real add-drink flow in the 0.3 milestone.
    private let demoDrinkSource = TodayDemoDrinkSource()
    
    // MARK: - Tab Icons
    // Builds the SF Symbol name for today's calendar day.
    //
    // Returns:
    // A Symbol name such as "1.calendar", "24.calendar", or "31.calendar".
    //
    // UI role:
    private var todayCalendarSymbolName: String {
        let dayOfMonth = Calendar.current.component(.day, from: Date())
        return "\(dayOfMonth).calendar"
    }
    
    // MARK: - Body
    
    var body: some View {
        TabView {
            TodayView(entries: entries)
                .tabItem {
                    Label("Today", systemImage: todayCalendarSymbolName)
                }
            
            AddDrinkView(onAddDrink: addDemoDrink)
                .tabItem {
                    Label("Add Drink", systemImage: "plus")
                }
        }
    }
    
    // MARK: - Actions
    //
    // Purpose: Adds one temporary random demo drink.
    //
    // Behavior:
    // If the demo source returns an entry, it is appended to the shared temporary
    // entries state. SwiftUI then refreshes TodayView with the updated entries.
    private func addDemoDrink() {
        wateredLog("Add drink button tapped")
        
        guard let entry = demoDrinkSource.randomEntry() else {
            return
        }
        
        wateredLog("Adding demo drink: \(entry.amount) of \(entry.type)")
        entries.append(entry)
        
    }
}

#Preview {
    WateredTabView()
}
