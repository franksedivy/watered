//
//  ProfileView.swift
//  Watered
//
//  Created by Frank Sedivy on 30/08/2026.
//

import SwiftUI

// MARK: - Profile View
//
// Purpose:
// Shows the temporary Profile screen.
//
// Returns:
// A blank SwiftUI screen inside its own navigation stack.
//
// UI role:
// Gives the persistent FS profile button a real destination. For now this is an
// empty sheet, but later it can grow into account details, preferences, HealthKit
// permissions, display units, and other profile-level settings.
struct ProfileView: View {
    
    // Purpose: Stores the selected display unit for volume values.
    //
    // Input:
    // Supplied as a binding from WateredTabView, where temporary app-level display
    // unit state currently lives.
    //
    // UI role:
    // Allows Profile to change the app's display unit without owning the setting.
    @Binding var displayUnit: LiquidUnit
    
    // Purpose:
    // Stores the selected daily hydration goal.
    //
    // Input:
    // Supplied as a binding from WateredTabView, where app-level settings state
    // currently lives.
    //
    // UI role:
    // Allows Profile to change the goal used by Today without owning the setting.
    @Binding var dailyHydrationGoal: HydrationGoal
    
    #if DEBUG
    // MARK: - Developer Actions
    //
    // Purpose:
    // Lets Profile request deletion of all saved drinks.
    //
    // Input:
    // Supplied by the parent, which owns persistence and app state. Previews can
    // omit this action.
    //
    // Behavior:
    // The action throws if deletion fails, allowing Profile to show an error.
    // A missing action means the reset control should not be displayed.
    var onDeleteAllDrinks: (() throws -> Void)? = nil
    
    // Controls confirmation before deleting the entire drink history.
    @State private var isConfirmingDrinkReset = false
    
    // Presents an error when the parent cannot complete the deletion.
    @State private var isShowingDrinkResetError = false
    
    // Dismisses the Profile sheet after a successful drink-history reset.
    @Environment(\.dismiss) private var dismiss
    #endif
    
    // Purpose:
    // Bridges the HydrationGoal model into a numberic Profile form control.
    //
    // Returns:
    // A binding to the goal amount value while preserving the goal unit.
    private var dailyHydrationGoalValue: Binding<Double> {
        Binding(
            get: {
                dailyHydrationGoal.amount.value
            },
            set: { newValue in
                    dailyHydrationGoal = HydrationGoal(
                        amount: DrinkAmount(
                            value: newValue,
                            unit: dailyHydrationGoal.amount.unit
                        )
                    )
            }
        )
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Display units") {
                    Picker("Volume unit", selection: $displayUnit) {
                        ForEach(LiquidUnit.allCases) { liquidUnit in
                            Text(liquidUnit.rawValue)
                                .tag(liquidUnit)
                        }
                    }
                    .pickerStyle(.segmented)
                    .accessibilityHint("Changes the volume unit used across Watered.")
                }
                Section("Hydration goal") {
                    Stepper(
                        value: dailyHydrationGoalValue,
                        in: 500...5000,
                        step: 100
                    ) {
                        Text("Daily goal: \(dailyHydrationGoal.amount.formatted)")
                    }
                    .accessibilityHint("Changes the daily hydration goal used by Today.")
                }
                
                #if DEBUG
                if let deleteAllDrinks = onDeleteAllDrinks {
                    Section("Developer Tools") {
                        Button("Delete all drinks", role: .destructive) {
                            isConfirmingDrinkReset = true
                        }
                        .accessibilityIdentifier("deleteAllDrinksButton")
                    }
                    .confirmationDialog(
                        "Delete all drinks?",
                        isPresented: $isConfirmingDrinkReset,
                        titleVisibility: .visible
                    ) {
                        Button("Delete all drinks", role: .destructive) {
                            do {
                                try deleteAllDrinks()
                                dismiss()
                            } catch {
                                wateredLog("Profile reset failed: \(error.localizedDescription)")
                                isShowingDrinkResetError = true
                            }
                        }
                        
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("This permanently deletes your entire drink history. Are you sure?")
                    }
                    .alert(
                        "Could not delete drinks",
                        isPresented: $isShowingDrinkResetError
                    ) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text("Your drink history could not be deleted.")
                    }
                }
                #endif
            }
            .navigationTitle("Profile")
            .accessibilityIdentifier("profileScreen")
        }
    }
}

#Preview {
    ProfileView(
        displayUnit: .constant(.milliliters),
        dailyHydrationGoal: .constant(
            HydrationGoal(
                amount: DrinkAmount(value: 2700, unit: .milliliters)
            )
        )
    )
}
