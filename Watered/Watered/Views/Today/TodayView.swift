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
    // Stores the temporary drink entries shown by the 0.2 Today screen.
    //
    // UI role:
    // This is the only mutable source of truth in this view. When entries changes,
    // SwiftUI recalculates the tracker, summary and visible screen content.
    @State private var entries: [DrinkEntry] = []
    
    // MARK: - Temporary Configuration
    
    // Purpose: Stores fixed values used by the temporary 0.2 release.
    //
    // Notes:
    // These values are not user settings yet. The daily goal, display unit and demo
    // drink source are hardcoded while the Today screen is being built.
    private let dailyGoal = HydrationGoal(
        amount: DrinkAmount(value: 2700, unit: .milliliters)
    )
    
    private let volumeFormatter = VolumeFormatter()
    private let progressFormatter = ProgressFormatter()
    private let displayUnit: LiquidUnit = .milliliters
    private let demoDrinkSource = TodayDemoDrinkSource()
    
    // MARK: - Appearance
    //
    // Purpose:
    // Stores parent-level styling values for the Today screen
    //
    // UI role/:
    // TodayView applies these values, but TodayAppearance owns the actual visual
    // constants such as background gradients, screen padding and shared control tint.
    private let appearance = TodayAppearance()
    
    // MARK: - Calculated Display Data

    // Purpose:
    // Builds the hydration tracker for the current temporary Today entries.
    //
    // Input:
    // Uses entries from the view's temporary screen state and daily goal.
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
    
    // Purpose: Converts the current tracker snapshot into display-ready values.
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
        appearance.backgroundGradient(for: todayScreenMode)
    }
    
    // Purpose: Decides which Today screen mode should be displayed.
    // Input: Uses the temporary entries count and the calculated hydration progress.
    // Returns: A TodayScreenMode value.
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
    
    // Purpose: Defines the high-level shell for the Today screen.
    //
    // UI role:
    // Keeps the page structure in one place: scrollable content at the top and the
    // temporary control pinned to the bottom safe area.
    var body: some View {
        NavigationStack {
            ZStack {
                screenBackgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        todayContentSection
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, appearance.screenHorizontalPadding)
                    .padding(.top, 16)
                    .padding(.bottom, 120)
                }
            }
            .foregroundStyle(.white)
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                TodayToolbar()
            }
            .toolbarBackground(Color.clear, for: .navigationBar)
            
            .safeAreaInset(edge: .bottom) {
                WateredTabBar(
                    glassTint: appearance.controlGlassTint,
                    onAddDrink: addDemoDrink
                )
                .padding(.horizontal, appearance.bottomBarHorizontalPadding)
                .padding(.bottom, appearance.bottomBarBottomPadding)
            }
        }
    }

    // MARK: - Actions
    
    // Purpose:
    // Adds one temporary random demo drink.
    //
    // Input:
    // Uses TodayDemoDrinkSource to create a random demo entry.
    //
    // Behavior:
    // If the source returns an entry, the entry is appended to the temporary entries
    // state. SwiftUI then recalculates the tracker, snapshot and summary.
    //
    // Notes:
    // This is temporary behaviour. It is not persistence and not the final
    // drink logging flow.
    private func addDemoDrink() {
        wateredLog("Add demo drink button tapped")
        
        guard let entry = demoDrinkSource.randomEntry() else {
            return
        }
        
        wateredLog("Adding demo drink: \(entry.amount) of \(entry.type)")
        entries.append(entry)
    }
    
    // MARK: - Screen Content

    // Purpose: Selects the main content section for the current Today screen mode.
    // Input: Uses todayScreenMode.
    // Returns: The SwiftUI content for the selected mode.
    //
    // UI role:
    // Keeps conditional screen routing out of body. Each mode can gradually get its
    // own section without turning body into a chain of if statements.
    @ViewBuilder
    private var todayContentSection: some View {
        switch todayScreenMode {
        case .empty:
            EmptyTodayView()
        case .firstDrink:
            FirstDrinkTodayView(summary: summary)
        case .inProgress:
            InProgressTodayView(drinkCount: entries.count, summary: summary)
        case .goalReached:
            GoalReachedTodayView(summary: summary)
        }
    }
}

#Preview {
    TodayView()
}
