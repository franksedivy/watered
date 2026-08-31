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
    // Stores the drink entries that Today should display.
    //
    // Input:
    // Supplied by WateredTabView, which currently owns the temporary 0.2 demo state.
    //
    // UI role:
    // Makes TodayView a read-only summary screen. It displays the current entries,
    // but it no longer owns or changes them.
    let entries: [DrinkEntry]
    
    // Purpose:
    // Stores the liquid unit Today should use when displaying volume values.
    //
    // Input:
    // Supplied by WaterdTabView, which owns the temporary app-level display unit.
    //
    // UI role:
    // Lets Today display the same hydration model in different supported units
    // without owning the setting itself.
    let displayUnit: LiquidUnit
    
    // Purpose: Stores the action that opens the persistent profile sheet.
    // Input: Supplied by WateredTabView, which owns the profile sheet state.
    //
    // UI role:
    // Lets TodayView show the stared profile toolbar without owning profile
    // presentation itself.
    let onOpenProfile: () -> Void
    
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
        return HydrationSummaryViewData(
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
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ProfileToolbar(onOpenProfile: onOpenProfile)
            }
            .toolbarBackground(Color.clear, for: .navigationBar)
        }
        .accessibilityIdentifier("todayScreen")
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
    TodayView(entries: [], displayUnit: .milliliters, onOpenProfile: {})
}
