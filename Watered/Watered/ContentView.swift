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
        VStack(alignment: .leading, spacing: 24) {
            headerSection
            summarySection
            drinkBreakdownSection
            prototypeControlsSection
            
            Spacer()
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
    
    private var prototypeControlsSection: some View {
        Button(action: addDemoDrink) {
            Label("Add random drink", systemImage: "plus")
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    ContentView()
}
