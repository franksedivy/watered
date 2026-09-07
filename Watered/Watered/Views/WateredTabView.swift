//
//  WateredTabView.swift
//  Watered
//
//  Created by Frank Sedivy on 30/08/2026.
//

import SwiftUI
import SwiftData
import UIKit

// MARK: - Watered Tab View
//
// Purpose: Define Watered's top-level tab navigation.
//
// Returns:
// A native SwiftUI TabView containing the main app areas.
//
// UI role:
// Acts as Watered's main app shell. It owns tab selection, app-wide sheet
// presentation, the floating Add Drink action, and the shared Profile entry
// point so those controls behave consistently across top-level screens.
//
// It also bridges app-level state into the visible tabs: Today receives only
// entries for the active local calendar day, while Stats receives the full
// drink history for debugging and persistence validation.
//
// Notes:
// WateredTabView currently sits at the boundary between SwiftUI navigation,
// SwiftData persistence, and WateredStore. It hydrates the store from persisted
// entries, saves new Add Drink submissions, and refreshes Today when iOS reports
// a significant time change.
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
        case stats = "Stats"
    }
    
    // Purpose: Stores the currently selected top-level app tab.
    //
    // UI role: Lets WateredTabView show app-level UI only when it belongs to the
    // active tab.
    @State private var selectedTab: WateredTab = .today

    // MARK: - Settings State
    //
    // Purpose: Stores the display unit selected for the app.
    //
    // UI role:
    // Stores the display unit currently applied across Watered's top-level views.
    // TodayView uses it to format volume summaries, AddDrinkView uses it as the
    // default logging unit, and ProfileView can change it through a binding.
    //
    // Persistence role:
    // Starts from Watered's locale-aware defaults, then gets replaced by persisted
    // settings when a saved setting exists.
    @State private var displayUnit: LiquidUnit = AppSettings.defaults().displayUnit
    
    // Purpose:
    // Stores the daily hydration goal currently applied to Today.
    //
    // UI role:
    // TodayView uses this goal to calculate and display hydration progress,
    // remaining hydration, and goal-reached states.
    //
    // Persistence role:
    // Starts from Watered's first-run defaults, then gets replaced by persisted
    // settings when a saved goal exists.
    @State private var dailyHydrationGoal = AppSettings.defaults().dailyHydrationGoal

    // Purpose: Stores Watered's first app-level state owner.
    //
    // UI role:
    // Keeps drink entries above the tab views without making WateredTabView
    // directly own or mutate the entries array.
    @State private var store = WateredStore()
    
    // Purpose:
    // Stores the local calendar day currently shown by Today.
    //
    // Notes:
    // Lets Today render a day-specific view while WateredStore keeps the full
    // persisted drink history.
    @State private var activeCalendarDay = TodayCalendarDay()
    
    // MARK: - Persistence
    //
    // Purpose:
    // Gives WateredTabView access to the SwiftData context supplied by WateredApp.
    //
    // UI role:
    // Lets the Add Drink submission boundary save new drink entries.
    @Environment(\.modelContext) private var modelContext
    
    // Purpose:
    // Reads persisted drink entries from SwiftData.
    //
    // UI role:
    // Lets WateredTabView hydrate WateredStore when the app starts.
    @Query(sort: \PersistentDrinkEntry.loggedAt) private var persistentDrinkEntries: [PersistentDrinkEntry]
    
    // Purpose:
    // Reads persisted app settings from SwiftData.
    //
    // UI role:
    // Lets WateredTabView hydrate app-level settings, such as display unit and
    // daily hydration goal, when the app starts.
    @Query private var persistentAppSettings: [PersistentAppSettings]

    // Purpose: Controls whether the Add Drink sheet is visible.
    //
    // UI role:
    // Keeps AddDrinkView out of the tab bar while still allowing it to appear as a
    // focused add-drink flow above the current tab.
    @State private var isShowingAddDrinkSheet = false

    // Purpose: Controls whether the Profile sheet is visible.
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
    private var todayCalendarSymbolName: String {
        let dayOfMonth = activeCalendarDay.calendar.component(.day, from: Date())
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
        let hasNoDrinks = todayEntries.isEmpty

        return isTodaySelected && hasNoDrinks
    }
    
    // Purpose:
    // Returns the drink entries that belong to the active Today calendar day.
    //
    // Returns:
    // DrinkEntry values from WateredStore whose loggedAt date falls on the same
    // local calendar day as activeCalendarDay.
    //
    // UI role:
    // Keeps Today scoped to one day without deleting previous-day entries from
    // persistence or app state.
    private var todayEntries: [DrinkEntry] {
        return store.drinkEntries(
            for: activeCalendarDay.date,
            calendar: activeCalendarDay.calendar
        )
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
                    entries: todayEntries,
                    displayUnit: displayUnit,
                    onOpenProfile: openProfile,
                    dailyGoal: dailyHydrationGoal,
                )
                    .tabItem {
                        Label("Today", systemImage: todayCalendarSymbolName)
                    }
                    .tag(WateredTab.today)

                LearnView(
                    onOpenProfile: openProfile,
                    entries:store.entries
                )
                    .tabItem {
                        Label("Stats", systemImage: "chart.bar")
                    }
                    .tag(WateredTab.stats)
            }
            .onChange(of: displayUnit) { previousUnit, newUnit in
                wateredLog("Display unit changed from \(previousUnit.rawValue) to \(newUnit.rawValue)")
                saveDisplayUnit(newUnit)
            }
            .onChange(of: dailyHydrationGoal.amount.value) { previousGoalValue, newGoalValue in
                wateredLog(
                    "Daily hydration goal changed from \(Int(previousGoalValue)) \(dailyHydrationGoal.amount.unit.rawValue) to \(Int(newGoalValue)) \(dailyHydrationGoal.amount.unit.rawValue)"
                )
                saveDailyHydrationGoal(dailyHydrationGoal)
            }
            .onChange(of: selectedTab) { previousTab, newTab in
                wateredLog("Selected tab changed from \(previousTab.rawValue) to \(newTab.rawValue)")
            }
            .onAppear {
                loadPersistedDrinkEntries()
                loadPersistedAppSettings()
            }
            .onChange(of: persistentDrinkEntries) {
                loadPersistedDrinkEntries()
            }
            .onReceive(
                NotificationCenter.default.publisher(
                    for: UIApplication.significantTimeChangeNotification
                )
            ) { _ in
                refreshActiveCalendarDay()
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
            ProfileView(
                displayUnit: $displayUnit,
                dailyHydrationGoal: $dailyHydrationGoal
            )
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
        
        wateredLog("Persistence read finished with \(loadedEntries.count) drink entries")
        store.loadDrinkEntries(loadedEntries)
    }
    
    // Purpose:
    // Loads persisted app settings into Watered's app-level UI state.
    //
    // Behavior:
    // Uses the first valid settings row when one exists. If no valid settings row
    // exists, Watered keeps the locale-aware first-run defaults already stored in
    // local state.
    private func loadPersistedAppSettings() {
        guard let persistentSettings = persistentAppSettings.first else {
            wateredLog("Settings read found no persisted settings; using first-run defaults.")
            return
        }
        
        guard let appSettings = persistentSettings.appSettings() else {
            wateredLog("Settings read found stored settings that could not be mapped; using first-run defaults.")
            return
        }
        
        displayUnit = appSettings.displayUnit
        dailyHydrationGoal = appSettings.dailyHydrationGoal
        wateredLog(
            "Settings loaded with display unit \(displayUnit.rawValue) and daily hydration goal \(dailyHydrationGoal.amount.formatted)"
        )
    }
    
    // Purpose:
    // Saves the selected display unit to Watered's persisted app settings.
    //
    // Input:
    // Accepts the display unit selected from Profile.
    //
    // Behavior:
    // Updates the existing settings row when one exists, or creates a new settings
    // row using Watered's current first-run defaults when settings have not yet
    // been persisted.
    private func saveDisplayUnit(_ displayUnit: LiquidUnit) {
        let settings = persistentAppSettings.first ?? PersistentAppSettings(
            appSettings: AppSettings(
                displayUnit: displayUnit,
                dailyHydrationGoal: dailyHydrationGoal
            )
        )
        
        settings.displayUnitID = displayUnit.persistenceIdentifier
        settings.updatedAt = Date()
        
        if persistentAppSettings.isEmpty {
            modelContext.insert(settings)
            wateredLog("Settings created with display unit \(displayUnit.rawValue)")
        } else {
            wateredLog("Settings updated with display unit \(displayUnit.rawValue)")
        }
    }
    
    // Purpose:
    // Saves the selected daily hydration goal to Watered's persisted app settings.
    //
    // Input:
    // Accepts the daily hydration goal selected from Profile.
    //
    // Behavior:
    // Updates the existing settings row when one exists, or creates a new settings
    // row using Watered's current app-level settings when settings have not yet
    // been persisted.
    private func saveDailyHydrationGoal(_ dailyHydrationGoal: HydrationGoal) {
        let settings = persistentAppSettings.first ?? PersistentAppSettings(
            appSettings: AppSettings(
                displayUnit: displayUnit,
                dailyHydrationGoal: dailyHydrationGoal
            )
        )
        
        settings.dailyGoalValue = dailyHydrationGoal.amount.value
        settings.dailyGoalUnitID = dailyHydrationGoal.amount.unit.persistenceIdentifier
        settings.updatedAt = Date()
        
        if persistentAppSettings.isEmpty {
            modelContext.insert(settings)
            wateredLog("Settings created with daily hydration goal \(dailyHydrationGoal.amount.formatted)")
        } else {
            wateredLog("Settings updated with daily hydration goal \(dailyHydrationGoal.amount.formatted)")
        }
    }
    
    // Purpose: Adds a real drink entry submitted from the Add Drink form.
    //
    // Input:
    // Receives the DrinkEntry created by AddDrinkView from the selected drink type,
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
    
    // Purpose:
    // Refreshes the local calendar day shown by Today.
    //
    // Behavior:
    // Updates activeCalendarDay after iOS reports a significant time change, such
    // as midnight, daylight saving changes, or manual clock updates.
    private func refreshActiveCalendarDay() {
        activeCalendarDay.refresh()
        wateredLog(
            "Active Today calendar day refreshed to \(activeCalendarDay.date.formatted(date: .complete, time: .shortened))"
        )
    }
}

#Preview {
    WateredTabView()
}
