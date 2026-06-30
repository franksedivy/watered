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
            print("[Watered] Drink amount: \(amount.formatted)")
        }
    }
}

#Preview {
    ContentView()
}
