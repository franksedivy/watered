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
            
            print("[Watered UI] Drink count: \(tracker.entries.count)")
            print("[Watered UI] Total: \(Int(tracker.totalMilliliters.rounded())) ml")
            print("[Watered UI] Goal: \(Int(tracker.dailyGoal.volumeInMilliliters.rounded())) ml")
            print("[Watered UI] Remaining: \(Int(tracker.remainingMilliliters.rounded())) ml")
        }
    }
}

#Preview {
    ContentView()
}
