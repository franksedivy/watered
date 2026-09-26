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
    
    // Purpose:
    // Requests deletion of a drink without owning persistence logic.
    //
    // Input:
    // Supplied by the parent' accepts the selected drink's UUID.
    //
    // Behavior:
    // Throws if saving fails so the detail screen can present an error.
    let onDeleteDrink: (UUID) throws -> Void
    
    // Returns to the Stats list after successful deletion.
    @Environment(\.dismiss) private var dismiss
    
    // Controls confirmation before deleting the selected drink.
    @State private var isConfirmingDeletion = false
    
    // Presents an error if the parent cannot complete deletion.
    @State private var isShowingDeletionError = false
    
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
            Section {
                Button(role: .destructive) {
                    isConfirmingDeletion = true
                } label: {
                    Label("Delete drink", systemImage: "trash")
                }
                .accessibilityIdentifier("deleteDrinkButton")
                
                .confirmationDialog(
                    "Delete this drink?",
                    isPresented: $isConfirmingDeletion,
                    titleVisibility: .visible
                ) {
                    Button("Delete drink", role: .destructive) {
                        do {
                            try onDeleteDrink(entry.id)
                            dismiss()
                        } catch {
                            wateredLog("Stats deletion failed for \(entry.id): \(error.localizedDescription)")
                            isShowingDeletionError = true
                        }
                    }
                    
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Delete \(entry.amount.formatted) of \(entry.type.rawValue). This can't be undone.")
                }
                .alert(
                    "Could not delete drink",
                    isPresented: $isShowingDeletionError
                ) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text("The drink could not be deleted.")
                }
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
            ),
            onDeleteDrink: { entryID in
                wateredLog("Preview deletion requested for \(entryID)")
            }
        )
    }
}
