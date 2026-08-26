//
//  TodayView.swift
//  Watered
//
//  Created by Frank Sedivy on 26/08/2026.
//

import SwiftUI


struct TodayView: View {
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
    
    // MARK: - Prototype Styling
    
    // Purpose:
    // Defines key color treatment for core states of Today view
    private let screenHorizontalPadding: CGFloat = 16
    private let activeBackgroundGradient = LinearGradient(
        colors: [
            Color(red: 128.0 / 255.0, green: 195.0 / 255.0, blue: 243.0 / 255.0),   // #80C3F3
            Color(red:  74.0 / 255.0, green: 144.0 / 255.0, blue: 226.0 / 255.0)    // #4A90E2
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    private let emptyBackgroundGradient = LinearGradient(
        colors: [
            Color(red: 226.0 / 255.0, green: 196.0 / 255.0, blue: 84.0 / 255.0),    // #E2C454
            Color(red: 211.0 / 255.0, green: 166.0 / 255.0, blue: 41.0 / 255.0)     // #D3A629
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    private let controlGlassTint = Color.black.opacity(0.60)
    
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
    
    private var screenBackgroundGradient: LinearGradient {
        switch todayScreenMode {
        case .empty:
            return emptyBackgroundGradient
        case .firstDrink, .inProgress, .goalReached:
            return activeBackgroundGradient
        }
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
        
        if let actualProgressValue = summary.actualProgressValue {
            if actualProgressValue >= 1 {
                return .goalReached
            }
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
        ZStack {
            screenBackgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    TodayHeaderView(glassTint: controlGlassTint)
                    todayContentSection
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, screenHorizontalPadding)
                .padding(.top, 16)
                .padding(.bottom, 120)
            }
        }
        .foregroundStyle(.white)
        .safeAreaInset(edge: .bottom) {
            WateredTabBar(
                todaySymbolName: todayCalendarSymbolName,
                glassTint: controlGlassTint,
                onAddDrink: addDemoDrink
            )
            .padding(.horizontal, 22)
            .padding(.bottom, 8)
        }
    }
    
    // MARK: - View Sections
    
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
        VStack(alignment: .center, spacing: 14) {
            Text(summary.totalAmountText)
                .font(.system(size: 96, weight: .light))
            
            Text("Daily goal: \(summary.goalAmountText)")
                .font(.title3)
            
            progressSection
        }
    }
    
    // Purpose:
    // Displays hydration progress using a safe visual progress value.
    //
    // UI role:
    // Keeps the progress bar close to the committed design while using prepared
    // summary values rather than calculating progress inside the view.
    private var progressSection: some View {
        VStack(spacing: 4) {
            HStack(spacing: 8) {
                Text("0%")
                    .font(.caption)
                    .shadow(color: .black.opacity(0.20), radius: 4, x: 1, y: 1)
                
                ProgressView(value: summary.visualProgressValue)
                    .tint(.white)
                
                Text("100%")
                    .font(.caption)
                    .shadow(color: .black.opacity(0.20), radius: 4, x: 1, y: 1)
            }
            
            Text(summary.progressText)
                .font(.title2)
                .fontWeight(.semibold)
                .shadow(color: .black.opacity(0.20), radius: 4, x: 1, y: 1)
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
            Text("You downed your first drink! Nice")
                .font(.title3)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
            
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
    private var inProgressStateSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("You consumed \(entries.count) drinks:")
                .font(.title3)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
            
            summarySection
            drinkBreakdownSection
        }
    }
    
    // Purpose:
    // Displays the goal-reached state once the user reaches 100% of their hydration target.
    //
    // Input:
    // Uses summary values calculated from the current temporary drink entries.
    //
    // UI role:
    // Gives reaching 100% of the daily goal a distinct moment without changing the
    // underlying model or creating a real drink logging flow.
    private var goalReachedStateSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("You hit your goal! Fully watered.")
                .font(.title3)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
            
            summarySection
            drinkBreakdownSection
        }
    }
    
    // MARK: - Prototype Controls
    
    // Purpose:
    // Builds the SF Symbol name for today's calendar day.
    //
    // Returns:
    // A symbol name such as "1.calendar", "24.calendar", or "31.calendar".
    //
    // UI role:
    // Keeps the temporary Today tab placeholder matched to the actual day of the month.
    private var todayCalendarSymbolName: String {
        let dayOfMonth = Calendar.current.component(.day, from: Date())
        return "\(dayOfMonth).calendar"
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
        wateredLog("Add demo drink button tapped")
        
        guard let entry = demoDrinkSource.randomEntry() else {
            return
        }
        
        wateredLog("Adding demo drink: \(entry.type)")
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
            inProgressStateSection
        case .goalReached:
            goalReachedStateSection
        }
    }
}

#Preview {
    TodayView()
}
