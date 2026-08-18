//
//  ContentView.swift
//  Watered
//
//  Created by Frank Sedivy on 26/06/2026.
//

import SwiftUI

struct ContentView: View {
    // MARK: - TEMPORARY Sample data
    private let summary = HydrationSummaryViewData(
        snapshot: HydrationTracker(
            entries: [
                DrinkEntry(
                    type: .water,
                    amount: DrinkAmount(value: 250, unit: .milliliters),
                    date: Date()
                ),
                DrinkEntry(
                    type: .juice,
                    amount: DrinkAmount(value: 8, unit: .imperialFluidOunces),
                    date: Date()
                ),
                DrinkEntry(
                    type: .coffee,
                    amount: DrinkAmount(value: 200, unit: .milliliters),
                    date: Date()
                )
            ],
            dailyGoal: HydrationGoal(
                amount: DrinkAmount(value: 2000, unit: .milliliters)
            )
        ).snapshot,
        volumeFormatter: VolumeFormatter(),
        progressFormatter: ProgressFormatter(),
        displayUnit: .imperialFluidOunces
    )
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            headerSection
            summarySection
            drinkBreakdownSection
            
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
            ForEach(summary.drinkBreakdownTexts, id: \.self) { drinkBreakdownText in
                Text(drinkBreakdownText)
            }
        }
    }
    
}

#Preview {
    ContentView()
}
