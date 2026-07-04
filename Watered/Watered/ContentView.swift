//
//  ContentView.swift
//  Watered
//
//  Created by Frank Sedivy on 26/06/2026.
//

import SwiftUI

struct ContentView: View {
    private let snapshot = HydrationTracker(
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
    ).snapshot
    
    private let volumeFormatter = VolumeFormatter()
    private let progressFormatter = ProgressFormatter()
    
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
                Text("Total: \(volumeFormatter.wholeNumberString(from: snapshot.totalVolume))")
                Text("Goal: \(volumeFormatter.wholeNumberString(from: snapshot.goalVolume))")
                Text("Remaining \(volumeFormatter.wholeNumberString(from: snapshot.remainingVolume))")
                Text("Drinks logged: \(snapshot.drinkCount)")
            }
            .font(.title3)
            
            Spacer()
        }
        .padding()
    }
    
}

#Preview {
    ContentView()
}
