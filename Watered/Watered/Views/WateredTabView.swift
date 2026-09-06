//
//  WateredTabView.swift
//  Watered
//
//  Created by Frank Sedivy on 30/08/2026.
//

import SwiftUI
import SwiftData

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

    // MARK: - Tabs
    //
    // Purpose: Defines the top-level app tabs that Watered currently supports.
    //
    // UI role:
    // Gives the TabView a typed selection value so app-level overlays, such as the
    // empty-state add-drink prompt, can react to the currently selected tab.
    private enum WateredTab: String {
        case today = "Today"
        case learn = "Learn"
    }
    
    // Purpose: Stores the currently selected top-level app tab.
    //
    // UI role: Lets WateredTabView show app-level UI only when it belongs to the
    // active tab.
    @State private var selectedTab: WateredTab = .today

    // MARK: - Temporary State
    //
    // Purpose: Stores the temporary display unit selected for the app.
    //
    // UI role:
    // WateredTabView owns this because it sits above both TodayView, which displays
    // volumes, and ProfileView, which will later let the user change the unit.
    //
    // Notes:
    // This is temporary 0.2 state. It will reset when the app relaunches until a
    // proper settings/persisstence layer exists.
    @State private var displayUnit: LiquidUnit = .milliliters

    // Purpose: Stores Watered's first app-level state owner.
    //
    // UI role:
    // Keeps drink entries above the tab views without making WateredTabView
    // directly own or mutate the entries array.
    @State private var store = WateredStore()
    
    // MARK: - Persistence
    //
    // Purpose:
    // Gives WateredTabView access to the SwiftData context supplied by WateredApp.
    //
    // UI role:
    // Lets the Add Drink submission boundary save new drink entries
    @Environment(\.modelContext) private var modelContext
    
    // Purpose:
    // Reads persisted drink entries from SwftData.
    //
    // UI role:
    // Lets WateredTabView hydrate WateredStore when the app starts.
    @Query(sort: \PersistentDrinkEntry.loggedAt) private var persistentDrinkEntries: [PersistentDrinkEntry]

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

    // MARK: - Empty Today Prompt
    //
    // Purpose: Decide whether the first-drink prompt should be visible
    // Returns: true when the user is on Today and has not logged any drinks
    //
    // UI role:
    // Keeps the prompt attached to the app-level add-drink action without showing
    // it over unrelated tabs such as Learn.
    private var shouldShowFirstDrinkPrompt: Bool {
        let isTodaySelected = selectedTab == .today
        let hasNoDrinks = store.entries.isEmpty

        return isTodaySelected && hasNoDrinks
    }

    // MARK: - Transitions
    //
    // Purpose:
    // Provides the shared animation namespace used to visually connect the
    // floating Add Drink button with the Add Drink sheet.
    //
    // UI role:
    // Lets SwiftUI treat the button as the source of the sheet's zoom transition.
    @Namespace private var addDrinkTransition

    // Purpose:
    // Gives the Add Drink button and Add Drink sheet a shared transition identity.
    private let addDrinkTransitionID = "addDrink"

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $selectedTab) {

                TodayView(
                    entries: store.entries,
                    displayUnit: displayUnit,
                    onOpenProfile: openProfile
                )
                    .tabItem {
                        Label("Today", systemImage: todayCalendarSymbolName)
                    }
                    .tag(WateredTab.today)

                LearnView(onOpenProfile: openProfile)
                    .tabItem {
                        Label("Learn", systemImage: "lightbulb")
                    }
                    .tag(WateredTab.learn)
            }
            .onChange(of: displayUnit) { previousUnit, newUnit in
                wateredLog("Display unit changed from \(previousUnit.rawValue) to \(newUnit.rawValue)")
            }
            .onChange(of: selectedTab) { previousTab, newTab in
                wateredLog("Selected tab changed from \(previousTab.rawValue) to \(newTab.rawValue)")
            }
            .onAppear {
                loadPersistedDrinkEntries()
            }
            .onChange(of: persistentDrinkEntries) {
                loadPersistedDrinkEntries()
            }

            AddDrinkActionButton {
                wateredLog("Add Drink flow opened")
                isShowingAddDrinkSheet = true
            }

            .frame(width: 88, height: 88)
            .contentShape(Rectangle())
            .matchedTransitionSource(
                id: addDrinkTransitionID,
                in: addDrinkTransition
            )
            .padding(.trailing, 12)
            .padding(.bottom, -26)


            if shouldShowFirstDrinkPrompt {
                FirstDrinkPrompt()
                    .allowsHitTesting(false)
                    .padding(.trailing, 88)
                    .padding(.bottom, 64)
            }
        }

        .sheet(isPresented: $isShowingAddDrinkSheet, onDismiss: {
            wateredLog("Add Drink flow dismissed")
        }) {
            AddDrinkView(
                defaultUnit: displayUnit,
                onAddDrink: addDrinkEntry
            )
            .navigationTransition(
                .zoom(
                    sourceID: addDrinkTransitionID,
                    in: addDrinkTransition
                )
            )
            .presentationDetents([.fraction(0.68), .large])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isShowingProfileSheet) {
            ProfileView(displayUnit: $displayUnit)
        }
    }

    // MARK: - Actions

    // Purpose:
    // Loads persisted drink entries into Watered's app-level store.
    //
    // Behavior:
    // Converts SwiftData rows back into DrinkEntry values and ignores rows that no
    // longer map to known model values.
    private func loadPersistedDrinkEntries() {
        let loadedEntries = persistentDrinkEntries.compactMap { persistentDrinkEntry in
            persistentDrinkEntry.drinkEntry()
        }
        
        let skippedEntryCount = persistentDrinkEntries.count - loadedEntries.count
        
        if skippedEntryCount > 0 {
            wateredLog("Persistence skipped \(skippedEntryCount) stored drink rows that could not be mapped.")
        }
        
        wateredLog("Persistence read finished with \(loadedEntries) drink entries")
        store.loadDrinkEntries(loadedEntries)
    }
    
    // Purpose: Adds a real drink entry submitted from the Add Drink form.
    //
    // Input:
    // Recieves the DrinkEntry created by AddDrinkView from the selected drink type,
    // selected volume, selected unit, and current date.
    //
    // Behavior:
    // Saves the entry to SwiftData, updates the app-level store, logs the added
    // drink, and closes the Add Drink sheet so Today can refresh with the new total.
    private func addDrinkEntry(_ entry: DrinkEntry) {
        let persistentDrinkEntry = PersistentDrinkEntry(drinkEntry: entry)
        
        wateredLog("Persistence insert started for drink entry \(entry.id)")
        modelContext.insert(persistentDrinkEntry)
        wateredLog("Drink entry accepted by Today state: \(entry.type.rawValue) \(entry.amount.formatted); drink count is \(store.entries.count)")
        store.addDrinkEntry(entry)
        isShowingAddDrinkSheet = false
    }

    // Purpose: Open the temporary profile sheet.
    //
    // UI role:
    // Gives every top-level tab the same persistent profile destination.
    private func openProfile() {
        wateredLog("Profile opened")
        isShowingProfileSheet = true
    }
}

#Preview {
    WateredTabView()
}
