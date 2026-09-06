//
//  StatsDrinkEntryDetailView.swift
//  Watered
//
//  Created by Frank Sedivy on 06/09/2026.
//

import SwiftUI

// MARK: - Stats Drink Entry Detail view
//
// Purpose:
// Shows the raw data Watered currently has for one drink entry.
//
// Input:
// Accepts a DrinkEntry selected from the temporary Stats tab.
//
// UI role:
// Gives the 0.4 persistence work a rough debugging surface so stored drink data,
// dates, identifiers, and source metadata can be inspected in the app.
struct StatsDrinkEntryDetailView: View {
    let entry: DrinkEntry
    
    var body: some View {
        List {
            Section("Drink") {
                LabeledContent("Type", value: entry.type.rawValue)
                LabeledContent("Amount", value: entry.amount.formatted)
                LabeledContent("Source", value: entry.source.rawValue)
            }
            
            Section("Identity") {
                LabeledContent("ID", value: entry.id.uuidString)
            }
            
            Section("Dates") {
                LabeledContent("Logged at", value: entry.loggedAt.formatted(date: .complete, time: .complete))
                LabeledContent("Created at", value: entry.createdAt.formatted(date: .complete, time: .complete))
                LabeledContent("Updated at", value: entry.updatedAt.formatted(date: .complete, time: .complete))
            }
        }
        .navigationTitle(entry.type.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        StatsDrinkEntryDetailView(
            entry: DrinkEntry(
                type: .water,
                amount: DrinkAmount(value: 300, unit: .milliliters),
                date: Date()
            )
        )
    }
}
