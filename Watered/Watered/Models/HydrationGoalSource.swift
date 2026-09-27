//
//  HydrationGoalSource.swift
//  Watered
//
//  Created by Frank Sedivy on 27/09/2026.
//

/// Describes how a hydration goal was established.
/// Stored alongside each historical goal so future reporting can distinguish the app's starting value from a user's choice or a
/// calcualted recommendation.
///
/// The raw strings are persistence identifiers and should remain stable.
nonisolated enum HydrationGoalSource: String {
    
    /// The starting goal supplied by the app.
    case appDefault
    
    /// A goal explicitli chosen by the user.
    case manual
    
    /// A goal produced by a calculation.
    ///
    /// Reserved for future personalised goal calculation; this case does not implement or validate that calculation.
    case calculated
}
