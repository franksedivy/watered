//
//  ProfileUITests.swift
//  Watered
//
//  Created by Frank Sedivy on 27/09/2026.
//

import XCTest

final class ProfileUITests: XCTestCase {
    // Given an isolated app, when the goal is edited several times and Profile
    // is dismissed, then reopening Profile shows the final selected goal.
    @MainActor
    func testDismissingProfileCommitsFinalGoal() throws {
        continueAfterFailure = false

        let app = XCUIApplication()
        app.launchArguments = [
            "-uiTestingInMemory",
            "-AppleLanguages", "(en)",
            "-AppleLocale", "en_GB"
        ]
        app.launch()

        let profileButton = app.buttons["profileButton"]
        XCTAssertTrue(profileButton.waitForExistence(timeout: 3))
        profileButton.tap()

        let goalText = app.staticTexts["dailyHydrationGoalText"]
        XCTAssertTrue(goalText.waitForExistence(timeout: 3))
        XCTAssertEqual(goalText.label, "Daily goal: 2700 ml")

        let incrementButton = app.steppers["dailyHydrationGoalStepper"]
            .buttons["dailyHydrationGoalStepper-Increment"]
        XCTAssertTrue(incrementButton.waitForExistence(timeout: 3))

        incrementButton.tap()
        incrementButton.tap()
        incrementButton.tap()

        XCTAssertTrue(
            goalText.wait(for: \.label, toEqual: "Daily goal: 3000 ml", timeout: 3)
        )

        let profileNavigationBar = app.navigationBars["Profile"]
        XCTAssertTrue(profileNavigationBar.waitForExistence(timeout: 3))
        profileNavigationBar.swipeDown()
        XCTAssertTrue(goalText.waitForNonExistence(timeout: 3))

        XCTAssertTrue(profileButton.waitForExistence(timeout: 3))
        profileButton.tap()

        XCTAssertTrue(goalText.waitForExistence(timeout: 3))
        XCTAssertTrue(
            goalText.wait(for: \.label, toEqual: "Daily goal: 3000 ml", timeout: 3)
        )
    }
}
