//
//  NoOpAnalyticsClient.swift
//  Watered
//
//  Created by Frank Sedivy on 02/10/2026.
//

/// Accepts analytics events without logging, storing, or transmitting them.
///
/// User this as the default when analytics reporting is disabled.
@MainActor
struct NoOpAnalyticsClient: AnalyticsClient {
    
    /// Discards the event without producing side effects.
    ///
    /// - Parameter event: The interaction intentionally left unreported.
    func track(_ event: AnalyticsEvent) {
        // Intentionally empty: this client performs no analytics work.
    }
}
