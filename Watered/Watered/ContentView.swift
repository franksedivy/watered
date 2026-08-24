//
//  ContentView.swift
//  Watered
//
//  Created by Frank Sedivy on 26/06/2026.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Temporary State
    @State private var entries: [DrinkEntry] = []
    
    // MARK: - Temporary Configuration
    private let dailyGoal = HydrationGoal(
        amount: DrinkAmount(value: 2700, unit: .milliliters)
    )
    
    private let volumeFormatter = VolumeFormatter()
    private let progressFormatter = ProgressFormatter()
    private let displayUnit: LiquidUnit = .milliliters
    private let demoDrinkSource = TodayDemoDrinkSource()
    
    // MARK: - Derived Model Values
    private var tracker: HydrationTracker {
        HydrationTracker(
            entries: entries,
            dailyGoal: dailyGoal
        )
    }
    
    private var summary: HydrationSummaryViewData {
        HydrationSummaryViewData(
            snapshot: tracker.snapshot,
            volumeFormatter: volumeFormatter,
            progressFormatter: progressFormatter,
            displayUnit: displayUnit
        )
    }
    
    // MARK: - Today Screen State
    private enum TodayScreenState {
        case empty
        case firstDrink
        case inProgress
        case goalReached
    }
    
    private var todayScreenState: TodayScreenState {
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
    
    // MARK: - Prototype Actions
    
    // Purpose:
    // Adds one temporary random demo drink to the Today screen prototype.
    //
    // Behavior:
    // Asks TodayDemoDrinkSource for a random DrinkEntry. If one is returned, the
    // entry is appended to the view's temporary entries state. SwiftUI then
    // recalculates the derived tracker, snaposhot and summary.
    private func addDemoDrink() {
        guard let entry = demoDrinkSource.randomEntry() else {
            return
        }
        
        entries.append(entry)
    }
    
    // MARK: - Body
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
    
    private var prototypeControlsSection: some View {
        Button(action: addDemoDrink) {
            Label("Add random drink", systemImage: "plus")
        }
        .buttonStyle(.borderedProminent)
    }
    
    @ViewBuilder
    private var todayContentSection: some View {
        switch todayScreenState {
        case .empty:
            emptyStateSection
        case .firstDrink:
            summarySection
            drinkBreakdownSection
        case .inProgress:
            summarySection
            drinkBreakdownSection
        case .goalReached:
            summarySection
            drinkBreakdownSection
        }
    }
}

#Preview {
    ContentView()
}
