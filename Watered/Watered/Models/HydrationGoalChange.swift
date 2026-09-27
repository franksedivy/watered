//
//  HydrationGoalChange.swift
//  Watered
//
//  Created by Frank Sedivy on 27/09/2026.
//

import Foundation

/// Records a hydration goal when it is first established or subsequently changed
///
/// This is an immutable app-model value, independent of SwiftData. Profile will eventually create one record for its final commited
/// goal, rather than for intermediate stepper values.
nonisolated struct HydrationGoalChange: Identifiable {
    
    /// The stable identity preserved when this record is saved and loaded
    let id: UUID
    
    /// The goal established by this change, including its amount and unit.
    let goal: HydrationGoal
    
    /// When this goal was committed, independent of updates to other settings.
    let changedAt: Date
    
    /// Whether the goal came from the app default, a user choise, or a calculation.
    let source: HydrationGoalSource
    
    /// Creates a history record without performing any persistence.
    ///
    /// - Parameters:
    ///  - goal: The hydration goal established by this change.
    ///  - ID: The record's existing identity when loading, or a new UUID when creating it.
    ///  - changedAt: The time the goal was committed.
    ///  - source: How the goal was established.
    init(
        id: UUID = UUID(),
        goal: HydrationGoal,
        changedAt: Date,
        source: HydrationGoalSource
    ) {
        self.id = id
        self.goal = goal
        self.changedAt = changedAt
        self.source = source
    }
}
