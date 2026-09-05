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
    var body: some Scene {
        WindowGroup {
            WateredRootView()
        }
        .modelContainer(for: PersistentDrinkEntry.self)
    }
}
