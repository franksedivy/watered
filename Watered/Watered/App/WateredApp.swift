//
//  WateredApp.swift
//  Watered
//
//  Created by Frank Sedivy on 26/06/2026.
//

import SwiftUI
import SwiftData

@main
struct WateredApp: App {
    
    // MARK: - Dependencies
    
    /// Selects the analytics implementation for the current build.
    ///
    /// Debug builds report events through the local debug log.
    /// Release builds discard events. Neither implementation sends network data.
    private var analytics: any AnalyticsClient {
        #if DEBUG
        return DebugAnalyticsClient()
        #else
        return NoOpAnalyticsClient()
        #endif
    }
    
    // MARK: - UI Test Configuration
    
    /// Whether this launch uses an isolated, in-memory data store for UI tests.
    ///
    /// Returns true only when a Debug build recieves the
    /// - 'uiTestingInMemory' launch argument.
    ///
    /// - Important: Release builds always use persistent storage, regardless of launch arguments.
    private var usesInMemoryStoreage: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.arguments.contains("-uiTestingInMemory")
        #else
        return false
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            WateredRootView(analytics: analytics)
        }
        .modelContainer(
            for: [
                PersistentDrinkEntry.self,
                PersistentAppSettings.self,
                PersistentHydrationGoalChange.self
            ],
            inMemory: usesInMemoryStoreage
        )
    }
}
