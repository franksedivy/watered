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
// This view owns the temporary 0.2 drink entries because TodayView needs to
// display them and the future add-drink sheet will need to create them.
//
// Notes:
// Today is the read-only summary screen. Learn is a temporary placeholder tab.
// Add Drink will be presented as a sheet from the tab bar area.
struct WateredTabView: View {
    
    // MARK: - Temporary State
    //
    // Purpose: Stores temporary drink entries while the 0.2 UI is being built.
    //
    // UI role:
    // Keeps shared screen state above the tabs so TodayView can display entries
    // and AddDrinkView can add entries.
    @State private var entries: [DrinkEntry] = []
    
    // Purpose: Controls whether the temporary Add Drink sheet is visible.
    //
    // UI role:
    // Keeps AddDrinkView out of the tab bar while still allowing it to appear as a
    // focused add-drink flow above the current tab.
    @State private var isShowingAddDrinkSheet = false
    
    // Purpose: Controls whether the temporary Profile sheet is visible.
    //
    // UI role:
    // Keeps profile presentation at the app-tab level so the same profile button
    // can appear on multiple top-level screens.
    @State private var isShowingProfileSheet = false
    
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
        ZStack(alignment: .bottomTrailing) {
            TabView {
                
                TodayView(entries: entries, onOpenProfile: openProfile)
                    .tabItem {
                        Label("Today", systemImage: todayCalendarSymbolName)
                    }
                
                LearnView(onOpenProfile: openProfile)
                    .tabItem {
                        Label("Learn", systemImage: "lightbulb")
                    }
            }
            
            AddDrinkActionButton {
                isShowingAddDrinkSheet = true
            }
            .padding(.trailing, 24)
            .padding(.bottom, -13
            )
        }
        .sheet(isPresented: $isShowingAddDrinkSheet) {
            AddDrinkView(onAddDrink: addDemoDrink)
        }
        .sheet(isPresented: $isShowingProfileSheet) {
            ProfileView()
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
    
    // Purpose: Open the temporary profile sheet.
    //
    // UI role:
    // Gives every top-level tab the same persistent profile destination.
    private func openProfile() {
        wateredLog( "Profile button tapped")
        isShowingProfileSheet = true
    }
}

#Preview {
    WateredTabView()
}
