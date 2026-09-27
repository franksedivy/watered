//
//  AppSettingsPersistenceTests.swift
//  Watered
//
//  Created by Frank Sedivy on 27/09/2026.
//

import Foundation
import Testing
import SwiftData
@testable import Watered

@MainActor
struct AppSettingsPersistenceTests {
    // MARK: - App Settings Persistence

    // Given an empty store, when settings are loaded twice, then one settings
    // record and one default-goal record are saved with their original timestamps.
    @MainActor
    @Test func loadingSettingsCreatesInitialGoalHistoryOnlyOnce() throws {
        let container = try ModelContainer(
            for: PersistentAppSettings.self,
            PersistentHydrationGoalChange.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let context = container.mainContext
        let defaults = AppSettings.defaults(for: Locale(identifier: "en_GB"))
        let initialDate = Date(timeIntervalSince1970: 1000)
        let laterDate = Date(timeIntervalSince1970: 2000)

        let initialSettings = try AppSettingsPersistence.loadOrCreate(
            defaults: defaults,
            in: context,
            at: initialDate
        )
        let loadedSettings = try AppSettingsPersistence.loadOrCreate(
            defaults: defaults,
            in: context,
            at: laterDate
        )

        #expect(initialSettings.persistentModelID == loadedSettings.persistentModelID)

        // Read through a separate context to check saved records.
        let verificationContext = ModelContext(container)
        let settingsRecords = try verificationContext.fetch(
            FetchDescriptor<PersistentAppSettings>()
        )
        let historyRecords = try verificationContext.fetch(
            FetchDescriptor<PersistentHydrationGoalChange>()
        )

        #expect(settingsRecords.count == 1)
        #expect(historyRecords.count == 1)

        let settings = try #require(settingsRecords.first)
        let history = try #require(historyRecords.first)

        #expect(settings.displayUnitID == defaults.displayUnit.persistenceIdentifier)
        #expect(settings.dailyGoalValue == defaults.dailyHydrationGoal.amount.value)
        #expect(settings.dailyGoalUnitID == "milliliters")
        #expect(settings.createdAt == initialDate)
        #expect(settings.updatedAt == initialDate)
        #expect(history.goalValue == settings.dailyGoalValue)
        #expect(history.goalUnitID == settings.dailyGoalUnitID)
        #expect(history.changedAt == initialDate)
        #expect(history.source == HydrationGoalSource.appDefault.rawValue)
    }
    
    // Given saved settings and initial goal history, when a different goal is committed,
       // then settings reflect the new goal and one manual record is appended without
       // changing the original default-goal record.
       @Test func savingChangedGoalUpdatesSettingsAndPreservesHistory() throws {
           let container = try ModelContainer(
               for: PersistentAppSettings.self,
               PersistentHydrationGoalChange.self,
               configurations: ModelConfiguration(isStoredInMemoryOnly: true)
           )
           let context = container.mainContext
           let defaults = AppSettings.defaults(for: Locale(identifier: "en_GB"))
           let initialDate = Date(timeIntervalSince1970: 1000)
           let changedDate = Date(timeIntervalSince1970: 2000)
           let settings = try AppSettingsPersistence.loadOrCreate(
               defaults: defaults,
               in: context,
               at: initialDate
           )
           let initialRecords = try context.fetch(
               FetchDescriptor<PersistentHydrationGoalChange>()
           )
           let originalID = try #require(initialRecords.first).id
           let newGoal = HydrationGoal(amount: DrinkAmount(value: 3000, unit: .milliliters))

           let didChange = try AppSettingsPersistence.saveGoal(
               newGoal,
               source: .manual,
               settings: settings,
               in: context,
               at: changedDate
           )

           let verificationContext = ModelContext(container)
           let savedSettings = try verificationContext.fetch(
               FetchDescriptor<PersistentAppSettings>()
           )
           let history = try verificationContext.fetch(
               FetchDescriptor<PersistentHydrationGoalChange>(
                   sortBy: [SortDescriptor(\.changedAt)]
               )
           )

           #expect(didChange)
           #expect(savedSettings.count == 1)
           #expect(history.count == 2)

           let saved = try #require(savedSettings.first)
           let original = try #require(history.first)
           let latest = try #require(history.last)

           #expect(saved.dailyGoalValue == 3000)
           #expect(saved.dailyGoalUnitID == "milliliters")
           #expect(saved.createdAt == initialDate)
           #expect(saved.updatedAt == changedDate)
           #expect(original.id == originalID)
           #expect(original.goalValue == defaults.dailyHydrationGoal.amount.value)
           #expect(original.goalUnitID == "milliliters")
           #expect(original.changedAt == initialDate)
           #expect(original.source == HydrationGoalSource.appDefault.rawValue)
           #expect(latest.id != originalID)
           #expect(latest.goalValue == saved.dailyGoalValue)
           #expect(latest.goalUnitID == saved.dailyGoalUnitID)
           #expect(latest.changedAt == changedDate)
           #expect(latest.source == HydrationGoalSource.manual.rawValue)
       }
    
    // Given saved settings and initial goal history, when the same goal is submitted,
    // then no change is reported, no history is appended, and timestamps stay unchanged.
    @Test func savingUnchangedGoalPreservesHistoryAndTimestamps() throws {
        let container = try ModelContainer(
            for: PersistentAppSettings.self,
            PersistentHydrationGoalChange.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let context = container.mainContext
        let defaults = AppSettings.defaults(for: Locale(identifier: "en_GB"))
        let initialDate = Date(timeIntervalSince1970: 1000)
        let laterDate = Date(timeIntervalSince1970: 2000)
        let settings = try AppSettingsPersistence.loadOrCreate(
            defaults: defaults,
            in: context,
            at: initialDate
        )
        let initialRecords = try context.fetch(
            FetchDescriptor<PersistentHydrationGoalChange>()
        )
        let originalID = try #require(initialRecords.first).id

        let didChange = try AppSettingsPersistence.saveGoal(
            defaults.dailyHydrationGoal,
            source: .manual,
            settings: settings,
            in: context,
            at: laterDate
        )

        #expect(!didChange)
        #expect(!context.hasChanges)

        let verificationContext = ModelContext(container)
        let savedSettings = try verificationContext.fetch(
            FetchDescriptor<PersistentAppSettings>()
        )
        let history = try verificationContext.fetch(
            FetchDescriptor<PersistentHydrationGoalChange>()
        )

        #expect(savedSettings.count == 1)
        #expect(history.count == 1)

        let saved = try #require(savedSettings.first)
        let original = try #require(history.first)

        #expect(saved.dailyGoalValue == defaults.dailyHydrationGoal.amount.value)
        #expect(saved.dailyGoalUnitID == "milliliters")
        #expect(saved.createdAt == initialDate)
        #expect(saved.updatedAt == initialDate)
        #expect(original.id == originalID)
        #expect(original.goalValue == saved.dailyGoalValue)
        #expect(original.goalUnitID == saved.dailyGoalUnitID)
        #expect(original.changedAt == initialDate)
        #expect(original.source == HydrationGoalSource.appDefault.rawValue)
    }
    
    // Given a saved goal, when its unit changes but its numeric value stays the same,
    // then the new unit is saved and a separate goal-history record is appended.
    @Test func savingGoalWithDifferentUnitRecordsAChange() throws {
        let container = try ModelContainer(
            for: PersistentAppSettings.self,
            PersistentHydrationGoalChange.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let context = container.mainContext
        let initialDate = Date(timeIntervalSince1970: 1000)
        let changedDate = Date(timeIntervalSince1970: 2000)
        let defaults = AppSettings(
            displayUnit: .usFluidOunces,
            dailyHydrationGoal: HydrationGoal(
                amount: DrinkAmount(value: 90, unit: .usFluidOunces)
            )
        )
        let settings = try AppSettingsPersistence.loadOrCreate(
            defaults: defaults,
            in: context,
            at: initialDate
        )
        let newGoal = HydrationGoal(
            amount: DrinkAmount(value: 90, unit: .imperialFluidOunces)
        )

        let didChange = try AppSettingsPersistence.saveGoal(
            newGoal,
            source: .manual,
            settings: settings,
            in: context,
            at: changedDate
        )

        let verificationContext = ModelContext(container)
        let savedSettings = try verificationContext.fetch(
            FetchDescriptor<PersistentAppSettings>()
        )
        let history = try verificationContext.fetch(
            FetchDescriptor<PersistentHydrationGoalChange>(
                sortBy: [SortDescriptor(\.changedAt)]
            )
        )
        let saved = try #require(savedSettings.first)
        let original = try #require(history.first)
        let latest = try #require(history.last)

        #expect(didChange)
        #expect(history.count == 2)
        #expect(saved.dailyGoalValue == 90)
        #expect(saved.dailyGoalUnitID == "imperialFluidOunces")
        #expect(saved.updatedAt == changedDate)
        #expect(original.goalValue == 90)
        #expect(original.goalUnitID == "usFluidOunces")
        #expect(latest.goalValue == 90)
        #expect(latest.goalUnitID == "imperialFluidOunces")
        #expect(latest.changedAt == changedDate)
        #expect(latest.source == HydrationGoalSource.manual.rawValue)
    }
}
