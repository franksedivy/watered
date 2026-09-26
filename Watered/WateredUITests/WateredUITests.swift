//
//  WateredUITests.swift
//  WateredUITests
//
//  Created by Frank Sedivy on 26/06/2026.
//

import XCTest

final class WateredUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Test Helpers
    //
    // Purpose:
    // Launches the app with predictable starting conditions for UI flow tests.
    //
    // Returns:
    // The launched applicaiton, ready for the test to interact with.
    //
    // Behavior:
    // Uses an empty in-memory store and an English/UK locale so previous
    // drinks and settings cannot affect tests that expect millilitre values.
    @MainActor
    private func launchIsolatedApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = [
            "-uiTestingInMemory",
            "-AppLanguages", "(en)",
            "-AppleLocale", "en_GB"
        ]
        app.launch()
        return app
    }

    @MainActor
    func testAppLaunchesToTodayScreen() throws {
        // Purpose: Proves that Watered launches into the main Today sexperience
        //
        // Behavior:
        // This is intentionally a smoke test. It does not check layout, color,
        // typography, or exact copy. It only checks for the stable Today screen
        // accessibility identifier.
        let app = launchIsolatedApp()
        
        let todayScreen = app.otherElements["todayScreen"]
        XCTAssertTrue(todayScreen.waitForExistence(timeout: 2))
    }
    
    @MainActor
    func testAddDrinkActionButtonExists() throws {
        // Purpose:
        // Proves that the Today screen exposes the add-drink action.
        //
        // Behavior:
        // This test only checks for the stable accessibility identifier on the
        // floating add-drink button. It does not care where the button sits visually.
        let app = launchIsolatedApp()
        
        let addDrinkButton = app.buttons["addDrinkActionButton"]
        XCTAssertTrue(addDrinkButton.waitForExistence(timeout: 2))
    }
    
    @MainActor
    func testTappingAddDrinkActionShowsAddDrinkSheet() throws {
        // Purpose:
        // Proves that the floating add-drink action opens the temporary Add Drink flow.
        //
        // Behvaior:
        // This test checks the navigation from Today into the sheet. It does not add a
        // drink yet, so failure are easier to understand if sheet presentation breaks.
        let app = launchIsolatedApp()
        
        let addDrinkButton = app.buttons["addDrinkActionButton"]
        XCTAssertTrue(addDrinkButton.waitForExistence(timeout: 2))
        
        addDrinkButton.tap()
        
        let addDrinkSubmitButton = app.buttons["addDrinkSubmitButton"]
        XCTAssertTrue(addDrinkSubmitButton.waitForExistence(timeout: 2))
    }
    
    @MainActor
    func testAddingDrinkUpdatesTodayTotalAmount() throws {
        // Purpose:
        // Proves that adding a drink updates the Today summary.
        //
        // Behvaior:
        // This test does not yet assert an exact amount.
        // It only checks that the total amount text changes away from the empty
        // starting value after a drink is added.
        let app = launchIsolatedApp()
        
        let addDrinkButton = app.buttons["addDrinkActionButton"]
        XCTAssertTrue(addDrinkButton.waitForExistence(timeout: 2))
        
        addDrinkButton.tap()
        
        let addDrinkSubmitButton = app.buttons["addDrinkSubmitButton"]
        XCTAssertTrue(addDrinkSubmitButton.waitForExistence(timeout: 2))
        
        addDrinkSubmitButton.tap()
        
        let updatedTotalAmount = app.staticTexts["330 ml"]
        XCTAssertTrue(
            updatedTotalAmount.waitForExistence(timeout: 2),
            "Today should show the default Add Drink form submission as 330 ml"
        )
    }
    
    @MainActor
    func testAddingDrinkWithSelectedVolumeUpdatesTodayTotalAmount() throws {
        // Purpose:
        // Proves that the Add Drink form uses the selected volume, not only the
        // default form value.
        //
        // Behavior:
        // Opens Add Drink, adjusts the volume wheel from its default value to
        // 500 ml, submits the drink, and checks that Today shows the selected
        // amount
        let app = launchIsolatedApp()
        
        let addDrinkButton = app.buttons["addDrinkActionButton"]
        XCTAssertTrue(addDrinkButton.waitForExistence(timeout: 2))
        
        addDrinkButton.tap()
        
        let volumePickerWheel = app.pickerWheels.firstMatch
        XCTAssertTrue(volumePickerWheel.waitForExistence(timeout: 2))
        
        volumePickerWheel.adjust(toPickerWheelValue: "500 ml")
        
        let addDrinkSubmitButton = app.buttons["addDrinkSubmitButton"]
        XCTAssertTrue(addDrinkSubmitButton.waitForExistence(timeout: 2))
        
        addDrinkSubmitButton.tap()
        
        let updatedTotalAmount = app.staticTexts["500 ml"]
        XCTAssertTrue(
            updatedTotalAmount.waitForExistence(timeout: 2),
            "Today should show the manually selected Add Drink volume as 500 ml"
        )
    }
    
    @MainActor
    func testAddingMultipleDrinksKeepsTodayUsable() throws {
        // Purpose: Proves that repeated drink additions do not break the Today flow
        //
        // Behvaior:
        // Each add goes through the same user path: open the sheet, tap the temporary
        // add button, return to Today. The test does not care which random drinks are
        // selected or waht exact totals are shown.
        let app = launchIsolatedApp()
        
        for addDrinkAttempt in 1...3 {
            let addDrinkButton = app.buttons["addDrinkActionButton"]
            XCTAssertTrue(addDrinkButton.waitForExistence(timeout: 2))
            
            addDrinkButton.tap()
            
            let addDrinkSubmitButton = app.buttons["addDrinkSubmitButton"]
            XCTAssertTrue(addDrinkSubmitButton.waitForExistence(timeout: 2))
            
            addDrinkSubmitButton.tap()
            
            let totalAmountText = app.staticTexts["todayTotalAmountText"]
            XCTAssertTrue(
                totalAmountText.waitForExistence(timeout: 2),
                "Total amount should exist after add attempt \(addDrinkAttempt)"
            )
        }
    }
    
    // Given an empty history, when a drink is logged and its recent shortcut
    // is tapped, then Recents appears, another drink is added, and the sheet
    // closes without requiring the submit button again.
    @MainActor
    func testAddingRecentDrinkUpdatesTodayTotalAmount() throws {
        let app = launchIsolatedApp()
        
        let addDrinkButton = app.buttons["addDrinkActionButton"]
        XCTAssertTrue(addDrinkButton.waitForExistence(timeout: 3))
        addDrinkButton.tap()
        
        let submitButton = app.buttons["addDrinkSubmitButton"]
        XCTAssertTrue(submitButton.waitForExistence(timeout:3))
        
        let recentDrinksRow = app.scrollViews["addDrinkRecentsScrollView"]
        XCTAssertFalse(
            recentDrinksRow.exists,
            "Recents should be hidden before any drinks are logged"
        )
        
        // Create the history that the recent-drink shortcut will use.
        submitButton.tap()
        XCTAssertTrue(submitButton.waitForNonExistence(timeout: 3))
        
        let totalAmountText = app.staticTexts["todayTotalAmountText"]
        XCTAssertTrue(totalAmountText.waitForExistence(timeout: 3))
        XCTAssertTrue(
            totalAmountText.wait(for: \.label, toEqual: "330 ml", timeout: 3),
            "The first drink should bring today's total to 330 ml"
        )
        
        addDrinkButton.tap()
        XCTAssertTrue(submitButton.waitForExistence(timeout: 3))
        XCTAssertTrue(recentDrinksRow.waitForExistence(timeout: 3))
        
        let firstRecentDrinkButton = recentDrinksRow.buttons.firstMatch
        XCTAssertTrue(firstRecentDrinkButton.waitForExistence(timeout: 3))
        firstRecentDrinkButton.tap()
        
        XCTAssertTrue(
            submitButton.waitForNonExistence(timeout: 3),
            "Tapping a recent drink should close the sheet"
        )
        XCTAssertTrue(
            totalAmountText.wait(for: \.label, toEqual: "660 ml", timeout: 3),
            "Repeating the 330 ml drink should bring today's total to 660 ml"
        )
    }

//    @MainActor
//    func testLaunchPerformance() throws {
//        // This measures how long it takes to launch your application.
//        measure(metrics: [XCTApplicationLaunchMetric()]) {
//            XCUIApplication().launch()
//        }
//    }
}
