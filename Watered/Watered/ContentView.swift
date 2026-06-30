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
            let amount = DrinkAmount(value: 250, unit: .milliliters)
            let entry = DrinkEntry(
                type: .water,
                amount: amount,
                date: Date()
            )
            
            print("[Watered] Drink entry created")
            print("[Watered] Type: \(entry.type.rawValue)")
            print("[Watered] Drink amount: \(amount.formatted)")
            print("[Watered] Date: \(entry.date)")
        }
    }
}

#Preview {
    ContentView()
}
