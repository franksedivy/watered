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
