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
    
    // MARK: - UI Test Configuration
    //
    // Purpose:
    // Allows Debug UI tests to request an empty, temporary data store.
    //
    // Returns:
    // True only when a Debug build recieves the isolated-storage launch argument.
    //
    // Behavior:
    // Release builds always use persistent storage, regardless of launch arguments.
    private var usesInMemoryStoreage: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.arguments.contains("-uiTestingInMemory")
        #else
        return false
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            WateredRootView()
        }
        .modelContainer(
            for: [PersistentDrinkEntry.self, PersistentAppSettings.self],
            inMemory: usesInMemoryStoreage
        )
    }
}
