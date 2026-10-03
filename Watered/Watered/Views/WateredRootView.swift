//
//  WateredRootView.swift
//  Watered
//
//  Created by Frank Sedivy on 30/08/2026.
//

import SwiftUI

// MARK: - Watered Root View

/// Defines Watere's root experience and forwards app-level dependencies
///
/// The tab view owns navigation and sheet presentation. This view connnects that app shell to the dependencies supplied
/// at launch.
struct WateredRootView: View {
    
    // MARK: - Dependencies
    
    /// The analytics client passed to the app shell.
    private let analytics: any AnalyticsClient
    
    // MARK: - Initialisation
    
    /// Creates the root experience without analytics reporting
    @MainActor
    init() {
        self.init(analytics: NoOpAnalyticsClient())
    }
    
    /// Creates the root experience with the supplied analytics client.
    ///
    /// - Parameter analytics: The client forwarded to the app shell.
    @MainActor
    init(analytics: any AnalyticsClient) {
        self.analytics = analytics
    }
    
    // MARK: - Body
    
    var body: some View {
        WateredTabView(analytics: analytics)
    }
}

#Preview {
    WateredRootView()
}
