//
//  ContentView.swift
//  Watered
//
//  Created by Frank Sedivy on 26/06/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
          
        }
        .onAppear(){
            let water = DrinkEntry(
                type: .water,
                amount: DrinkAmount(value: 250, unit: .milliliters),
                date: Date()
            )
            
            let juice = DrinkEntry(
                type: .juice,
                amount: DrinkAmount(value: 8, unit: .imperialFluidOunces),
                date: Date()
            )
            
            let goal = HydrationGoal(
                amount: DrinkAmount(value: 2000, unit: .milliliters)
            )
            
            let tracker = HydrationTracker(
                entries: [water, juice],
                dailyGoal: goal
            )
            
            let formatter = VolumeFormatter()
            let snapshot = tracker.snapshot
            let progressFormatter = ProgressFormatter()
            
            print("[Watered UI] Drink count: \(snapshot.drinkCount)")
            print("[Watered UI] Total \(formatter.wholeNumberString(from: snapshot.totalVolume))")
            print("[Watered UI] Goal: \(formatter.wholeNumberString(from: snapshot.goalVolume))")
            print("[Watered UI] Remaining: \(formatter.wholeNumberString(from: snapshot.remainingVolume))")
            print("[Watered UI] Progress: \(progressFormatter.percentageString(from: snapshot.progress))")
        }
    }
}

#Preview {
    ContentView()
}
