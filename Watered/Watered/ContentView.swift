//
//  ContentView.swift
//  Watered
//
//  Created by Frank Sedivy on 26/06/2026.
//

import SwiftUI

struct ContentView: View {
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
                )
            ],
            dailyGoal: HydrationGoal(
                amount: DrinkAmount(value: 2000, unit: .milliliters)
            )
        ).snapshot,
        volumeFormatter: VolumeFormatter(),
        progressFormatter: ProgressFormatter()
    )
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Watered")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Today")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text(summary.progressText)
                    .font(.system(size: 48, weight: .bold))
                
                ProgressView(value: summary.progressValue)
                
                Text(summary.totalText)
                Text(summary.goalText)
                Text(summary.remainingText)
                Text(summary.drinkCountText)
            }
            
            Spacer()
        }
        .padding()
    }
    
}

#Preview {
    ContentView()
}
