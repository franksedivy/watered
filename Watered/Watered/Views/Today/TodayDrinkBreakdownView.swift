//
//  TodayDrinkBreakdownView.swift
//  Watered
//
//  Created by Frank Sedivy on 27/08/2026.
//

import SwiftUI

// MARK: - Today Drink Breakdown View
//
// Purpose:
// Displays the grouped drink breakdwon for the Today screen.
//
// Input:
// Accepts display-ready drink breakdwon rows from HydrationSummaryViewData.
//
// Returns:
// A SwiftUI view containing a section title and one row for each grouped drink
// type.
//
// UI role:
// Keeps drink breakdown presentation separate from TodayView. This view does not
// group drinks, calcula totals, or format hyt values.
struct TodayDrinkBreakdownView: View {
    let rows: [DrinkBreakdownViewData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Drink breakdown")
                .font(.headline)
            ForEach(rows, id: \.consumedText) { drinkBreakdownRow in
                VStack(alignment: .leading, spacing: 2) {
                    Text(drinkBreakdownRow.consumedText)
                    
                    Text(drinkBreakdownRow.hydrationImpactText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    TodayDrinkBreakdownView(
        rows: [
            DrinkBreakdownViewData(
                consumedText: "1200 ml of water",
                hydrationImpactText: "Hydration impact: 1200 ml"
            ),
            DrinkBreakdownViewData(
                consumedText: "330 ml of beer",
                hydrationImpactText: "Hydration impact: 165 ml"
            )
        ]
    )
    .padding()
    .background(Color.blue)
}
