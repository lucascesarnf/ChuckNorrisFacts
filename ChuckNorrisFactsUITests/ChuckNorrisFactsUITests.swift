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
        makeRequest()
        XCTAssertTrue(shareFact())
    }

    func testShareFactWithErrorAndCache() {
        let errorMessage = "An unexpected error occurred, please try again later."
        app.launchArguments = ["MockNetwork", "ClearCoreData"]
        app.launch()
        makeRequest()

        app.terminate()

        app.launchArguments = ["MockNetworkError"]
        app.launch()
        let shareButtonExist = self.app.buttons["Share Button"].firstMatch.exists
        XCTAssertTrue(shareButtonExist)
        makeRequest()
        let networkError = app.staticTexts[errorMessage].exists
        XCTAssertNotNil(networkError)
    }

    func testRequestAndShareFactByCategoryWithSuccess() {
        app.launchArguments = ["MockNetwork", "ClearCoreData"]
        app.launch()
        sleep(1)
        app.buttons["Search Button"].tap()
        app.buttons["Search Fact View"].firstMatch.tap()
        XCTAssertTrue(shareFact())
    }

    func testShareFactsCached() {
        app.launchArguments = ["MockNetwork"]
        app.launch()
        XCTAssertTrue(shareFact())
    }

    func testShareFactWithError() {
        let errorMessage = "An unexpected error occurred, please try again later."
        app.launchArguments = ["MockNetworkError", "ClearCoreData"]
        app.launch()
        let noFats = app.staticTexts["Search and share my facts now!"].exists
        XCTAssertTrue(noFats)
        makeRequest()
        let networkError = app.staticTexts[errorMessage].exists
        XCTAssertNotNil(networkError)
    }

    private func makeRequest() {
        app.buttons["Search Button"].tap()
        app.textFields["Search Fact View"].tap()
        app.buttons["Return"].tap()
    }

    private func shareFact() -> Bool {
       let shareButtons = self.app.buttons["Share Button"].firstMatch
       shareButtons.tap()
        let element = app.otherElements["ActivityListView"].firstMatch
        return element.exists
    }
}
