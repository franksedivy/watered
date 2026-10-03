//
//  AnalyticsClient.swift
//  Watered
//
//  Created by Frank Sedivy on 02/10/2026.
//

/// Deifnes how Watered reports product interactions.
///
/// Implementations decide how to handle an event. Callers do not need to know
/// about debug logging or a future analytics provider.
///
/// Analytics runs on the main actor alongside app actions and store updates.
@MainActor
protocol AnalyticsClient {
    /// Records a product interaction using its explicitly allowed properties.
    ///
    /// - Parameter event: The interaction to report.
    /// - Important: Analytics must not determine whether an app action succeeds.
    func track(_ event: AnalyticsEvent)
}
