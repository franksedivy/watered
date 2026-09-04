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
            ForEach(rows, id: \.consumedText) { drinkBreakdownRow in
                VStack(alignment: .leading, spacing: 2) {
                    Text(drinkBreakdownRow.consumedText)
                    
                    Text(drinkBreakdownRow.hydrationImpactText)
                        .font(.caption)
                        .fontWeight(fontWeight(for: drinkBreakdownRow.hydrationImpactStyle))
                        .foregroundStyle(foregroundStyle(for: drinkBreakdownRow.hydrationImpactStyle))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .accessibilityElement(children: .combine)
    }
    
    // Purpose: Choses the color used for a breakdown row's hydration impact
    //
    // Input: Accepts the semantic hydration impact style prepared by
    // HydrationSummaryViewData
    //
    // Returns:
    // A SwiftUI Color used by the hydration impact label.
    //
    // UI role:
    // Gives positive, reduced, negative, and unknown  hydration impact states a clear
    // visual distinction while keeping the color decision in one place.
    private func foregroundStyle(for style: HydrationImpactStyle) -> Color {
        switch style {
        case .positive:
            return .green
        case .reduced:
            return .orange
        case .negative:
            return .red
        case .unknown:
            return .secondary
        }
    }
    
    // MARK: - Hydration Impact Styling
    //
    // Purpose:
    // Chooses a basic visual weight for a breakdown row's hydration impact.
    //
    // Input:
    // Accepts the semantic hydration impact style prepared by
    // HydrationSummaryViewData.
    //
    // Returns: A SwiftUI Font.Weight used by the hydration impact label.
    //
    // UI role:
    // Gives the UI a visible distinction between known and unknown impact states
    // without introducing hardcoded colours before the app has semantic color tokens.
    private func fontWeight(for style: HydrationImpactStyle) -> Font.Weight {
        switch style {
        case .positive:
            return .regular
        case .reduced:
            return .semibold
        case .negative:
            return .bold
        case .unknown:
            return .regular
        }
    }
}

#Preview {
    TodayDrinkBreakdownView(
        rows: [
            DrinkBreakdownViewData(
                consumedText: "1200 ml of water",
                hydrationImpactText: "Hydration impact: 100%",
                hydrationImpactStyle: .positive
            ),
            DrinkBreakdownViewData(
                consumedText: "330 ml of beer",
                hydrationImpactText: "Hydration impact: 50%",
                hydrationImpactStyle: .reduced
            )
        ]
    )
    .padding()
    .background(Color.blue)
}
