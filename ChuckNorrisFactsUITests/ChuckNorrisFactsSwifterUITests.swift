//
//  ChuckNorrisFactsSwifterUITests.swift
//  ChuckNorrisFactsUITests
//
//  Created by Lucas Cesar Nogueira Fonseca on 20/05/21.
//  Copyright © 2021 Lucas César  Nogueira Fonseca. All rights reserved.
//

import XCTest
import Swifter

class ChuckNorrisFactsSwifterUITests: XCTestCase, ExpectationHelpable {
    let app = XCUIApplication()
    let server = HttpServer()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launchEnvironment = ["baseURL": "http://localhost:8080"]
        app.launchArguments = ["ClearCoreData"]
    }

    override func tearDown() {
        server.stop()
        super.tearDown()
    }

    func testRequestAndShareFactWithSuccess() throws {
        server["/jokes/categories"] = { request in
            print(request.body)
            return .ok(.text(self.categories))
        }

        server["/jokes/search?query="] = { request in
            print(request.body)
            return .ok(.text(self.factsData))
        }

        try server.start()
        app.launch()

        let noFats = app.staticTexts["Search and share my facts now!"].exists
        XCTAssertTrue(noFats)
        makeRequest()
        XCTAssertTrue(shareFact())
    }

    func testFailireOnTheSecondAttempt() throws {
        let errorMessage = "An unexpected error occurred, please try again later."
        var requestCounter = SafetyCounter()

        server["/jokes/categories"] = { _ in
            return .ok(.text(self.categories))
        }

        server["/jokes/search?query="] = { _ in
            requestCounter.count()
            if requestCounter.value == 1 {
                return HttpResponse.ok(.text(self.factsData))
            } else {
                return HttpResponse.notFound
            }
        }

        try server.start()
        app.launch()

        let noFats = app.staticTexts["Search and share my facts now!"].exists
        XCTAssertTrue(noFats)
        makeRequest()
        waitForExistence(of: self.app.buttons["Share Button"].firstMatch)
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

    private let categories = """
        [
            "animal",
            "career",
            "celebrity",
            "dev",
            "explicit",
            "fashion",
            "food",
            "history",
            "money",
            "movie",
            "music",
            "political",
            "religion",
            "science",
            "sport",
            "travel"
        ]
    """

    private let factsData = """
        {
            "total":4,
            "result":
            [
                {
                    "categories":["Testedesucesso","Arrolaaaaaaa", "Tentando mais um"],
                    "created_at":"2016-05-01 10:51:41.584544",
                    "icon_url":"https://assets.chucknorris.host/img/avatar/chuck-norris.png",
                    "id":"JJAAmEyFQcqlWInDZcvTJg","updated_at":"2016-05-01 10:51:41.584544",
                    "url":"https://api.chucknorris.io/jokes/JJAAmEyFQcqlWInDZcvTJg",
                    "value":"CHuck Norris' Mother has a tatoo of Chuck Norris on her right bicep."
                },
                {
                    "categories":[],
                    "created_at":"2016-05-01 10:51:41.584544",
                    "icon_url":"https://assets.chucknorris.host/img/avatar/chuck-norris.png",
                    "id":"ee1C4k1lTD6jT7KfES7Sng","updated_at":"2016-05-01 10:51:41.584544",
                    "url":"https://api.chucknorris.io/jokes/ee1C4k1lTD6jT7KfES7Sng",
                    "value":"That is not a normal tatoo of a screaming eagle on Chuck Norris' back! It is in fact, self applied body art that he created with an Acetylene welding torch and Napalm."
                },
                {
                    "categories":[],
                    "created_at":"2016-05-01 10:51:41.584544",
                    "icon_url":"https://assets.chucknorris.host/img/avatar/chuck-norris.png",
                    "id":"e_EDH2ZFQ-KK9MpBIBFLTw","updated_at":"2016-05-01 10:51:41.584544",
                    "url":"https://api.chucknorris.io/jokes/e_EDH2ZFQ-KK9MpBIBFLTw",
                    "value":"Chuck Norris' orgasms have been known to trigger avalanches throughout Europe, volcanic eruptions around the Pacific Rim and violent political unrest across Tatooine."
                },
                {
                    "categories":[],
                    "created_at":"2018-05-01 10:51:41.584544",
                    "icon_url":"https://assets.chucknorris.host/img/avatar/chuck-norris.png",
                    "id":"JJAAmEyFQcqlWInDZvCTJg","updated_at":"2018-05-01 10:51:41.584544",
                    "url":"https://api.chucknorris.io/jokes/JJAAmEyFQcqlWInDZcvTJg",
                    "value":"CHuck Norris' tests."
                }
            ]
        }
   """
}
