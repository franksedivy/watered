//
//  ContentView.swift
//  Watered
//
//  Created by Frank Sedivy on 26/06/2026.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Temporary State
    
    // Purpose:
    // Stores the temporary drink entries shown by the 0.2 Today screen prototype.
    //
    // UI role:
    // This is the only mutable source of truth in this view. When entries changes,
    // SwiftUI recalculates the tracker, summary and visible screen content.
    @State private var entries: [DrinkEntry] = []
    
    // MARK: - Temporary Configuration
    
    // Purpose:
    // Stores fixed values used by the temporary 0.2 prototype.
    //
    // Notes:
    // These values are not user settings yet. The daily goal, display unit and demo
    // drink source are hardcoded while the Today screen prototype is being built.
    private let dailyGoal = HydrationGoal(
        amount: DrinkAmount(value: 2700, unit: .milliliters)
    )
    
    private let volumeFormatter = VolumeFormatter()
    private let progressFormatter = ProgressFormatter()
    private let displayUnit: LiquidUnit = .milliliters
    private let demoDrinkSource = TodayDemoDrinkSource()
    
    // MARK: - Calculated Display Data

    // Purpose:
    // Builds the hydration tracker for the current temporary Today entries.
    //
    // Input:
    // Uses entries from the view's temporary screen state and the prototype daily goal.
    //
    // Returns:
    // A HydrationTracker containing the current entries and goal.
    //
    // UI role:
    // The view does not calculate hydration totals directly. It asks the tracker to
    // produce the model state that will later be converted into display-ready text.
    private var tracker: HydrationTracker {
        HydrationTracker(
            entries: entries,
            dailyGoal: dailyGoal
        )
    }
    
    // Purpose:
    // Converts the current tracker snapshot into display-ready values.
    //
    // Input:
    // Uses the tracker snapshot, volume formatter, progress formatter and selected
    // display unit.
    //
    // Returns:
    // HydrationSummaryViewData containing text and progress values the SwiftUI view
    // can render directly.
    //
    // UI role:
    // Keeps formatting out of the visible SwiftUI sections so the screen can display
    // simple values rather than building labels and percentages inline.
    private var summary: HydrationSummaryViewData {
        HydrationSummaryViewData(
            snapshot: tracker.snapshot,
            volumeFormatter: volumeFormatter,
            progressFormatter: progressFormatter,
            displayUnit: displayUnit
        )
    }
    
    // MARK: - Today Screen State
    
    // The main display modes the Today screen currently knows how to show.
    private enum TodayScreenMode {
        case empty          // Empty screen when no drinks have been logged
        case firstDrink     // First drink has been logged, mostly used to celebrate engagement
        case inProgress     // Most common use when drinks are logged during the day
        case goalReached    // Used for when the user's hydration goal has been reached
    }
    
    // Purpose:
    // Decides which Today screen mode should be displayed.
    //
    // Input:
    // Uses the temporary entries count and the calculated hydration progress.
    //
    // Returns:
    // A TodayScreenMode value.
    //
    // UI role:
    // Keeps state selection in one place so the body can render from a clear mode
    // rather than scattering if statements through the layout.
    private var todayScreenMode: TodayScreenMode {
        if entries.isEmpty {
            return .empty
        }
        
        if summary.progressValue >= 1 {
            return .goalReached
        }
        
        if entries.count == 1 {
            return .firstDrink
        }
        
        return .inProgress
    }
    
    // MARK: - Body
    
    // Purpose:
    // Defines the high-level shell for the Today screen.
    //
    // UI role:
    // Keeps the page structure in one place: scrollable content at the top and the
    // temporary prototype control pinned to the bottom safe area.
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                headerSection
                todayContentSection
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .safeAreaInset(edge: .bottom) {
            prototypeControlsSection
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
        }
    }
    
    // MARK: - View Sections
    
    // Purpose:
    // Displays the fixed Today screen header.
    //
    // UI role:
    // Gives the screen its current app/title context. This section is shown for all
    // Today screen modes.
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Watered")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Today")
                .font(.headline)
                .foregroundStyle(.secondary)
            
        }
    }
    
    // Purpose:
    // Displays the current hydration summary.
    //
    // Input:
    // Uses HydrationSummaryViewData built from the current entries.
    //
    // UI role:
    // Shows display-ready values only. This section does not calculate totals,
    // progress or remaining hydration directly.
    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(summary.progressText)
                .font(.system(size: 48, weight: .bold))
            
            ProgressView(value: summary.progressValue)
            
            Text(summary.totalText)
            Text(summary.goalText)
            Text(summary.remainingText)
            Text(summary.drinkCountText)
        }
    }
    
    // Purpose:
    // Displays grouped drink breakdown rows.
    //
    // Input:
    // Uses summary.drinkBreakdownRows.
    //
    // UI role:
    // Shows the model-backed drink breakdown once drinks exist. This section is
    // hidden while the screen is in the empty mode.
    private var drinkBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Drink breakdown")
                .font(.headline)
            ForEach(summary.drinkBreakdownRows, id: \.consumedText) { drinkBreakdownRow in
                VStack(alignment: .leading, spacing: 2) {
                    Text(drinkBreakdownRow.consumedText)
                    Text(drinkBreakdownRow.hydrationImpactText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    // Purpose:
    // Displays the dedicated empty state when no drinks have been logged.
    //
    // Input:
    // Shown when todayScreenMode is .empty.
    //
    // UI role:
    // Replaces zero-value debug-style summary data with intentional empty-state copy.
    private var emptyStateSection: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("Pretty dry so far")
                .font(.system(size: 44, weight: .light))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            
            Text("No drinks logged yet today.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 120)
    }
    
    // Purpose:
    // Displays the first-drink state after the user logs their first drink.
    //
    // Input:
    // Uses summary values calculated from the single temporary drink entry.
    //
    // UI role:
    // Gives the first logged drink a distinct moment without changing the underlying
    // model or creating a real drink logging flow.
    private var firstDrinkStateSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("You  downed your frist drink! Nice")
                .font(.title3)
                .foregroundStyle(.secondary)
            
            summarySection
            drinkBreakdownSection
        }
    }
    
    // Purpose:
    // Displays the normal Today state once multiple dirnks have been logged.
    //
    // Input:
    // Uses summary value calculated form the current temporary drink entries.
    //
    // UI role:
    // Represents the main ongoing Today screen mode. This keeps the multiple-drink
    // state separate from first-drink and goal-reached presentation.
    private var inProgreessStateSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("You consumed \(entries.count) drinks:")
                .font(.title3)
                .foregroundStyle(.secondary)
            
            summarySection
            drinkBreakdownSection
        }
    }
    
    // MARK: - Prototype Controls

    // Purpose:
    // Displays temporary controls used while building the 0.2 prototype.
    //
    // UI role:
    // Lets the prototype create demo drinks without building the real add-drink flow.
    private var prototypeControlsSection: some View {
        Button(action: addDemoDrink) {
            Label("Add random drink", systemImage: "plus")
        }
        .buttonStyle(.borderedProminent)
    }
    
    // MARK: - Prototype Actions
    
    // Purpose:
    // Adds one temporary random demo drink to the Today screen prototype.
    //
    // Input:
    // Uses TodayDemoDrinkSource to create a random demo entry.
    //
    // Behavior:
    // If the source returns an entry, the entry is appended to the temporary entries
    // state. SwiftUI then recalculates the tracker, snapshot and summary.
    //
    // Notes:
    // This is prototype-only behaviour. It is not persistence and not the final
    // drink logging flow.
    private func addDemoDrink() {
        guard let entry = demoDrinkSource.randomEntry() else {
            return
        }
        
        entries.append(entry)
    }
    
    // MARK: - Screen Content

    // Purpose:
    // Selects the main content section for the current Today screen mode.
    //
    // Input:
    // Uses todayScreenMode.
    //
    // Returns:
    // The SwiftUI content for the selected mode.
    //
    // UI role:
    // Keeps conditional screen routing out of body. Each mode can gradually get its
    // own section without turning body into a chain of if statements.
    @ViewBuilder
    private var todayContentSection: some View {
        switch todayScreenMode {
        case .empty:
            emptyStateSection
        case .firstDrink:
            firstDrinkStateSection
        case .inProgress:
            inProgreessStateSection
        case .goalReached:
            summarySection
            drinkBreakdownSection
        }
    }
}

#Preview {
    ContentView()
}
