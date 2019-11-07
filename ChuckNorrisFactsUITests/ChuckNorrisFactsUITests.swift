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
        XCTAssertNotNil(shareFactAndGetActivityView())
    }

    func testShareFactWithErrorAndCache() {
        //Request with success to generate cache
        let errorMessage = "An unexpected error occurred, please try again later."
        app.launchArguments = ["MockNetwork"]
        app.launch()
        makeRequest()
        //Finish application
        app.terminate()
        //Relaunch to see error with facts cached
        app.launchArguments = ["MockNetworkError"]
        app.launch()
        let shareButtonExist = self.app.buttons["Share Button"].firstMatch.exists
        XCTAssertTrue(shareButtonExist)
        makeRequest()
        let networkError = app.staticTexts[errorMessage].exists
        XCTAssertNotNil(networkError)
    }

    func testRequestAndShareFactByCategoryWithSuccess() {
        app.launchArguments = ["MockNetwork"]
        app.launch()
        sleep(2)
        app.buttons["Search Button"].tap()
        app.buttons["Search Fact View"].firstMatch.tap()
        XCTAssertNotNil(shareFactAndGetActivityView())
    }

    func testShareFactsCached() {
        app.launchArguments = ["MockNetwork"]
        app.launch()
        makeRequest()
        //Finish application
        app.terminate()
        //Relaunch to see error with facts cached
        app.launchArguments = ["MockNetwork"]
        app.launch()
        XCTAssertNotNil(shareFactAndGetActivityView())
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

    private func shareFactAndGetActivityView() -> XCUIElement? {
       let shareButtons = self.app.buttons["Share Button"].firstMatch
       shareButtons.tap()
       return app.otherElements["ActivityListView"]
    }
}
