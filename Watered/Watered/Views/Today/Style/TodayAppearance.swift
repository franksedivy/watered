//
//  TodayAppearance.swift
//  Watered
//
//  Created by Frank Sedivy on 29/08/2026.
//

import SwiftUI

// MARK: - Today Appearance
//
// Purpose:
// Stores parent-level visual values used by the Today screen.
//
// Input:
// This type does not accept model data. Some values are fixed screen constants,
// while backgroundGradient(for:) accepts a TodayScreenMode.
//
// Returns:
// SwiftUI styling values used by TodayView, such as gradients, padding and the
// shared control glass tint.
//
// UI role:
// Keeps TodayView focused on screen composition and state routing instead of
// owning raw color and spacing values.
struct TodayAppearance {
    let screenHorizontalPadding: CGFloat = 16
    let bottomBarHorizontalPadding: CGFloat = 22
    let bottomBarBottomPadding: CGFloat = 8
    let controlGlassTint = Color.black.opacity(0.6)
    
    // Purpose: Chooses the background gradient for a Today mode.
    //
    // Input: Accepts the current TodayScreenMode.
    //
    // Returns:
    // The yellow empty-state gradient for .empty, otherwise the blue active-state
    // gradient.
    //
    // UI role:
    // Keeps state-based background styling outside TodayView while still keeping
    // the styling local to the Today feature.
    func backgroundGradient(for mode: TodayScreenMode) -> LinearGradient {
        switch mode {
        case .empty:
            return emptyBackgroundGradient
        
        case .firstDrink, .inProgress, .goalReached:
            return activeBackgroundGradient
        }
    }
    
    private let activeBackgroundGradient = LinearGradient(
        colors: [
            Color(red: 128.0 / 255.0, green: 195.0 / 255.0, blue: 243.0 / 255.0),
            Color(red: 74.0 / 255.0, green: 144.0 / 255.0, blue: 226.0 / 255.0)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    private let emptyBackgroundGradient = LinearGradient(
        colors: [
            Color(red: 226.0 / 255.0, green: 196.0 / 255.0, blue: 84.0 / 255.0),
            Color(red: 211.0 / 255.0, green: 166.0 / 255.0, blue: 41.0 / 255.0)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}
