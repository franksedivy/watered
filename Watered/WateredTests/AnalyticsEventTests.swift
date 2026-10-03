//
//  AnalyticsEventTests.swift
//  Watered
//
//  Created by Frank Sedivy on 03/10/2026.
//

import Testing
@testable import Watered

@MainActor
struct AnalyticsEventTests {
    
    // GIVEN form and recent-drink logging methods, when their analytics values are read,
    // THEN they use the expected stable labels.
    @Test func drinkLoggingMethodsUseStableLabels() {
        #expect(AnalyticsEvent.DrinkLoggingMethod.form.rawValue == "form")
        #expect(AnalyticsEvent.DrinkLoggingMethod.recent.rawValue == "recent")
    }
    
    // GIVEN drinks added through different interactions, when their events are compared,
    // THEN the logging method distringuises those events.
    @Test func drinkAddedEventsDistinguishLoggingMethods() {
        let formEvent = AnalyticsEvent.drinkAdded(method: .form)
        let recentEvent = AnalyticsEvent.drinkAdded(method: .recent)
        
        #expect(formEvent != recentEvent)
    }
}
