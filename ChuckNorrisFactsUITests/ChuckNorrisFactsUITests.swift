//
//  ChuckNorrisFactsUITests.swift
//  ChuckNorrisFactsUITests
//
//  Created by Lucas César  Nogueira Fonseca on 21/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import XCTest

class ChuckNorrisFactsUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func testRequestAndShareFactWithSuccess() {
        app.launchArguments = ["MockNetwork", "ClearCoreData"]
        app.launch()
        let noFats = app.staticTexts["Search and share my facts now!"].exists
        XCTAssertTrue(noFats)
        app.buttons["Search Button"].tap()
        app.textFields["Search Fact View"].tap()
        app.buttons["Return"].tap()
        let shareButtons = self.app.buttons["Share Button"].firstMatch
        shareButtons.tap()
        let shareView = app.otherElements["ActivityListView"]
        XCTAssertNotNil(shareView)
    }

    func testShareFactsCached() {
        app.launchArguments = ["MockNetwork"]
        app.launch()
        let shareButtons = self.app.buttons["Share Button"].firstMatch
        shareButtons.tap()
        let shareView = app.otherElements["ActivityListView"]
        XCTAssertNotNil(shareView)
    }

    func testShareFactWithError() {
        let errorMessage = "An unexpected error occurred, please try again later."
        app.launchArguments = ["MockNetworkError", "ClearCoreData"]
        app.launch()
        let noFats = app.staticTexts["Search and share my facts now!"].exists
        XCTAssertTrue(noFats)
        app.buttons["Search Button"].tap()
        app.textFields["Search Fact View"].tap()
        app.buttons["Return"].tap()
        let networkError = app.staticTexts[errorMessage].exists
        XCTAssertNotNil(networkError)
    }
}
