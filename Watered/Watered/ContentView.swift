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
            
            let tracker = HydrationTracker(entries: [water, juice])
            
            print("[Watered] Drink count: \(tracker.entries.count)")
            print("[Watered] Total: \(Int(tracker.totalMilliliters)) ml")
            
            
        }
    }
}

#Preview {
    ContentView()
}
