//
//  WateredDebug.swift
//  Watered
//
//  Created by Frank Sedivy on 01/07/2026.
//

import Foundation

#if DEBUG
import OSLog

private let wateredDebugLogger = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "com.franksedivy.watered-ios",
    category: "debug"
)
#endif

// Writes a Watered-only debug message to Apple's unified logging system.
//
// Input:
// - message: A short, non-personal message describing an app-level action,
//   state change, or handoff.
//
// Behavior:
// Logs only in DEBUG builds. Release builds leave this helper as a no-op so
// temporary development logging does not become production telemetry.
func wateredLog(_ message: String) {
    #if DEBUG
    wateredDebugLogger.debug("\(message, privacy: .public)")
    #endif
}
